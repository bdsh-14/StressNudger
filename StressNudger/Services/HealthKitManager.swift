//
//  HealthKitManager.swift
//  StressNudger
//
//  Created by Bidisha Biswas on 12/15/25.
//

import Foundation
import HealthKit
import Combine

class HealthKitManager: ObservableObject {
	private let healthStore = HKHealthStore()

	@Published var currentHeartRate: Double = 0
	@Published var isAuthorized: Bool = false

	func requestAuthorization() {
		guard HKHealthStore.isHealthDataAvailable() else {
			print("HealthKit not available on this device")
			return
		}

		let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!

		healthStore.requestAuthorization(toShare: [], read: [heartRateType]) { success, error in
			DispatchQueue.main.async {
				self.isAuthorized = success
				if success {
					print("✅ HealthKit authorized")
					self.startHeartRateQuery()
				} else if let error = error {
					print("❌ HealthKit authorization failed: \(error)")
				}
			}
		}
	}

	private func startHeartRateQuery() {
		let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!

		// Query for most recent heart rate
		let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

		let query = HKSampleQuery(
			sampleType: heartRateType,
			predicate: nil,
			limit: 1,
			sortDescriptors: [sortDescriptor]
		) { query, samples, error in
			self.processHeartRateSamples(samples)
		}

		healthStore.execute(query)

		// Also set up continuous updates
		let anchoredQuery = HKAnchoredObjectQuery(
			type: heartRateType,
			predicate: nil,
			anchor: nil,
			limit: HKObjectQueryNoLimit
		) { query, samples, deletedObjects, anchor, error in
			self.processHeartRateSamples(samples)
		}

		anchoredQuery.updateHandler = { query, samples, deletedObjects, anchor, error in
			self.processHeartRateSamples(samples)
		}

		healthStore.execute(anchoredQuery)
	}

	private func processHeartRateSamples(_ samples: [HKSample]?) {
		guard let samples = samples as? [HKQuantitySample],
			  let sample = samples.first else {
			return
		}

		let heartRate = sample.quantity.doubleValue(for: HKUnit.count().unitDivided(by: .minute()))

		DispatchQueue.main.async {
			self.currentHeartRate = heartRate
			print("❤️ Heart rate: \(heartRate) bpm")
		}
	}
}

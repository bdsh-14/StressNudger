//
//  StressDetectionManager.swift
//  StressNudger
//
//  Created by Bidisha Biswas on 11/23/25.
//

import Foundation
import Combine
import UIKit

class StressDetectionManager: ObservableObject {
	@Published var currentStressLevel: Double = 0.0
	@Published var isStressed: Bool = false

	private let featureExtractor = ScrollFeatureExtractor()
	private let model = StressModel()
	private let stressThreshold: Double = 0.85

	private var lastInferenceTime = Date()
	private let inferenceInterval: TimeInterval = 2.0
	private var stressHistory: [Double] = []
	private let historySize = 5
	private var lastHapticTime = Date.distantPast

	var currentHeartRate: Double?

	func processScrollMetrics(_ metrics: ScrollMetrics) {
		print("🔵 Processing metrics: velocity=\(metrics.velocity)")
		featureExtractor.addMetrics(metrics)

		let now = Date()
		guard now.timeIntervalSince(lastInferenceTime) >= inferenceInterval else {
			return
		}
		lastInferenceTime = now

		print("🟢 Running inference...")
		detectStress()
	}

	private func detectStress() {
		guard let features = featureExtractor.extractFeatures() else {
			print("⚠️ No features extracted yet")
			return
		}

		print("📊 Features: velocity_std=\(features.velocityStdDev), jerkiness=\(features.jerkiness), HR=\(currentHeartRate ?? 0)")

		let stressLevel = model.predict(features: features, heartRate: currentHeartRate)

		// Add to history and smooth
		stressHistory.append(stressLevel)
		if stressHistory.count > historySize {
			stressHistory.removeFirst()
		}

		// Use moving average instead of raw prediction
		let smoothedStress = stressHistory.reduce(0, +) / Double(stressHistory.count)

		print("🎯 Raw: \(stressLevel), Smoothed: \(smoothedStress)")

		DispatchQueue.main.async {
			self.currentStressLevel = smoothedStress  // Use smoothed value
			self.isStressed = smoothedStress > self.stressThreshold
		}

		if isStressed {
			triggerIntervention()
		}
	}

	private func triggerIntervention() {
		// Only trigger haptic if 30 seconds have passed
		let now = Date()
		guard now.timeIntervalSince(lastHapticTime) > 30 else {
			print("⏸️ Haptic cooldown - skipping")
			return
		}
		lastHapticTime = now

		let generator = UINotificationFeedbackGenerator()
		generator.notificationOccurred(.warning)

		print("⚠️ STRESS DETECTED - Haptic triggered!")

		NotificationCenter.default.post(
			name: .stressDetected,
			object: nil,
			userInfo: ["level": currentStressLevel]
		)
	}

	func reset() {
		featureExtractor.reset()
		currentStressLevel = 0.0
		isStressed = false
	}
}

extension Notification.Name {
	static let stressDetected = Notification.Name("stressDetected")
}

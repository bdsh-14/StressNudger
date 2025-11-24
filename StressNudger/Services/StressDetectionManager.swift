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
	private let stressThreshold: Double = 0.7

	private var lastInferenceTime = Date()
	private let inferenceInterval: TimeInterval = 2.0 // Run every 2 seconds

	func processScrollMetrics(_ metrics: ScrollMetrics) {
		featureExtractor.addMetrics(metrics)

		// Run inference periodically
		let now = Date()
		guard now.timeIntervalSince(lastInferenceTime) >= inferenceInterval else {
			return
		}
		lastInferenceTime = now

		detectStress()
	}

	private func detectStress() {
		guard let features = featureExtractor.extractFeatures() else {
			return
		}

		// Get stress prediction
		let stressLevel = model.predict(features: features)

		DispatchQueue.main.async {
			self.currentStressLevel = stressLevel
			self.isStressed = stressLevel > self.stressThreshold
		}

		if isStressed {
			triggerIntervention()
		}
	}

	private func triggerIntervention() {
		// Haptic feedback
		let generator = UINotificationFeedbackGenerator()
		generator.notificationOccurred(.warning)

		// Post notification for UI
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

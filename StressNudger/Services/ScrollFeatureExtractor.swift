//
//  ScrollFeatureExtractor.swift
//  StressNudger
//
//  Created by Bidisha Biswas on 11/23/25.
//

import Foundation

class ScrollFeatureExtractor {
	private var metricsBuffer: [ScrollMetrics] = []
	private let windowSize: TimeInterval = 10.0 // 10-second window

	func addMetrics(_ metrics: ScrollMetrics) {
		metricsBuffer.append(metrics)

		// Keep only recent data within window
		let cutoffTime = Date().addingTimeInterval(-windowSize)
		metricsBuffer.removeAll { $0.timestamp < cutoffTime }
	}

	func extractFeatures() -> ScrollFeatures? {
		guard metricsBuffer.count > 5 else { return nil }

		let velocities = metricsBuffer.map { abs($0.velocity) }
		let accelerations = metricsBuffer.map { $0.acceleration }

		// Velocity statistics
		let meanVelocity = velocities.reduce(0, +) / Double(velocities.count)
		let velocityVariance = velocities.map { pow($0 - meanVelocity, 2) }
			.reduce(0, +) / Double(velocities.count)
		let velocityStdDev = sqrt(velocityVariance)
		let maxVelocity = velocities.max() ?? 0

		// Jerkiness (how erratic the scrolling is)
		let accelerationVariance = accelerations.map { pow($0, 2) }
			.reduce(0, +) / Double(accelerations.count)
		let jerkiness = sqrt(accelerationVariance)

		// Count acceleration direction changes
		var accelerationChanges = 0
		for i in 1..<accelerations.count {
			if (accelerations[i] > 0) != (accelerations[i-1] > 0) {
				accelerationChanges += 1
			}
		}

		// Detect reversals (scroll direction changes)
		var reversals = 0
		let rawVelocities = metricsBuffer.map { $0.velocity }
		for i in 1..<rawVelocities.count {
			if (rawVelocities[i] > 0) != (rawVelocities[i-1] > 0) {
				reversals += 1
			}
		}

		// Detect pauses
		var microPauses = 0
		var longPauses = 0
		for i in 1..<metricsBuffer.count {
			let timeDelta = metricsBuffer[i].timestamp
				.timeIntervalSince(metricsBuffer[i-1].timestamp)
			if timeDelta > 0.1 && timeDelta < 0.5 {
				microPauses += 1
			} else if timeDelta > 2.0 {
				longPauses += 1
			}
		}

		// Temporal features
		let duration = metricsBuffer.last!.timestamp
			.timeIntervalSince(metricsBuffer.first!.timestamp)
		let frequency = Double(metricsBuffer.count) / max(duration, 1.0)

		return ScrollFeatures(
			meanVelocity: meanVelocity,
			velocityStdDev: velocityStdDev,
			maxVelocity: maxVelocity,
			jerkiness: jerkiness,
			accelerationChanges: accelerationChanges,
			scrollReversals: reversals,
			microPauses: microPauses,
			longPauses: longPauses,
			scrollDuration: duration,
			scrollFrequency: frequency
		)
	}

	func reset() {
		metricsBuffer.removeAll()
	}
}

//
//  StressModel.swift
//  StressNudger
//
//  Created by Bidisha Biswas on 11/23/25.
//

import Foundation
import CoreML

class StressModel {
	private let model: StressDetectorML?

	init() {
		do {
			let config = MLModelConfiguration()
			self.model = try StressDetectorML(configuration: config)
			print("✅ CoreML model loaded successfully")
		} catch {
			print("❌ Failed to load CoreML model: \(error)")
			self.model = nil
		}
	}

	/// Predicts stress level using CoreML model with scroll features and optional heart rate
	func predict(features: ScrollFeatures, heartRate: Double? = nil) -> Double {
		guard let model = model else {
			// Fallback to heuristic if model fails to load
			return predictWithHeuristic(features: features, heartRate: heartRate)
		}

		do {
			let input = StressDetectorMLInput(
				meanVelocity: Int64(features.meanVelocity),
				velocityStdDev: Int64(features.velocityStdDev),
				maxVelocity: Int64(features.maxVelocity),
				jerkiness: Int64(features.jerkiness),
				accelerationChanges: Int64(features.accelerationChanges),  // Changed to Int64
				scrollReversals: Int64(features.scrollReversals),          // Changed to Int64
				microPauses: Int64(features.microPauses),                  // Changed to Int64
				longPauses: Int64(features.longPauses),                    // Changed to Int64
				scrollDuration: features.scrollDuration,
				scrollFrequency: Int64(features.scrollFrequency),
				heartRate: Int64(heartRate ?? 70.0)
			)

			let prediction = try model.prediction(input: input)
			let stressLevel = prediction.stressLevel

			// Clamp to [0, 1]
			return min(max(stressLevel, 0.0), 1.0)

		} catch {
			print("❌ CoreML prediction error: \(error)")
			return predictWithHeuristic(features: features, heartRate: heartRate)
		}
	}

	/// Fallback heuristic prediction if CoreML fails
	private func predictWithHeuristic(features: ScrollFeatures, heartRate: Double?) -> Double {
		let velocityVarianceScore = normalizeVelocityStdDev(features.velocityStdDev)
		let jerkinessScore = normalizeJerkiness(features.jerkiness)
		let reversalScore = normalizeReversals(features.scrollReversals)
		let microPauseScore = normalizeMicroPauses(features.microPauses)

		var weights: [Double] = [0.35, 0.30, 0.20, 0.15]
		var scores = [velocityVarianceScore, jerkinessScore, reversalScore, microPauseScore]

		// If heart rate available, include it
		if let hr = heartRate, hr > 0 {
			let heartRateScore = normalizeHeartRate(hr)
			weights = [0.25, 0.25, 0.15, 0.10, 0.25]
			scores.append(heartRateScore)
		}

		let weightedSum = zip(weights, scores).reduce(0.0) { $0 + $1.0 * $1.1 }

		return min(max(weightedSum, 0.0), 1.0)
	}

	// MARK: - Normalization Functions

	private func normalizeVelocityStdDev(_ value: Double) -> Double {
		return normalize(value, min: 30.0, max: 80.0)
	}

	private func normalizeJerkiness(_ value: Double) -> Double {
		return normalize(value, min: 50.0, max: 150.0)
	}

	private func normalizeReversals(_ value: Int) -> Double {
		return normalize(Double(value), min: 1.0, max: 4.0)
	}

	private func normalizeMicroPauses(_ value: Int) -> Double {
		return normalize(Double(value), min: 2.0, max: 6.0)
	}

	private func normalizeHeartRate(_ value: Double) -> Double {
		// Resting: 60-75, Stressed: 85-100
		return normalize(value, min: 70.0, max: 95.0)
	}

	private func normalize(_ value: Double, min minVal: Double, max maxVal: Double) -> Double {
		if value <= minVal {
			return 0.0
		} else if value >= maxVal {
			return 1.0
		} else {
			return (value - minVal) / (maxVal - minVal)
		}
	}
}

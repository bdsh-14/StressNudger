//
//  StressModel.swift
//  StressNudger
//
//  Created by Bidisha Biswas on 11/23/25.
//

import Foundation

class StressModel {
	/// Predicts stress level from scroll features using research-based heuristics
	/// Returns value between 0.0 (relaxed) and 1.0 (stressed)
	func predict(features: ScrollFeatures) -> Double {
		// Research indicates stressed scrolling shows:
		// 1. High velocity variance (erratic scrolling)
		// 2. High jerkiness (abrupt movements)
		// 3. Frequent reversals (indecisive behavior)
		// 4. Many micro-pauses (cognitive overload)

		// Normalize features to 0-1 range based on empirical thresholds
		let velocityVarianceScore = normalizeVelocityStdDev(features.velocityStdDev)
		let jerkinessScore = normalizeJerkiness(features.jerkiness)
		let reversalScore = normalizeReversals(features.scrollReversals)
		let microPauseScore = normalizeMicroPauses(features.microPauses)

		// Weighted combination (can be tuned based on research)
		let weights: [Double] = [0.35, 0.30, 0.20, 0.15]
		let scores = [velocityVarianceScore, jerkinessScore, reversalScore, microPauseScore]

		let weightedSum = zip(weights, scores).reduce(0.0) { $0 + $1.0 * $1.1 }

		// Clamp to [0, 1]
		return min(max(weightedSum, 0.0), 1.0)
	}

	// MARK: - Normalization Functions

	private func normalizeVelocityStdDev(_ value: Double) -> Double {
		// Relaxed: ~30, Stressed: ~80+
		let relaxedThreshold = 30.0
		let stressedThreshold = 80.0
		return normalize(value, min: relaxedThreshold, max: stressedThreshold)
	}

	private func normalizeJerkiness(_ value: Double) -> Double {
		// Relaxed: ~50, Stressed: ~150+
		let relaxedThreshold = 50.0
		let stressedThreshold = 150.0
		return normalize(value, min: relaxedThreshold, max: stressedThreshold)
	}

	private func normalizeReversals(_ value: Int) -> Double {
		// Relaxed: 0-2, Stressed: 4+
		let relaxedThreshold = 1.0
		let stressedThreshold = 4.0
		return normalize(Double(value), min: relaxedThreshold, max: stressedThreshold)
	}

	private func normalizeMicroPauses(_ value: Int) -> Double {
		// Relaxed: 1-3, Stressed: 6+
		let relaxedThreshold = 2.0
		let stressedThreshold = 6.0
		return normalize(Double(value), min: relaxedThreshold, max: stressedThreshold)
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

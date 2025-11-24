//
//  ScrollFeatures.swift
//  StressNudger
//
//  Created by Bidisha Biswas on 11/23/25.
//

import Foundation

struct ScrollFeatures {
	// Velocity features
	let meanVelocity: Double
	let velocityStdDev: Double
	let maxVelocity: Double

	// Jerkiness (acceleration variance)
	let jerkiness: Double
	let accelerationChanges: Int

	// Pattern features
	let scrollReversals: Int
	let microPauses: Int
	let longPauses: Int

	// Temporal features
	let scrollDuration: Double
	let scrollFrequency: Double

	func toArray() -> [Double] {
		return [
			meanVelocity,
			velocityStdDev,
			maxVelocity,
			jerkiness,
			Double(accelerationChanges),
			Double(scrollReversals),
			Double(microPauses),
			Double(longPauses),
			scrollDuration,
			scrollFrequency
		]
	}
}

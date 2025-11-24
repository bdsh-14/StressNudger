//
//  ScrollMetricsView.swift
//  StressNudger
//
//  Created by Bidisha Biswas on 11/23/25.
//

import SwiftUI

struct ScrollMetricsView<Content: View>: View {
	let content: Content
	let onMetricsUpdate: (ScrollMetrics) -> Void

	@State private var previousOffset: CGFloat = 0
	@State private var previousVelocity: CGFloat = 0
	@State private var previousTimestamp: Date = Date()

	init(@ViewBuilder content: () -> Content,
		 onMetricsUpdate: @escaping (ScrollMetrics) -> Void) {
		self.content = content()
		self.onMetricsUpdate = onMetricsUpdate
	}

	var body: some View {
		ScrollView {
			GeometryReader { geometry in
				Color.clear.preference(
					key: ScrollOffsetPreferenceKey.self,
					value: geometry.frame(in: .named("scroll")).minY
				)
			}
			.frame(height: 0)

			content
		}
		.coordinateSpace(name: "scroll")
		.onPreferenceChange(ScrollOffsetPreferenceKey.self) { offset in
			calculateMetrics(offset: offset)
		}
	}

	private func calculateMetrics(offset: CGFloat) {
		let now = Date()
		let timeDelta = now.timeIntervalSince(previousTimestamp)

		guard timeDelta > 0 else { return }

		let velocity = (offset - previousOffset) / timeDelta
		let acceleration = (velocity - previousVelocity) / timeDelta

		let metrics = ScrollMetrics(
			timestamp: now,
			velocity: velocity,
			offset: offset,
			acceleration: acceleration
		)

		onMetricsUpdate(metrics)

		previousOffset = offset
		previousVelocity = velocity
		previousTimestamp = now
	}
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
	static var defaultValue: CGFloat = 0
	static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
		value = nextValue()
	}
}

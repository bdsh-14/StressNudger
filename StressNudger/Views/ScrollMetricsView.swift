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

	@State private var lastScrollTime = Date()
	@State private var scrollCount: Int = 0

	init(@ViewBuilder content: () -> Content,
		 onMetricsUpdate: @escaping (ScrollMetrics) -> Void) {
		self.content = content()
		self.onMetricsUpdate = onMetricsUpdate
	}

	var body: some View {
		content
			.onAppear {
				// Simulate scroll metrics when items appear
				let now = Date()
				let timeDelta = now.timeIntervalSince(lastScrollTime)

				if timeDelta > 0.05 {  // Throttle
					let velocity = CGFloat.random(in: 100...300)
					let acceleration = CGFloat.random(in: 50...150)

					let metrics = ScrollMetrics(
						timestamp: now,
						velocity: velocity,
						offset: CGFloat(scrollCount),
						acceleration: acceleration
					)

					print("📊 Generated metrics: v=\(velocity)")
					onMetricsUpdate(metrics)

					lastScrollTime = now
					scrollCount += 1
				}
			}
	}
}

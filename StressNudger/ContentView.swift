//
//  ContentView.swift
//  StressNudger
//
//  Created by Bidisha Biswas on 11/23/25.
//

import SwiftUI

struct ContentView: View {
	@StateObject private var stressManager = StressDetectionManager()
	@State private var showBreathingExercise = false

	var body: some View {
		NavigationView {
			VStack(spacing: 20) {
				// Stress indicator
				StressIndicatorView(level: stressManager.currentStressLevel)

				// Sample scrollable content
				ScrollMetricsView(
					content: {
						SampleContentView()
					},
					onMetricsUpdate: { metrics in
						stressManager.processScrollMetrics(metrics)
					}
				)

				// Controls
				HStack {
					Button("Reset") {
						stressManager.reset()
					}
					.buttonStyle(.bordered)

					Button("Export Data") {
						exportData()
					}
					.buttonStyle(.bordered)
				}
				.padding()
			}
			.navigationTitle("StressNudger")
			.sheet(isPresented: $showBreathingExercise) {
				BreathingExerciseView()
			}
			.onReceive(NotificationCenter.default.publisher(for: .stressDetected)) { _ in
				showBreathingExercise = true
			}
		}
	}

	private func exportData() {
}

#Preview {
    ContentView()
}

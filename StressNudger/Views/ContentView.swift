//
//  ContentView.swift
//  StressNudger
//
//  Created by Bidisha Biswas on 11/23/25.
//

import SwiftUI

struct ContentView: View {
	@StateObject private var stressManager = StressDetectionManager()
	@StateObject private var healthKitManager = HealthKitManager()
	@State private var showBreathingExercise = false

	var body: some View {
		NavigationView {
			VStack(spacing: 8) {
				VStack(spacing: 8) {
					StressIndicatorView(level: stressManager.currentStressLevel)

					if healthKitManager.currentHeartRate > 0 {
						HStack {
							Image(systemName: "heart.fill")
								.foregroundColor(.red)
							Text("\(Int(healthKitManager.currentHeartRate)) bpm")
								.font(.subheadline)
								.foregroundColor(.secondary)
						}
					} else {
						Text("No heart rate data")
							.font(.caption)
							.foregroundColor(.secondary)
					}
				}
				.padding(.vertical, 8)

				Divider()

				// Scrollable content
				List(0..<50, id: \.self) { index in
					ScrollMetricsView(
						content: {
							ArticleRow(index: index)
						},
						onMetricsUpdate: { metrics in
							stressManager.processScrollMetrics(metrics)
						}
					)
				}
				.listStyle(.plain)

				Divider()

				// Controls
				HStack(spacing: 20) {
					Button {
						stressManager.reset()
					} label: {
						Label("Reset", systemImage: "arrow.counterclockwise")
					}
					.buttonStyle(.bordered)

					if !healthKitManager.isAuthorized {
						Button {
							healthKitManager.requestAuthorization()
						} label: {
							Label("Enable HealthKit", systemImage: "heart.fill")
						}
						.buttonStyle(.borderedProminent)
					}
				}
				.padding()
			}
			.navigationTitle("Stress Nudger")
			.navigationBarTitleDisplayMode(.inline)
			.sheet(isPresented: $showBreathingExercise) {
				BreathingExerciseView()
			}
			.onAppear {
				healthKitManager.requestAuthorization()
			}
			.onReceive(healthKitManager.$currentHeartRate) { heartRate in
				stressManager.currentHeartRate = heartRate
			}
			.onReceive(NotificationCenter.default.publisher(for: .stressDetected)) { _ in
				showBreathingExercise = true
			}
		}
	}
}

struct ArticleRow: View {
	let index: Int

	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			Text("Article \(index + 1)")
				.font(.headline)
			Text("This is sample content to scroll through. The app monitors your scroll behavior to detect stress patterns.")
				.font(.body)
				.foregroundColor(.secondary)
				.lineLimit(3)
		}
		.padding(.vertical, 8)
	}
}

#Preview {
	ContentView()
}

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
			VStack(spacing: 0) {
				// Stress indicator at top
				StressIndicatorView(level: stressManager.currentStressLevel)
					.padding(.vertical)

				Divider()
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

				// Controls at bottom
				HStack(spacing: 20) {
					Button {
						stressManager.reset()
					} label: {
						Label("Reset", systemImage: "arrow.counterclockwise")
					}
					.buttonStyle(.bordered)

					Button {
						// TODO: Implement export
					} label: {
						Label("Export", systemImage: "square.and.arrow.up")
					}
					.buttonStyle(.bordered)
				}
				.padding()
			}
			.navigationTitle("StressNudger")
			.navigationBarTitleDisplayMode(.inline)
			.sheet(isPresented: $showBreathingExercise) {
				BreathingExerciseView()
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

struct SampleContentView: View {
	var body: some View {
		LazyVStack(alignment: .leading, spacing: 16) {
			ForEach(0..<50, id: \.self) { index in
				VStack(alignment: .leading, spacing: 8) {
					Text("Article \(index + 1)")
						.font(.headline)
					Text("This is sample content to scroll through. The app monitors your scroll behavior to detect stress patterns in real-time using behavioral analysis.")
						.font(.body)
						.foregroundColor(.secondary)
						.lineLimit(3)
				}
				.padding()
				.background(Color(.systemGray6))
				.cornerRadius(12)
			}
		}
		.padding()
	}
}

#Preview {
	ContentView()
}

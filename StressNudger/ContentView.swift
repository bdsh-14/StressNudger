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
		// Implement CSV export
		// This would export collected metrics for research
	}
}

struct StressIndicatorView: View {
	let level: Double

	var color: Color {
		if level < 0.3 { return .green }
		if level < 0.7 { return .yellow }
		return .red
	}

	var body: some View {
		VStack {
			Text("Stress Level")
				.font(.headline)

			ZStack {
				Circle()
					.stroke(Color.gray.opacity(0.3), lineWidth: 20)

				Circle()
					.trim(from: 0, to: level)
					.stroke(color, lineWidth: 20)
					.rotationEffect(.degrees(-90))
					.animation(.easeInOut, value: level)
			}
			.frame(width: 150, height: 150)

			Text("\(Int(level * 100))%")
				.font(.title)
				.foregroundColor(color)
		}
		.padding()
	}
}

struct SampleContentView: View {
	var body: some View {
		VStack(alignment: .leading, spacing: 16) {
			ForEach(0..<50) { index in
				VStack(alignment: .leading) {
					Text("Article \(index + 1)")
						.font(.headline)
					Text("This is sample content to scroll through. The app is monitoring your scroll behavior to detect stress patterns.")
						.font(.body)
						.foregroundColor(.secondary)
				}
				.padding()
				.background(Color.gray.opacity(0.1))
				.cornerRadius(8)
			}
		}
		.padding()
	}
}

struct BreathingExerciseView: View {
	@Environment(\.dismiss) var dismiss
	@State private var scale: CGFloat = 1.0

	var body: some View {
		VStack(spacing: 40) {
			Text("Take a Breath")
				.font(.largeTitle)

			Circle()
				.fill(Color.blue.opacity(0.3))
				.frame(width: 200, height: 200)
				.scaleEffect(scale)
				.onAppear {
					withAnimation(
						.easeInOut(duration: 4)
						.repeatForever(autoreverses: true)
					) {
						scale = 1.5
					}
				}

			Text("Breathe in... and out...")
				.font(.title2)

			Button("Done") {
				dismiss()
			}
			.buttonStyle(.borderedProminent)
		}
		.padding()
	}
}

#Preview {
    ContentView()
}

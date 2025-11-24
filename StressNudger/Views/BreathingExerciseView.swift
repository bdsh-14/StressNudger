//
//  BreathingExerciseView.swift
//  StressNudger
//
//  Created by Bidisha Biswas on 11/23/25.
//

import SwiftUI

struct BreathingExerciseView: View {
	@Environment(\.dismiss) var dismiss
	@State private var scale: CGFloat = 1.0
	@State private var phase: String = "Breathe in..."

	var body: some View {
		VStack(spacing: 40) {
			Text("Take a Moment")
				.font(.largeTitle)
				.fontWeight(.bold)

			Circle()
				.fill(
					LinearGradient(
						colors: [.blue.opacity(0.6), .purple.opacity(0.4)],
						startPoint: .topLeading,
						endPoint: .bottomTrailing
					)
				)
				.frame(width: 200, height: 200)
				.scaleEffect(scale)
				.onAppear {
					withAnimation(
						.easeInOut(duration: 4)
						.repeatForever(autoreverses: true)
					) {
						scale = 1.5
					}

					// Alternate text
					Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { _ in
						phase = phase == "Breathe in..." ? "Breathe out..." : "Breathe in..."
					}
				}

			Text(phase)
				.font(.title2)
				.foregroundColor(.secondary)

			Button("Done") {
				dismiss()
			}
			.buttonStyle(.borderedProminent)
			.controlSize(.large)
		}
		.padding()
	}
}
#Preview {
    BreathingExerciseView()
}

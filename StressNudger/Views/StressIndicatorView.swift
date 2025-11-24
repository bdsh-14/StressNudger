//
//  StressIndicatorView.swift
//  StressNudger
//
//  Created by Bidisha Biswas on 11/23/25.
//

import SwiftUI

struct StressIndicatorView: View {
	let level: Double

	var color: Color {
		if level < 0.3 { return .green }
		if level < 0.7 { return .yellow }
		return .red
	}

	var body: some View {
		VStack(spacing: 12) {
			Text("Stress Level")
				.font(.headline)
				.foregroundColor(.secondary)

			ZStack {
				Circle()
					.stroke(Color.gray.opacity(0.2), lineWidth: 20)

				Circle()
					.trim(from: 0, to: level)
					.stroke(color, style: StrokeStyle(lineWidth: 20, lineCap: .round))
					.rotationEffect(.degrees(-90))
					.animation(.easeInOut(duration: 0.5), value: level)
			}
			.frame(width: 150, height: 150)

			Text("\(Int(level * 100))%")
				.font(.system(size: 36, weight: .bold, design: .rounded))
				.foregroundColor(color)
		}
		.padding()
	}
}

#Preview {
	StressIndicatorView(level: 0.8)
}

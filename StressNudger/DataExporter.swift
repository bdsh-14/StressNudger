//
//  DataExporter.swift
//  StressNudger
//
//  Created by Bidisha Biswas on 11/23/25.
//

import Foundation
import UIKit

class DataExporter {
	static func exportToCSV(metrics: [ScrollMetrics], features: [ScrollFeatures]) -> String {
		var csv = "timestamp,velocity,offset,acceleration,meanVelocity,velocityStdDev,jerkiness,reversals\n"

		// Export raw metrics
		for metric in metrics {
			csv += "\(metric.timestamp.timeIntervalSince1970),"
			csv += "\(metric.velocity),"
			csv += "\(metric.offset),"
			csv += "\(metric.acceleration)\n"
		}

		return csv
	}

	static func saveToFile(_ content: String, filename: String) {
		let fileURL = FileManager.default.temporaryDirectory
			.appendingPathComponent(filename)

		do {
			try content.write(to: fileURL, atomically: true, encoding: .utf8)
			// Share the file
			shareFile(url: fileURL)
		} catch {
			print("Error saving file: \(error)")
		}
	}

	private static func shareFile(url: URL) {
		let activityVC = UIActivityViewController(
			activityItems: [url],
			applicationActivities: nil
		)

		if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
		   let rootVC = windowScene.windows.first?.rootViewController {
			rootVC.present(activityVC, animated: true)
		}
	}
}

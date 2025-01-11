// RememberComponent.swift
// Copyright (c) 2025 by Nikita Rossik. Created at 25.12.2024.

import SwiftUI

struct RememberComponent: View {
	var body: some View {
		HStack(spacing: 22) {
			ReminderComponent()

			VStack(alignment: .leading) {
				HStack {
					Text("Напоминание")
					Spacer()
					Text("сейчас")
				}
				.font(.title3)
				.foregroundStyle(.secondary)

				Spacer()

				Text("Проснулись — улыбнулись")
					.font(.system(size: 18))
			}
			.lineLimit(1)
			.foregroundStyle(.white)
		}
		.frame(width: 355, height: 80)
		.padding(.horizontal, 20)
		.padding(.vertical, 28)
		.background(
			.linearGradient(
				colors: [.purple, .black],
				startPoint: .topTrailing,
				endPoint: .bottom
			),
			in: .rect(cornerRadius: 18)
		)
	}
}

struct ReminderComponent: View {
	private let colors: [Color] = [.blue, .red, .orange]

	var body: some View {
		VStack {
			ForEach(colors, id: \.self) { color in
				HStack(spacing: 15) {
					Circle()
						.frame(width: 12, height: 12)
						.foregroundStyle(color)
						.padding(.vertical, 1.5)
						.overlay {
							Circle()
								.strokeBorder(style: .init(lineWidth: 1))
								.padding(-3)
								.foregroundStyle(color)
						}

					Rectangle()
						.frame(width: 40, height: 1)
						.foregroundStyle(.gray)
				}
			}
		}
		.padding()
		.background(.white, in: .rect(cornerRadius: 18))
	}
}

#Preview {
//	ReminderComponent()
	RememberComponent()
		.frame(width: 400, height: 200)
}

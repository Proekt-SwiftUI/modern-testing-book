// ContentView.swift
// Copyright (c) 2025 by Nikita Rossik. Created at 21.12.2024.

import SwiftUI

struct ContentView: View {
	var body: some View {
		VStack {
			Image(systemName: "globe")
				.imageScale(.large)
				.foregroundStyle(.tint)
			Text("Hello, world!")
		}
		.padding()
	}
}

#Preview {
	ContentView()
		.frame(width: 400, height: 300)
}

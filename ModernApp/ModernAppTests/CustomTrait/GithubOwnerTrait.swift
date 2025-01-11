// GithubOwnerTrait.swift
// Copyright (c) 2025 by Nikita Rossik. Created at 24.12.2024.

import struct Foundation.URL
import Testing

struct GithubOwnerTrait: TestTrait {
	var name: String?
	var githubUserURL: URL
}

extension Trait where Self == GithubOwnerTrait {
	static func githubOwner(_ name: String? = nil, userURL: URL) -> Self {
		Self(name: name, githubUserURL: userURL)
	}
}

@Test(.githubOwner(userURL: .init(string: "@wmorgue")!))
func anotherThing() {
	let duration = Duration.seconds(120)
	#expect(duration == .seconds(60 * 2))
}

@Test("Ранний выход из-за отмены группы задач")
func cancelledTestExitsEarly() async throws {
	let timeAwaited: Duration = await ContinuousClock().measure {
		await withThrowingTaskGroup(of: Void.self) { taskGroup in
			taskGroup.addTask {
				try await Task.sleep(for: .seconds(60))
			}

			taskGroup.cancelAll()
		}
	}

	#expect(timeAwaited < .seconds(1))
}

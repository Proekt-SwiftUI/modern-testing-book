// GithubOwnerTrait.swift
// Copyright (c) 2025 by Nikita Rossik. Created at 1/11/25.

import struct Foundation.URL
import Testing

struct GithubOwnerTrait: TestTrait, SuiteTrait {
	var name: String?
	var githubUserURL: URL
}

extension Trait where Self == GithubOwnerTrait {
	static func githubOwner(_ name: String? = nil, userURL: URL) -> Self {
		Self(name: name, githubUserURL: userURL)
	}
}

extension URL {
	init(link: String) {
		self.init(string: link)!
	}
}

@Suite(.githubOwner(userURL: URL(link: "github.com/wmorgue")))
struct SpeedMetrics {
	@Test(.githubOwner(userURL: URL(link: "github.com/hborla")))
	func anotherThing() {
		let duration = Duration.seconds(120)
		#expect(duration == .seconds(60 * 2))
	}

	// ...
}

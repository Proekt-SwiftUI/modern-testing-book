//
//  Tags+ReverseDNS.swift
//  ModernApp
//
//  Created by Nick Rossik on 2/12/25.
//

import Testing

extension Tag {
	enum api_V3 {}
}

extension Tag.api_V3 {
	@Tag
	static var backportVersion: Self
}

@Suite("Unsupported API V3", .tags(.api_V3.backportVersion))
struct BackportedAPI {
	@Test
	func fetchMainRoute() async throws {
		// ...
	}
}

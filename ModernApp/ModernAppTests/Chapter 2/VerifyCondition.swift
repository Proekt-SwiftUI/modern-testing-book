//
//  VerifyCondition.swift
//  ModernApp
//
//  Created by Nick Rossik on 2/28/25.
//

import Testing

let count = 5

@Suite(.enabled(if: count >= 1))
struct WeatherGroup {
	@Test(.enabled(if: count == 3))
	func nextSevenDays() async throws {
			// ...
	}

	@Test
	func today() async throws {
			// ...
	}

	@Test(.enabled(if: count > 10))
	func findSunnyDays() async throws {
			// ...
	}
}

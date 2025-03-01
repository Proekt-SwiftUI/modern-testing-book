// VerifyCondition.swift
// Copyright (c) 2025 by Nikita Rossik. Created at 3/1/25.

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

let isEnabledForSomeReason: Bool = true

@Test(
	.enabled(if: isEnabledForSomeReason),
	.disabled("Отключили до фикса бага #243"),
	.bug(id: "243")
)
func showFastPath() throws {
	// ...
}

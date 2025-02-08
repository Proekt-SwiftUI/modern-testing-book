// TimeLimitTrait.swift
// Copyright (c) 2025 by Nikita Rossik. Created at 24.12.2024.

import Testing

@Suite("Трейт TimeLimit", .timeLimit(.minutes(0)))
struct TimeLimitExample {
	@Test
	func takeYourTime() {
		#expect(60.0 == 60.0)
	}

	@Test(.timeLimit(.minutes(1)))
	func anotherDay() {
		#expect(0.3 == 0.3)
	}
}

@Test(
	"Максимальное время timeLimit",
	.timeLimit(.minutes(1)),
	.timeLimit(.minutes(5))
)
func maxTimeLimit() async throws {
	try await Task.sleep(for: .seconds(120))
	#expect(true)
}

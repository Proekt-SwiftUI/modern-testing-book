// TestMacroImplementation.swift
// Copyright (c) 2025 by Nikita Rossik. Created at 2/8/25.

import Testing

@testable
import ModernApp

// MARK: Runtime Condition

enum Feature {
	case disabled
	case isLocalEnabled
	case isRemoteEnabled
}

class Backport {
	static var featureState: Feature = .isLocalEnabled

	static var isRemoteVersion: Bool {
		featureState == .isRemoteEnabled
	}
}

struct Chapter2 {
	@Test(.enabled(if: Backport.isRemoteVersion))
	func backportVersion() {
		// ...
	}

	@Test(.disabled("Известный баг, отключаем до фикса #PR-3781"))
	func fetchFeatureFlag() async {
		// ...
	}

	// Избегайте такого способа отключения теста
	@Test("Закомментирую на время фикса #PR-3781")
	func fetchAnotherFlag() {
//		try await Task(priority: .background) {
//			...
//		}
	}

	@Test(
		"Проверка валидности поля имени",
		.disabled("Бекендер исправляет модель"),
		.bug("https://github.com/issue/7329", "Сломанная валидация имени и модель #7329")
	)
	func validateNameProperty() async throws {
		// ...
	}

	@Test
	func checkReturnType() -> any Collection {
		let collection = Array(1 ... 10)
		#expect(collection.contains(10))

		return collection
	}

	@Test(.tags(.calculator))
	func firstValueOfCalculator() async {
		let calc = BestCalculator(value: [9, 3, -18])
		await #expect(calc.getFirstValue() == 9)
	}
}

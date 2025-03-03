// BasicMacro.swift
// Copyright (c) 2025 by Nikita Rossik. Created at 1/11/25.

@testable
import ModernApp

import Testing
import struct Foundation.Measurement
import class Foundation.UnitInformationStorage

@Test
func calculateTotal() async {
	let calc = BestCalculator(value: [3, 5, 1])

	await #expect(calc.total == 19)
	await #expect(calc.value.isEmpty)
	await #expect(type(of: calc.value) == [Int].self)
}

@Test("Проверка пустой суммы калькулятора")
func calcWithEmptyValues() async {
	let calc = BestCalculator(value: [])
	await #expect(calc.total == .zero)
}

// @Test("❌ Неправильная проверка опционального города")
// func userProfileHaveCity() async {
//	let profileData = ProfileData()
//	await profileData.getProfile(id: .zero)
//
//	// Юзера с айди 0 не существует.
//	guard let user = profileData.user else {
//		return
//	}
//
//	#expect(user.city != nil)
//	#expect(user.city == "Moscow")
// }
//
// @Test("Правильная проверка опционального города")
// func userHaveCity() async throws {
//	let profileData = ProfileData()
//	await profileData.getProfile(id: 1)
//
//	let city: String = try #require(profileData.user?.city)
//
//	#expect(city == "Ísafjörður")
//	await profileData.updateUserProfile()
// }

// @Suite("Тесты юзер профайла")
// struct UserProfileTest {
//	@Test("❌ Неправильная проверка опционального города")
//	func userProfileHaveCity() async {}
//
//	@Test("Правильная проверка опционального города")
//	func userHaveCity() async throws {}
//
//	@Suite("Тестирование аватарки")
//	enum EmptyCitySearch {
//		@Test("Выбор аватарки в профиле")
//		func selectProfileAvatar() {}
//	}
// }

@Test("Как определить, функция для теста изолирована на глобальном акторе ?")
nonisolated func determineGlobalActor() async {
//	await MainActor.run {}
}


@Suite(.tags(.fileSize))
struct AboutFileSize {
	@Test("Сравниваем размер файла")
	func checkSize() {
		let fileSize = Measurement<UnitInformationStorage>(value: 2432, unit: .megabytes)

		#expect(fileSize.description == "2.4MB")
	}

	@Test("Сравнение еще одного файла")
	func checkSizeWithFormatter() {
		let fileSize = Measurement<UnitInformationStorage>(value: 2432, unit: .megabytes)
		let filter = Measurement<UnitInformationStorage>.FormatStyle(
			width: .wide,
			locale: .init(identifier: "ru_RU")
		)

		let formattedResult = filter.format(fileSize)
		#expect(formattedResult != "2.4 Мегабайта")
	}
}

// HandleThrowExample.swift
// Copyright (c) 2025 by Nikita Rossik. Created at 1/11/25.

import Testing

import struct Foundation.UUID
import struct SwiftUI.Color

struct BestTea: Identifiable {
	let id = UUID()
	let name: String
	let optimalTime: Int
	let color: Color?
}

// @Test(.hidden)
// func simpleIssue() throws {
//	Issue.record()
// }

// Плохая практика ❌
// Из-за оператора return в теле guard, осуществился ранний выход из метода,
// макрос #expect не сравнил цвет и результат теста оказался неверным.
@Test
func brewTea() {
	let greenTea = BestTea(name: "Green", optimalTime: 2, color: nil)
	guard let color = greenTea.color else {
		print("Color is nil!")
		return
	}
	#expect(color == .green)
}

// Хорошая практика ✅
// На замену guard используем макрос #require, для распаковки опционального значения
// В случае, если значение color равно nil, осуществляется ранний выход и
// тест не проходит проверку, вернув ошибку.
@Test
func brewTeaCorrect() throws {
	let greenTea = BestTea(name: "Green", optimalTime: 2, color: nil)
	let color = try #require(greenTea.color)
	#expect(color == .green)
}

// withKnownIssue
@Test
func checkGreenTea() {
	let tea = BestTea(name: "Green", optimalTime: 2, color: nil)

	withKnownIssue {
		#expect(tea.color == .red)
	}
}

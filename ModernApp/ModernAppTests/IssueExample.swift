// IssueExample.swift
// Copyright (c) 2025 by Nikita Rossik. Created at 2/15/25.

import Testing

enum ProductionError: Error {
	case backendOffline
}

func getTestLocation(testName: String = #function) {
	let location = #_sourceLocation()
	print("Запущен тест \(testName) в файле \(location.fileName)\nМодуль: \(location.moduleName)")
}

func logIssueInDifferentPlace(_ comment: Comment?, in fn: @escaping @Sendable () async throws -> Void) async throws {
	Issue.record(comment)
	try await fn()
}

struct ElectricityStation {
	let highVoltage: Bool = false
}

@Test
func checkVoltage() {
	let electricity = ElectricityStation()

	guard electricity.highVoltage else {
		Issue.record("Слишком высокое напряжение")
		return
	}
}


@Test
func expectIssueSomewhere() async {
	try! await logIssueInDifferentPlace("Здесь точно ошибка") {
		#expect(1 == 2)
	}
}

@Test
func matchFileSourceLocation() {
	let fileLine = 33
	let locationOfThisTest = #_sourceLocation()
	#expect(fileLine == locationOfThisTest.line)
}

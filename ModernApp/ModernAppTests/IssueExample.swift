//
//  IssueExample.swift
//  ModernApp
//
//  Created by Nick Rossik on 2/14/25.
//

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

@Test
func simpleIssue() {
	getTestLocation()
	Issue.record("Здесь точно ошибка")
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

//@Test
//func isOnlineBackend() async {
//	await #expect(throws: ProductionError.self) {
//		try await Task.sleep(for: .seconds(2.5))
//		throw ProductionError.backendOffline
//	}
//}

//@Test("Running at GlobalActor?")
//@MainActor
//func powerOfActor() async {
//	MainActor.assertIsolated()
//
//	#expect(1 == 1)
//}

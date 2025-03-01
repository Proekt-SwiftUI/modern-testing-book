// TestInformation.swift
// Copyright (c) 2025 by Nikita Rossik. Created at 3/1/25.

import Testing

@Test("Информация о тесте")
func information() throws {
	let currentTest: Test = try #require(Test.current)
	let location = #_sourceLocation()

	#expect(currentTest.sourceLocation.fileName == location.fileName)
	#expect(currentTest.displayName == nil)
}

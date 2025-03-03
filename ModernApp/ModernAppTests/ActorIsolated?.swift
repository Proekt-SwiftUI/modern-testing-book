// ActorIsolated?.swift
// Copyright (c) 2025 by Nikita Rossik. Created at 2/22/25.

import Testing

// @Test
// func isOnlineBackend() async {
//	await #expect(throws: ProductionError.self) {
//		try await Task.sleep(for: .seconds(2.5))
//		throw ProductionError.backendOffline
//	}
// }

// @Test("Running at GlobalActor?")
// @MainActor
// func powerOfActor() async {
//	MainActor.assertIsolated()
//
//	#expect(1 == 1)
// }

//@globalActor
//actor ModernActor {
//	static let shared = ModernActor()
//}
//
//@Test
//@ModernActor
//func executeAtModern() {
//	ModernActor.assertIsolated()
//}

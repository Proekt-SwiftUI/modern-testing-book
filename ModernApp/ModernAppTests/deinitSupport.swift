//
//  deinitSupport.swift
//  ModernApp
//
//  Created by Nick Rossik on 2/26/25.
//

import Testing

final class A {
	deinit {}
}

final actor B {
	deinit {}
}

//struct C: ~Copyable {
//	deinit {}
//
//	@Test("Ownership for sheep")
//	func sheepOwner() async throws {
//		#expect(UnicodeScalar(0x1F411) == "\u{1F411}")
//	}
//}

// BugTracker.swift
// Copyright (c) 2025 by Nikita Rossik. Created at 2/19/25.

import Testing

// @Test(.bug("https://example.com/bug/71"))
// func loginInvalidCredentials() async {
//	let profile = UserProfile()
//	await profile.login(option: .singInWithApple)
//	#expect(profile.isSuccessLogin)
// }

@Test(
	"Вход с неправильными данными",
	.bug(id: 483, "Вход с такими данными невозможен во всех сценариях")
)
func loginInvalidCredentials() async {
	#expect(1 == 2)
}

@Test(.bug("com.invalid.domain/id?=63"))
func handleOutput() async {
	#expect(1 == 2)
}

@Suite(.serialized)
struct IsolationConfirmation {
	func executeAt() async throws {
		#expect(1 == 1)
	}
}

extension IsolationConfirmation {
	@Suite
	struct NonIsolatedData {}
}

@Test
func checkOneString() {
	let word = "Madam"
	let result = word.filter(\.isLetter).lowercased().reversed()

	#expect(word.lowercased() == String(result))
}

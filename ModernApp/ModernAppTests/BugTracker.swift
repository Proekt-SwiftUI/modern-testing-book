//
//  BugTracker.swift
//  ModernApp
//
//  Created by Nick Rossik on 2/17/25.
//

import Testing


//@Test(.bug("https://example.com/bug/71"))
//func loginInvalidCredentials() async {
//	let profile = UserProfile()
//	await profile.login(option: .singInWithApple)
//	#expect(profile.isSuccessLogin)
//}


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

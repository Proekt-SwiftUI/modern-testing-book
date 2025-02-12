//
//  SuiteAttr.swift
//  ModernApp
//
//  Created by Nick Rossik on 2/12/25.
//

import Testing

@Suite
struct ColdWeather {
	func dressWarm() {
		#expect(-10 + -3 == -13)
	}

	@Test(.disabled())
	static func someStaticFn() {
		let instance = ColdWeather()
		instance.dressWarm()
	}
}


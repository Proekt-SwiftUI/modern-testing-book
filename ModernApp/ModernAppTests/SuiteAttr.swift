// SuiteAttr.swift
// Copyright (c) 2025 by Nikita Rossik. Created at 2/12/25.

import Testing

@Suite(.tags(.weather))
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

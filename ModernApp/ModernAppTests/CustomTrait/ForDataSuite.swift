// ForDataSuite.swift
// Copyright (c) 2025 by Nikita Rossik. Created at 2/22/25.

import Testing

@preconcurrency
import Observation

@testable
import class ModernApp.ProfileData

struct ForDataSuite: SuiteTrait {
	let observableType: Observable.Type
}

extension SuiteTrait where Self == ForDataSuite {
	static func forData(_ data: Observable.Type) -> Self {
		Self(observableType: data)
	}
}

@Suite(.forData(ProfileData.self))
struct WholeProfile {
	// ...
}

// ConditionTrait+Ext.swift
// Copyright (c) 2025 by Nikita Rossik. Created at 2/22/25.

import Testing

@testable
import ModernApp

extension Trait where Self == ConditionTrait {
	static var disabledWithEmptyAvatar: Self {
		.disabled(if: ProfileData().avatar == nil)
	}
}

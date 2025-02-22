// BacklogTrait.swift
// Copyright (c) 2025 by Nikita Rossik. Created at 1/11/25.

import Testing

enum FeatureFlag: String {
	case yes
	case no
}

enum AppVersion {
	case release(any FloatingPoint)
	case stage
}

struct BacklogTrait: TestTrait {
	let app: AppVersion
	let feature: FeatureFlag?
}

extension Trait where Self == BacklogTrait {
	static func backlog(app: AppVersion, feature: FeatureFlag? = nil) -> Self {
		Self(app: app, feature: feature)
	}
}

@Test(
	"Беклог для 1.7.0",
	.backlog(app: .release(1.7), feature: .yes)
)
func backglogNewRelease() {}

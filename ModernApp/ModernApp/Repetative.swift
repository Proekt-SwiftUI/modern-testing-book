// Repetative.swift
// Copyright (c) 2025 by Nikita Rossik. Created at 1/11/25.

import Foundation

/// API Профиля
enum ProfilePath: String, CaseIterable {
	case profile = "/profile"
	case edit = "/profile/edit"
	case delete = "/profile/delete"
	case settings = "/profile/settings"
}

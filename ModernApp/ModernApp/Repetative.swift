//
//  Repetative.swift
//  ModernApp
//
//  Created by Nick Rossik on 08.01.2025.
//

import Foundation

/// API Профиля
enum ProfilePath: String, CaseIterable {
	case profile = "/profile"
	case edit = "/profile/edit"
	case delete = "/profile/delete"
	case settings = "/profile/settings"
}

// ProfileData.swift
// Copyright (c) 2025 by Nikita Rossik. Created at 1/11/25.

import class AppKit.NSImage
import struct Foundation.Date

import Observation

enum UserProfileError: Error {
	case networkRequestFailed
	case userDoesntExist
	case backend(Int)
}

struct UserProfile: Codable {
	let id: Int
	var firstName: String
	var lastName: String
	var email: String?
	var city: String?
}

struct EditProfile: Decodable {
	var firstName: String
	var lastName: String
}

struct DeleteProfile: Decodable {
	var isDeleted: Bool
	var lastActivityTime: Int
}

struct ProfileSettings: Decodable {
	var saveDate: Date
	var validSubscription: Bool
	var userEnableNotification: Bool
}

actor NetworkProvider {
	//	static let shared = NetworkProvider()
	//	private init() {}

	func fetchUserProfile(id: Int) throws(UserProfileError) -> UserProfile? {
		guard id != .zero else { throw .userDoesntExist }
		guard id > .zero else { throw .backend(id) }

		return UserProfile(id: id, firstName: "Nick", lastName: "Rossik")
	}

	func updateProfile(with path: ProfilePath) throws -> any Decodable {
		switch path {
		case .profile: UserProfile(id: 1, firstName: "Nick", lastName: "Rossik")
		case .edit: EditProfile(firstName: "Updated Name", lastName: "Updated Last")
		case .delete: DeleteProfile(isDeleted: false, lastActivityTime: 1_736_336_346)
		case .settings: ProfileSettings(saveDate: .now, validSubscription: true, userEnableNotification: false)
		}
	}
}

@Observable
class ProfileData {
	let network = NetworkProvider()

	var user: UserProfile?
	var avatar: NSImage?

	var isShowingNetworkOverlay: Bool = false
	var isUserDoesntExist: Bool = false

	func getProfile(id: Int) async {
		do /* throws(UserProfileError) */ {
			let fetchedUser = try await network.fetchUserProfile(id: id)
			user = fetchedUser
		} catch {
			switch error {
			case .networkRequestFailed: isShowingNetworkOverlay = true
			case let .backend(negativeID): fatalError("User ID: \(negativeID) can't be negative!")
			case .userDoesntExist: isUserDoesntExist = true
			}
		}
	}

	func updateUserProfile() async {}
}

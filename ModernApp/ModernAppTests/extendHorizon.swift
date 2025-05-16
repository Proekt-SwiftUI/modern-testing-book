//
//  extendHorizon.swift
//  ModernApp
//
//  Created by Nick Rossik on 3/4/25.
//

import Testing
import struct Foundation.URL

//extension Trait where Self == ConditionTrait {
//	static func skipWhenEmptyProducts(_ comment: Comment? = nil) -> Self {
//		.disabled(if: Products.catalog.isEmpty, comment)
//	}
//
//	static func skip(
//		_ comment: Comment? = nil,
//		condition: @escaping @Sendable () async throws -> Bool
//	) -> Self {
//		.disabled(comment) {
//			try await condition()
//		}
//	}
//}
//
//@Test(.skipWhenEmptyProducts("123123"))
//func adawda() {
//	#expect(throws: CancellationError.self) {
//		Task.isCancelled
//	}
//}

//@Test(.skip("Skip here", condition: {
//	false
//}))
//func skibidi() {
//
//}

struct YouTrackPerson {
	let trackerLogin: String
	let telegram: URL
}

extension YouTrackPerson {
	static let rossik = Self(trackerLogin: "@nick-rossik", telegram: .init(string: "https://github.com/wmorgue")!)
}

enum BugStatus {
	case open, inProgress, fixed
}

// extension Trait where Self == Bug {
// 	static func youTrack(
// 		assigned: YouTrackPerson,
// 		status: BugStatus = .open,
// 		_ link: _const String,
// 		title: Comment? = nil
// 	) -> Self {
// 		.bug(link, title)
// 	}

// 	static func youTrack(
// 		assigned: YouTrackPerson,
// 		status: BugStatus = .open,
// 		link: _const String? = nil,
// 		id: some Numeric,
// 		title: Comment? = nil
// 	) -> Self {
// 		.bug(link, id: id, title)
// 	}
// }
//
//@Test(
//	.youTrack(
//		assigned: .rossik,
//		"https://youtrack.wildberries.ru/issue/PROD-3.5.21"
//	)
//)
//func localChanges() {}










//func foo() async throws -> Bool { .random() }
//
//@Test(.disabled("Why 2nd param doesn't work?") { try await foo() } )
//func redditQuestion() async {}

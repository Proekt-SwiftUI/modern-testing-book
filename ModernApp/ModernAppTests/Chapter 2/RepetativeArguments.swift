// RepetativeArguments.swift
// Copyright (c) 2025 by Nikita Rossik. Created at 2/8/25.

import Testing

@testable
import ModernApp

@Suite(.tags(.cityFinder))
struct CityFinderTest {
	let cityFilter: CityFinder

	init(cityFilter: CityFinder = .init(cities: CityFinder.mockData)) {
		self.cityFilter = cityFilter
	}

	@Test
	func compareMoscowSize() async throws {
		let cities = try await cityFilter.search(by: "Moscow")
		let moscow = try #require(cities.first)
		#expect(moscow.population == 983_000)
	}
}

////	func allPaths() {
////		for path in ProfilePath.allCases {
//////			let value: ProfilePath = try? await network.updateProfile(with: path)
////		}
////	}
// }

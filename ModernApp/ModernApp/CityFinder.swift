// CityFinder.swift
// Copyright (c) 2025 by Nikita Rossik. Created at 1/11/25.

struct CityModel: Decodable {
	let name: String
	let population: Int
}

enum CityFinderError: Error {
	case passOneCityOrMore
	case emptyResult
}

actor CityFinder {
	let cities: [CityModel]

	init(cities: [CityModel]) {
		self.cities = cities
	}

	func search(by names: String...) throws -> [CityModel] {
		guard !names.isEmpty else {
			throw CityFinderError.passOneCityOrMore
		}

		let result: [CityModel] = cities.filter { city in
			names.contains(city.name)
		}

		guard !result.isEmpty else {
			throw CityFinderError.emptyResult
		}

		return result
	}
}

extension CityFinder {
	static var mockData: [CityModel] {
		[
			.init(name: "Moscow", population: 1_320_000),
			.init(name: "Kursk", population: 200_000),
			.init(name: "Gomel", population: 450_000),
		]
	}
}

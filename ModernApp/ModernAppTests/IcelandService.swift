//
//  IcelandService.swift
//  ModernApp
//
//  Created by Nick Rossik on 3/3/25.
//

import Testing

struct PlaceService {
	func search(by name: String) async -> Bool {
		let places: [String] = [
			"Gullfoss",
			"Saint Victor",
			"Vestmannaeyjar",
			"Skogafoss",
			"Hong Kong"
		]

		return places.contains(name)
	}
}

@Test(
	arguments: [
		"Gullfoss",
		"Moscow",
		"Vestmannaeyjar",
		"Skogafoss",
		"Paris",
		"Borocay",
		"Hong Kong"
	]
)
func findPlace(place: String) async throws {
	let service = PlaceService()
	let result = await service.search(by: place)
	#expect(result)
}

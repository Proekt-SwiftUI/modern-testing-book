//
//  ManyArguments.swift
//  ModernApp
//
//  Created by Nick Rossik on 3/1/25.
//

import Testing

enum Planet: CaseIterable {
	case mercury, venus, earth, gargantua, mars, jupiter, saturn, pluto, uranus, neptune, endurance
}

//func isPlanetInSolarSystem(_ planet: Planet) -> Bool {
//	switch planet {
//		case .mercury, .venus, .earth, .mars, .jupiter, .saturn, .uranus, .neptune: true
//		case .pluto, .gargantua, .endurance: false
//	}
//}

struct SpaceStation {
	let studying: Planet

	func explore(_ planet: Planet, duration: Int) async -> Bool {
		guard duration > 0 else { return false }

		let difficulty: Int

		switch planet {
			case .mercury:
				difficulty = 10 // Близко к Солнцу, высокая температура
			case .venus:
				difficulty = 15 // Экстремальные температура и давление
			case .earth:
				difficulty = 1 // Земля безопасна
			case .gargantua:
				difficulty = 100 // Гравитационные аномалии и временные искажения, крайне опасно
			case .mars:
				difficulty = 5 // Относительно безопасно, но требует ресурсов
			case .jupiter:
				difficulty = 20 // Газовый гигант, опасен для исследования
			case .saturn:
				difficulty = 18 // Газовый гигант с кольцами
			case .pluto:
				difficulty = 8 // Карликовая планета, далеко от Солнца
			case .uranus:
				difficulty = 16 // Ледяной гигант
			case .neptune:
				difficulty = 17 // Ледяной гигант с сильными ветрами
			case .endurance:
				difficulty = 50 // Космический корабль
		}

		guard duration >= difficulty else { return false }
		guard planet == studying else { return false }
		return true
	}
}

@Test(
	"Исследование планеты за время",
	arguments: 90...110
)
func explorePlanets(duration: Int) async {
	let spaceStation = SpaceStation(studying: .gargantua)
	#expect(await spaceStation.explore(.gargantua, duration: duration))
}

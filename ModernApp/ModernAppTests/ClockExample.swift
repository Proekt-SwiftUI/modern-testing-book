// ClockExample.swift
// Copyright (c) 2025 by Nikita Rossik. Created at 2/22/25.

import Testing

@Test("Ранний выход из-за отмены группы задач")
func cancelledTestExitsEarly() async throws {
	let timeAwaited: Duration = await ContinuousClock().measure {
		await withThrowingTaskGroup(of: Void.self) { taskGroup in
			taskGroup.addTask {
				try await Task.sleep(for: .seconds(60))
			}

			taskGroup.cancelAll()
		}
	}

	#expect(timeAwaited < .seconds(1))
}

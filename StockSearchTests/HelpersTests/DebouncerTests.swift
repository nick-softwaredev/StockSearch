//
//  DebouncerTests.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

import Testing
@testable import StockSearch

@MainActor
final private class DebouncerFlag {
    var wasCalled = false
}

@MainActor
final private class DebouncerCallCounter {
    var count = 0
}

@Suite
struct DebouncerTests {
    @Test("Triggers action once after full debounce delay")
    func actionExecutesAfterDelay() async {
        let debouncer = Debouncer(delay: 200_000_000) // 0.2s
        let flag = await DebouncerFlag()
        let start = ContinuousClock.now
        
        await debouncer.debounce {
            await MainActor.run {
                flag.wasCalled = true
            }
        }
        
        try? await Task.sleep(nanoseconds: 300_000_000)
        
        let duration = start.duration(to: ContinuousClock.now)
        await #expect(flag.wasCalled == true, "Expected debounced action to run")
        #expect(duration >= .nanoseconds(200_000_000), "Expected at least 0.2s delay before execution")
    }
    
    @Test("Only the last debounced call executes, earlier one is cancelled")
    func onlyLastDebouncedCallExecutes() async {
        let delay: UInt64 = 200_000_000
        let debouncer = Debouncer(delay: delay)
        let counter = await DebouncerCallCounter()
        
        // First call (will be cancelled)
        await debouncer.debounce {
            await MainActor.run {
                counter.count += 1
            }
        }
        
        try? await Task.sleep(nanoseconds: delay / 2) // wait half the debounce delay
        
        // Second call (should execute)
        await debouncer.debounce {
            await MainActor.run {
                counter.count += 1
            }
        }
        
        try? await Task.sleep(nanoseconds: delay + 100_000_000) // wait for second to finish
        
        await #expect(counter.count == 1, "Expected only the last debounced call to be executed")
    }
    
    @Test("Cancelled debounced task does not execute the action")
    func cancel_preventsExecution() async {
        let debouncer = Debouncer(delay: 300_000_000)
        let flag = await DebouncerFlag()
        
        await debouncer.debounce {
            await MainActor.run {
                flag.wasCalled = true
            }
        }
        
        try? await Task.sleep(nanoseconds: 100_000_000) // cancel before delay elapses
        await debouncer.cancel()
        
        try? await Task.sleep(nanoseconds: 300_000_000)
        
        await #expect(flag.wasCalled == false, "Expected action not to run after cancel")
    }
}

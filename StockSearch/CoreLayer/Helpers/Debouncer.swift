//
//  Debouncer.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

protocol DebouncerProtocol: Sendable {
    func debounce(action: @escaping @Sendable () async -> Void) async
    func cancel() async
}

actor Debouncer: DebouncerProtocol {
    private var task: Task<Void, Never>? = nil
    private let delay: UInt64

    init(delay: UInt64 = 300_000_000) {
        self.delay = delay
    }

    func debounce(action: @escaping @Sendable () async -> Void) {
        task?.cancel()

        task = Task {
            do {
                try await Task.sleep(nanoseconds: delay)
                guard !Task.isCancelled else { return }
                await action()
            } catch is CancellationError {
                // Cancelled during sleep — ignore
            } catch {
                // Unexpected errors — optionally log
            }
        }
    }

    func cancel() {
        task?.cancel()
        task = nil
    }
}

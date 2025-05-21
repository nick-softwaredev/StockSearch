//
//  DebounceMocks.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

@testable import StockSearch

actor InstantDebouncerMock: DebouncerProtocol {
    func debounce(action: @escaping () async -> Void) async {
        await action()
    }
    func cancel() { }
}


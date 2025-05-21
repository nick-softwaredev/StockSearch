//
//  StockSearchUseCaseMocks.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

@testable import StockSearch

final class MockSuccessStockSearchUseCase: StockSearchUseCaseProtocol {
    func searchForStockTicker(query: String) async -> Result<[Stock], StockSearchUseCaseError> {
        return .success([
            Stock(id: 1, name: "Apple Inc.", ticker: "AAPL", averagePrice: 190.2)
        ])
    }
}

final class MockEmptyStockSearchUseCase: StockSearchUseCaseProtocol {
    func searchForStockTicker(query: String) async -> Result<[Stock], StockSearchUseCaseError> {
        return .success([])
    }
}

final class MockFailureStockSearchUseCase: StockSearchUseCaseProtocol {
    func searchForStockTicker(query: String) async -> Result<[Stock], StockSearchUseCaseError> {
        return .failure(.network)
    }
}


actor CancellableStockSearchSearchUseCaseSpy: StockSearchUseCaseProtocol {
    private(set) var wasCancelled = false

    func searchForStockTicker(query: String) async -> Result<[Stock], StockSearchUseCaseError> {
        do {
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5s delay to simulate long lagging search request
            return .success([Stock(id: 999, name: "Should Not Be Returned", ticker: "CANCEL", averagePrice: 0)])
        } catch is CancellationError {
            wasCancelled = true
            return .failure(.network)
        } catch {
            return .failure(.network)
        }
    }
}

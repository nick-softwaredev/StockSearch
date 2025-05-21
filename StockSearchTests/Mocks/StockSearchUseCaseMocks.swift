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

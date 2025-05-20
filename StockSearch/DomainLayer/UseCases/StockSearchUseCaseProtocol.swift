//
//  StockSearchUseCaseProtocol.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//


import Foundation

protocol StockSearchUseCaseProtocol {
    func searchForStockTicker(query: String) async -> Result<[Stock], StockSearchUseCaseError>
}

enum StockSearchUseCaseError: Error {
    case network
    var userMessage: String {
        return "todo error"
    }
}

struct StockSearchUseCase: StockSearchUseCaseProtocol {
    let repository: StockSearchRepositoryProtocol

    func searchForStockTicker(query: String) async -> Result<[Stock], StockSearchUseCaseError> {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return .success([])
        }

        do {
            let result = try await repository.getSearchableDataFor(query: query)
            let searchResult = Array(
                result
                    .lazy
                    .filter { ($0.name+$0.ticker).contains(query.lowercased()) }
                    .prefix(10)
            )
            return .success(searchResult)
        } catch let error {
            // in real word, here i can also log analytics or any other business logic
            print(error)
            return .failure(.network)
        }
    }
}

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

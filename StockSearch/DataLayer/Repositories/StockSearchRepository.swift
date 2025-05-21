//
//  StockSearchRepository.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

import Foundation
import Resolver

// TODO: add cache service
protocol StockSearchCacheProtocol {
    func cache()
    func reset()
    func isEmpty()
    func search(query: String) -> [Stock]
}
//

struct StockSearchRepository: StockSearchRepositoryProtocol {
    // TODO: add cache service
    @Injected private var remoteDatabaseService: StockRemoteDataServiceProtocol
    @Injected private var responseAdapter: StockResponseAdapterProtocol

    func getSearchableDataFor(query: String) async throws -> ([Stock]) {
        let (currentData, historicData) = try await remoteDatabaseService.loadData(query: query)
        let stocksAdaptedResponse = responseAdapter.adapt(response: (currentData, historicData))

        return stocksAdaptedResponse
    }
}


struct MockStockSearchRepositorySuccess: StockSearchRepositoryProtocol {
    func getSearchableDataFor(query: String) async throws -> [Stock] {
        return [
            Stock(id: 1, name: "Apple Inc.", ticker: "AAPL", averagePrice: 190.2),
            Stock(id: 2, name: "Tesla Inc.", ticker: "TSLA", averagePrice: 215.3)
        ]
    }
}

struct MockStockSearchRepositoryEmpty: StockSearchRepositoryProtocol {
    func getSearchableDataFor(query: String) async throws -> [Stock] {
        return []
    }
}

struct MockStockSearchRepositoryFailure: StockSearchRepositoryProtocol {
    enum SimulatedError: Error {
        case simulated
    }

    func getSearchableDataFor(query: String) async throws -> [Stock] {
        throw SimulatedError.simulated
    }
}

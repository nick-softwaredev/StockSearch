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
    @Injected private var responseAdapter: StockResponseMergerProtocol

    func getSearchableDataFor(query: String) async throws -> ([Stock]) {
        let (currentData, historicData) = try await remoteDatabaseService.loadData(query: query)
        let stocksAdaptedResponse = responseAdapter.merge(response: (currentData, historicData))

        return stocksAdaptedResponse
    }
}

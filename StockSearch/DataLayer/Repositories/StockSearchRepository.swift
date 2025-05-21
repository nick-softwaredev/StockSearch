//
//  StockSearchRepository.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

import Foundation
import Resolver


struct StockSearchRepository: StockSearchRepositoryProtocol {
    @Injected private var remoteDatabaseService: StockRemoteDataServiceProtocol
    @Injected private var localDatabaseService: StockLocalDataServiceProtocol

    func getSearchableDataFor(query: String) async throws -> ([Stock]) {
        async let currentData = remoteDatabaseService.loadCurrentDataFor(query: query)

        let historicData: [StockDataEntry]
        
        // fetch historic data once and use cached version instead for further data requests
        if let cached = localDatabaseService.getCachedData() {
            historicData = cached
        } else {
            let fetched = try await remoteDatabaseService.loadHistoricDataFor(query: query)
            historicData = fetched.stocks
            localDatabaseService.setCache(historicData)
        }

        let mergedResponse = StockResponseMerger.merge(
            response: (try await currentData, StockDataResponse(stocks: historicData))
        )

        return mergedResponse
    }
}

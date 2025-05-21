//
//  StockRemoteDataService.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

import Foundation
import Resolver

struct StockRemoteDataService: StockRemoteDataServiceProtocol {
    @Injected private var sessionClient: StockAPIClientProtocol
    
    func loadCurrentDataFor(query: String) async throws -> StockDataResponse {
        try await sessionClient.fetch(StockDataResponse.self, from: .current(query), timeoutInterval: 10)
    }
    
    func loadHistoricDataFor(query: String) async throws -> StockDataResponse {
        try await sessionClient.fetch(StockDataResponse.self, from: .historical(query), timeoutInterval: 10)
    }
}

//
//  StockRemoteDataService.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

import Foundation

struct StockRemoteDataService: StockRemoteDataServiceProtocol {
    private let sessionClient: StockAPIClientProtocol

    init(sessionClient: StockAPIClientProtocol) {
        self.sessionClient = sessionClient
    }
    
    func loadCurrentDataFor(query: String) async throws -> StockDataResponse {
        try await sessionClient.fetch(StockDataResponse.self, from: .current(query), timeoutInterval: 10)
    }
    
    func loadHistoricDataFor(query: String) async throws -> StockDataResponse {
        try await sessionClient.fetch(StockDataResponse.self, from: .historical(query), timeoutInterval: 10)
    }
}

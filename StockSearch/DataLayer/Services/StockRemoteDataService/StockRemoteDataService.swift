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

    func loadData(query: String) async throws -> (current: StockDataResponse, historical: StockDataResponse) {
        async let historicalData = sessionClient.fetch(StockDataResponse.self, from: .historical(query), timeoutInterval: 10)
        async let currentData = sessionClient.fetch(StockDataResponse.self, from: .current(query), timeoutInterval: 10)

        return (current: try await currentData, historical: try await historicalData)
    }
}

//
//  StockRemoteDataServiceMocks.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

@testable import StockSearch

struct MockStockRemoteDataService: StockRemoteDataServiceProtocol {
    var result: Result<(current: StockDataResponse, historical: StockDataResponse), Error>

    func loadData(query: String) async throws -> (current: StockDataResponse, historical: StockDataResponse) {
        switch result {
        case .success(let data): return data
        case .failure(let error): throw error
        }
    }
}

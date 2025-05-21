//
//  StockRemoteDataServiceMocks.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

@testable import StockSearch

struct MockStockRemoteDataService: StockRemoteDataServiceProtocol {
    var resultCurrent: Result<StockDataResponse, Error>
    var resultHistoric: Result<StockDataResponse, Error>
    
    func loadCurrentDataFor(query: String) async throws -> StockSearch.StockDataResponse {
        switch resultCurrent {
        case .success(let data): return data
        case .failure(let error): throw error
        }
    }
    
    func loadHistoricDataFor(query: String) async throws -> StockSearch.StockDataResponse {
        switch resultHistoric {
        case .success(let data): return data
        case .failure(let error): throw error
        }
    }
}

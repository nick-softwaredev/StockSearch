//
//  StockSearchUseCaseMocks.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

@testable import StockSearch

struct MockSuccessStockSearchUseCase: StockSearchUseCaseProtocol {
    let expectedResult: [Stock]
    
    init(expectedResult: [Stock]) {
        self.expectedResult = expectedResult
    }
    
    func searchForStockTicker(query: String, resultLimit: Int) async -> Result<[Stock], StockSearchUseCaseError> {
        return .success(expectedResult)
    }
}

struct MockEmptyStockSearchUseCase: StockSearchUseCaseProtocol {
    func searchForStockTicker(query: String, resultLimit: Int) async -> Result<[Stock], StockSearchUseCaseError> {
        return .success([])
    }
}

struct MockFailureStockSearchUseCase: StockSearchUseCaseProtocol {
    func searchForStockTicker(query: String, resultLimit: Int) async -> Result<[Stock], StockSearchUseCaseError> {
        return .failure(.network)
    }
}

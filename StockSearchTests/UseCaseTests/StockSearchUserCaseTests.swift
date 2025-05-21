//
//  StockSearchUseCaseTests.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

import Testing
@testable import StockSearch

@Suite
struct StockSearchUseCaseTests {
    @Test("Returns result with one stock on successful query")
    func testSuccessSearchReturnsStock() async {
        let resultLimit = 10
        let expectedResult = ([
            Stock(id: 1, name: "Apple Inc.", ticker: "AAPL", currentPrice: 190, averagePrice: 190.2)
        ])
        
        let useCase = MockSuccessStockSearchUseCase(expectedResult: expectedResult)
        let result = await useCase.searchForStockTicker(query: "AAPL", resultLimit: resultLimit)

        switch result {
        case .success(let stocks):
            #expect(stocks.count == expectedResult.count, "Expected one stock in result")
            #expect(stocks.count < resultLimit, "Expected result to be within limit")
            #expect(stocks.first?.ticker == expectedResult.first?.ticker, "Expected ticker to be AAPL")
        case .failure:
            #expect(Bool(false), "Expected success, got failure")
        }
    }

    @Test("Returns empty result on empty match")
    func testEmptySearchReturnsNoStock() async {
        let useCase = MockEmptyStockSearchUseCase()
        let result = await useCase.searchForStockTicker(query: "XYZ", resultLimit: 0)

        switch result {
        case .success(let stocks):
            #expect(stocks.isEmpty, "Expected no stocks returned")
        case .failure:
            #expect(Bool(false), "Expected success, got failure")
        }
    }

    @Test("Returns failure on use case failure")
    func testFailureReturnsError() async {
        let useCase = MockFailureStockSearchUseCase()
        let result = await useCase.searchForStockTicker(query: "ANY", resultLimit: 0)

        switch result {
        case .success:
            #expect(Bool(false), "Expected failure, got success")
        case .failure(let error):
            #expect(error == .network, "Expected .network error")
        }
    }
}

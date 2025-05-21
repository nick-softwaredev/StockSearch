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
        let useCase = MockSuccessStockSearchUseCase()
        let result = await useCase.searchForStockTicker(query: "AAPL")

        switch result {
        case .success(let stocks):
            #expect(stocks.count == 1, "Expected one stock in result")
            #expect(stocks.first?.ticker == "AAPL", "Expected ticker to be AAPL")
        case .failure:
            #expect(Bool(false), "Expected success, got failure")
        }
    }

    @Test("Returns empty result on empty match")
    func testEmptySearchReturnsNoStock() async {
        let useCase = MockEmptyStockSearchUseCase()
        let result = await useCase.searchForStockTicker(query: "XYZ")

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
        let result = await useCase.searchForStockTicker(query: "ANY")

        switch result {
        case .success:
            #expect(Bool(false), "Expected failure, got success")
        case .failure(let error):
            #expect(error == .network, "Expected .network error")
        }
    }
}

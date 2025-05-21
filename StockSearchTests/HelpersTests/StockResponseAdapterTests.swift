//
//  StockResponseMergerTests.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

import Testing
@testable import StockSearch

@Suite
struct StockResponseMergerTests {
    @Test("Merges and averages prices correctly, sorted by name")
    func mergesAndSortsStocksCorrectly() {
        let current = StockDataResponse(stocks: [
            StockDataEntry(id: 1, name: "Apple", ticker: "AAPL", currentPrice: 200),
            StockDataEntry(id: 2, name: "Tesla", ticker: "TSLA", currentPrice: 700)
        ])
        let historical = StockDataResponse(stocks: [
            StockDataEntry(id: 3, name: "Apple", ticker: "AAPL", currentPrice: 210),
            StockDataEntry(id: 4, name: "Tesla", ticker: "TSLA", currentPrice: 720)
        ])

        let result = StockResponseMerger.merge(response: (current: current, historical: historical))

        #expect(result.count == 2)
        #expect(result[0].name == "Apple")
        #expect(result[0].averagePrice == 205)
        #expect(result[1].name == "Tesla")
        #expect(result[1].averagePrice == 710)
    }

    @Test("Returns empty list for empty responses")
    func emptyResponsesReturnEmptyList() {
        let result = StockResponseMerger.merge(response: (
            current: StockDataResponse(stocks: []),
            historical: StockDataResponse(stocks: [])
        ))

        #expect(result.isEmpty)
    }

    @Test("Adapts correctly with only one source (current)")
    func adaptsWithOnlyOneSource() {
        let result = StockResponseMerger.merge(response: (
            current: StockDataResponse(stocks: [
                StockDataEntry(id: 1, name: "Netflix", ticker: "NFLX", currentPrice: 350)
            ]),
            historical: StockDataResponse(stocks: [])
        ))

        #expect(result.count == 1)
        #expect(result.first?.ticker == "NFLX")
        #expect(result.first?.averagePrice == 350)
    }
}

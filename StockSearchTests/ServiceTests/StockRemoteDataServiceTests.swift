//
//  StoclRemoteDataServiceTests.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

import Testing
@testable import StockSearch

@Suite
struct StockRemoteDataServiceTests {
    @Test("Returns correct data on success")
    func loadDataSuccessReturnsMergedStockResponse() async throws {
        let current = StockDataResponse(stocks: [
            StockDataEntry(id: 1, name: "Apple", ticker: "AAPL", currentPrice: 190)
        ])
        let historical = StockDataResponse(stocks: [
            StockDataEntry(id: 2, name: "Apple", ticker: "AAPL", currentPrice: 210)
        ])
        let mock = MockStockRemoteDataService(result: .success(current))

        let result = try await mock.loadData(query: "AAPL")

        #expect(result.current.stocks.count == 1)
        #expect(result.historical.stocks.count == 1)
        #expect(result.current.stocks.first?.currentPrice == 190)
    }

    @Test("Throws error when underlying service fails")
    func loadDataThrowsError() async {
        enum MockError: Error {
            case testFailure
        }
        
        let mock = MockStockRemoteDataService(result: .failure(MockError.testFailure))

        do {
            _ = try await mock.loadData(query: "AAPL")
            #expect(Bool(false), "Expected to throw error but succeeded")
        } catch {
            #expect(true, "Caught expected error")
        }
    }
}

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
        let mock = MockStockRemoteDataService(resultCurrent: .success(current), resultHistoric: .success(historical))

        let resultCurrent = try await mock.loadCurrentDataFor(query: "AAPL")
        let resultHistoric = try await mock.loadCurrentDataFor(query: "AAPL")

        #expect(resultCurrent.stocks.count == 1)
        #expect(resultHistoric.stocks.count == 1)
        #expect(resultCurrent.stocks.first?.currentPrice == 190)
    }

    @Test("Throws error when underlying service fails")
    func loadDataThrowsError() async {
        enum MockError: Error {
            case testFailure
        }
        
        let mock = MockStockRemoteDataService(resultCurrent: .failure(MockError.testFailure), resultHistoric: .failure(MockError.testFailure))

        do {
            _ = try await mock.loadCurrentDataFor(query: "AAPL")
            #expect(Bool(false), "Expected to throw error but succeeded")
        } catch {
            #expect(true, "Caught expected error")
        }
    }
}

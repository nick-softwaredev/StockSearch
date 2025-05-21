//
//  StockLocalDataService.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/21/25.
//

import Testing
@testable import StockSearch

struct StockLocalDataServiceTests {
    @Test
    func returnsSameDataAfterSet() async {
        let service = StockLocalDataService()
        let mockData: [StockDataEntry] = [
            StockDataEntry(id: 1, name: "Apple", ticker: "AAPL", currentPrice: 172.3),
            StockDataEntry(id: 2, name: "Tesla", ticker: "TSLA", currentPrice: 205.7)
        ]

        service.setCache(mockData)

        guard let result = service.getCachedData() else {
            #expect(Bool(false), "Cache should be present")
            return
        }

        #expect(result == mockData)
    }

    @Test
    func returnsNilWhenCacheIsEmpty() async {
        let service = StockLocalDataService()

        let result = service.getCachedData()

        #expect(result == nil)
    }
}

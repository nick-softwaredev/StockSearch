//
//  SearchTests.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/21/25.
//


@testable import StockSearch
import Testing
import Foundation

private func generateFakeStocks(count: Int = 100_000) -> [Stock] {
    let adjectives = ["Global", "Quantum", "Alpha", "Eco", "Green", "Nova", "Unified", "Cyber", "Solid", "Blue"]
    let nouns = ["Systems", "Industries", "Technologies", "Holdings", "Partners", "Enterprises", "Networks", "Markets"]
    
    var stocks: [Stock] = []
    stocks.reserveCapacity(count)
    
    for id in 1...count {
        let name = "\(adjectives.randomElement()!) \(nouns.randomElement()!)"
        let ticker = String((0..<Int.random(in: 3...5)).map { _ in
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ".randomElement()!
        })
        
        let basePrice = Double.random(in: 10...1000)
        let volatility = Double.random(in: -10...10)
        
        stocks.append(Stock(
            id: id,
            name: name,
            ticker: ticker,
            currentPrice: (basePrice + volatility).rounded(toPlaces: 2),
            averagePrice: basePrice.rounded(toPlaces: 2)
        ))
    }
    
    return stocks
}

struct StockSearchHelperTests {
    private let stocks: [Stock] = [
        Stock(id: 1, name: "Apple Inc.", ticker: "AAPL", currentPrice: 190.5, averagePrice: 188.0),
        Stock(id: 2, name: "Amazon Corporation", ticker: "AMZN", currentPrice: 3200.0, averagePrice: 3100.0),
        Stock(id: 3, name: "Tesla Motors", ticker: "TSLA", currentPrice: 700.0, averagePrice: 690.0),
        Stock(id: 4, name: "Alphabet Inc.", ticker: "GOOGL", currentPrice: 2700.0, averagePrice: 2600.0),
        Stock(id: 5, name: "Nvidia Technologies", ticker: "NVDA", currentPrice: 600.0, averagePrice: 580.0)
    ]
    
    @Test
    func returnsTickerMatchesWhenShortQuery() async {
        let result = StockSearchHelper.search(query: "AA", mergedStockData: stocks, resultLimit: 10)
        #expect(result.contains { $0.ticker == "AAPL" })
        #expect(result.allSatisfy { $0.ticker.lowercased().hasPrefix("aa") })
    }
    
    @Test
    func returnsNameMatchesWhenLongQuery() async {
        let result = StockSearchHelper.search(query: "Tes", mergedStockData: stocks, resultLimit: 10)
        #expect(result.count == 1)
        #expect(result.first?.name == "Tesla Motors")
    }
    
    @Test
    func respectsResultLimit() async {
        let largeList = Array(repeating: stocks, count: 100).flatMap { $0 } // 500 items
        let result = StockSearchHelper.search(query: "a", mergedStockData: largeList, resultLimit: 5)
        #expect(result.count == 5)
    }
    
    @Test("This test tests search with 1_000_000 items to search")
    func searchPerformanceOnLargeDataset() async {
        let size = 1_000_000
        let largeDataset = generateFakeStocks(count: size)
        
        #expect(largeDataset.count == size) // threshold to assert speed
        
        let start = CFAbsoluteTimeGetCurrent()
        
        _ = StockSearchHelper.search(query: "ap", mergedStockData: largeDataset, resultLimit: 10)
        
        let duration = CFAbsoluteTimeGetCurrent() - start
        print("⏱️ Search took \(duration) seconds")
        
        #expect(duration < 0.01) // threshold to assert speed
    }
}

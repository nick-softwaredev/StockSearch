//
//  StockResponseAdapter.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

///  Merger protocol, conform to create various implementations with different algorhitm
protocol StockResponseMergerProtocol {
    func merge(response: (current: StockDataResponse, historical: StockDataResponse)) -> [Stock]
}

struct StockResponseMerger: StockResponseMergerProtocol {
    /// Merges two datasets into new single array. Total complexity for this function is O(n + m), perfect for unsorted datasets utilizing has map (dictionary)
    func merge(response: (current: StockDataResponse, historical: StockDataResponse)) -> [Stock] {
        let allEntries = response.current.stocks + response.historical.stocks

        let grouped = Dictionary(grouping: allEntries, by: \.ticker)

        let mergedStocks: [Stock] = grouped.compactMap { (ticker, entries) in
            if let first = entries.first {
                let averagePrice = entries.map(\.currentPrice).reduce(0, +) / Double(entries.count).rounded(toPlaces: 2)

                return Stock(
                    id: first.id,
                    name: first.name,
                    ticker: ticker,
                    currentPrice: first.currentPrice,
                    averagePrice: averagePrice
                )
            } else {
                return nil
            }
        }

        return mergedStocks
    }
}

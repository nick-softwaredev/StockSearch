//
//  StockReponseAdapter.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

protocol StockResponseAdapterProtocol {
    func adapt(response: (current: StockDataResponse, historical: StockDataResponse)) -> [Stock]
}

struct StockResponseAdapter: StockResponseAdapterProtocol {
    func adapt(response: (current: StockDataResponse, historical: StockDataResponse)) -> [Stock] {
        let allEntries = response.current.stocks + response.historical.stocks

        let grouped = Dictionary(grouping: allEntries, by: \.ticker)

        let mergedStocks: [Stock] = grouped.compactMap { (ticker, entries) in
            if let first = entries.first {
                let averagePrice = entries.map(\.currentPrice).reduce(0, +) / Double(entries.count)

                return Stock(
                    id: first.id,
                    name: first.name,
                    ticker: ticker,
                    averagePrice: averagePrice
                )
            } else {
                return nil
            }
        }

        return mergedStocks.sorted { $0.name < $1.name }
    }
}

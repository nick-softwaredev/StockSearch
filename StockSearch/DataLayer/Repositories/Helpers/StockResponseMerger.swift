//
//  StockResponseAdapter.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

///  Merger protocol, conform to create various implementations with different algorhitm
protocol StockResponseMergerProtocol {
    static func merge(response: (current: StockDataResponse, historical: StockDataResponse)) -> [Stock]
}

enum StockResponseMerger: StockResponseMergerProtocol {
    /// Merges two aligned datasets of stock data efficiently by calculating the average price for each stock.
    ///
    /// This function assumes that the `current` and `historical` datasets are in the same order and represent
    /// the same stocks (matched by index). Each pair of entries is merged into a single `Stock` object that includes:
    /// - The `currentPrice` from the `current` dataset
    /// - The `averagePrice` calculated from the `current` and `historical` prices
    ///
    /// - Parameters:
    ///   - response: A tuple containing the current and historical stock data responses.
    /// - Returns: An array of merged `Stock` objects, one for each matched pair.
    ///
    /// - Complexity:
    ///   - Time: O(n), where n is the number of stocks (assuming both arrays are of equal length).
    ///   - Space: O(n), for the resulting array of merged `Stock` entries.
    static func merge(response: (current: StockDataResponse, historical: StockDataResponse)) -> [Stock] {
        zip(response.current.stocks, response.historical.stocks).map { current, historical in
            let averagePrice = ((current.currentPrice + historical.currentPrice) / 2).rounded(toPlaces: 2)
            
            return Stock(
                id: current.id,
                name: current.name,
                ticker: current.ticker,
                currentPrice: current.currentPrice,
                averagePrice: averagePrice
            )
        }
    }
}

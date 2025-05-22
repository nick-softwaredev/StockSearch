//
//  StockSearchHelper.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

import Foundation

enum StockSearchHelper {
    /// Searches for stocks whose ticker or name starts with the given query prefix.
    ///
    /// The function applies prefix filtering to reduce the dataset and then sorts the filtered results.
    /// If the query is short (less than 3 characters), it prioritizes matching and sorting by ticker.
    /// For longer queries, it expands the match to both ticker and name, and sorts by name primarily.
    ///
    /// Performance is measured and printed to the console using `CFAbsoluteTime`, which is useful for
    /// profiling in development.
    ///
    /// - Parameters:
    ///   - query: The user input string to search by. Matching is done with lowercased prefix comparison.
    ///   - mergedStockData: The complete dataset of stocks to search from.
    ///   - resultLimit: The maximum number of matching results to return.
    ///
    /// - Returns: A sorted array of up to `resultLimit` matching `Stock` entries.
    ///
    /// - Complexity:
    ///   - Let `n` be the total number of stocks in `mergedStockData`.
    ///   - Let `m` be the number of items matching the query prefix (where `m ≤ n`).
    ///   - Filtering is O(n), sorting is O(m log m), and limiting is O(k), where `k = resultLimit`.
    ///   - Therefore, total time complexity: **O(n + m log m)**.
    static func search(query: String, mergedStockData: [Stock], resultLimit: Int) -> [Stock] {
        let normalizedQuery = query.lowercased()
        let sortedByTicker = normalizedQuery.count < 3
        
        return Array(
            mergedStockData
                .lazy
                .filter {
                    if sortedByTicker {
                        // Only match ticker prefix
                        return $0.ticker.lowercased().hasPrefix(normalizedQuery)
                    } else {
                        // Match name or ticker
                        return $0.name.lowercased().hasPrefix(normalizedQuery) ||
                               $0.ticker.lowercased().hasPrefix(normalizedQuery)
                    }
                }
                .prefix(resultLimit)
                .sorted {
                    sortedByTicker
                    ? ($0.ticker.lowercased(), $0.name.lowercased()) < ($1.ticker.lowercased(), $1.name.lowercased())
                    : ($0.name.lowercased(), $0.ticker.lowercased()) < ($1.name.lowercased(), $1.ticker.lowercased())
                }
        )
    }
}

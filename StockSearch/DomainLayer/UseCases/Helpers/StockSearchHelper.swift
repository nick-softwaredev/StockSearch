//
//  StockSearchHelper.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

///  Search protocol, conform to create various implementations with different algorhitm
protocol StockSearchHelper {
    func search(input: [Stock]) -> [Stock]
}

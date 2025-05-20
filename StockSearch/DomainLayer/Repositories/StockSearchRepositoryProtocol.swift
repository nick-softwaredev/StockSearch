//
//  StockSearchRepositoryProtocol.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

protocol StockSearchRepositoryProtocol {
    func getSearchableDataFor(query: String) async throws -> ([Stock])
}

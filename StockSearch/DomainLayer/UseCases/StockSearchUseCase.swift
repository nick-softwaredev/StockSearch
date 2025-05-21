//
//  StockSearchUseCaseProtocol.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//


import Foundation

protocol StockSearchUseCaseProtocol {
    func searchForStockTicker(query: String) async -> Result<[Stock], StockSearchUseCaseError>
}

enum StockSearchUseCaseError: LocalizedError {
    case network
    
    var errorDescription: String {
        return "Search failed"
    }
    
    var recoverySuggestion: String {
        return "Please, try again"
    }
}

struct StockSearchUseCase: StockSearchUseCaseProtocol {
    let repository: StockSearchRepositoryProtocol

    func searchForStockTicker(query: String) async -> Result<[Stock], StockSearchUseCaseError> {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return .success([])
        }

        do {
            let result = try await repository.getSearchableDataFor(query: query)
            let searchResult = Array(
                result
                    .lazy
                    .filter { ($0.name + " " + $0.ticker).lowercased().contains(query.lowercased()) }
                    .prefix(10)
            )
            return .success(searchResult)
        } catch let error {
            // in real word, here i can also log analytics or any other business logic
            print(error)
            return .failure(.network)
        }
    }
}

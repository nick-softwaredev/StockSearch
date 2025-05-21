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
    case cancelled
    case network
    case decoding
    case system
    case unknown
    
    var errorDescription: String {
        return "Search failed"
    }
    
    var recoverySuggestion: String {
        switch self {
        case .network:
            return "Check your internet connection."
        case .decoding:
            return "Data format error. Try again later."
        case .system:
            return "Unexpected system error. Try again later."
        case .unknown:
            return "Something went wrong. Please try again."
        case .cancelled:
            return "Cancelled"
        }
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
        } catch let error as URLError where error.code == .cancelled {
            print("Request cancelled:")
            return .failure(.cancelled)
        } catch let error as URLError {
            print("URLError: \(error)")
            return .failure(.network)
        } catch let error as DecodingError {
            print("DecodingError: \(error)")
            return .failure(.decoding)
        } catch let error as NSError where error.domain == NSCocoaErrorDomain {
            print("NSCocoaErrorDomain error: \(error)")
            return .failure(.system)
        } catch {
            print("Unknown error: \(error)")
            return .failure(.unknown)
        }
    }
}

//
//  StockSearchViewModel.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

import SwiftUI
import Resolver

@MainActor
final class StockSearchViewModel: ObservableObject {
    enum ViewState: Equatable {
        case idle
        case loading
        case loadedWithResult([Stock])
        case loadedWithNoResult(query: String)
        case loadedWithError(description: String, message: String)
    }
    
    @Published var viewState: ViewState = .idle
    @Published var searchText: String = ""
    
    private let searchUseCase: StockSearchUseCaseProtocol
    private let debouncer: DebouncerProtocol
    
    init(searchUseCase: StockSearchUseCaseProtocol, debouncer: DebouncerProtocol) {
        self.searchUseCase = searchUseCase
        self.debouncer = debouncer
    }
    
    func onSearchTextChanged(_ query: String) async {
        await debouncer.debounce {
            await self.search(query: query)
        }
    }
    
    func search(query: String) async {
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            viewState = .idle
            return
        }
        
        viewState = .loading
        let result = await searchUseCase.searchForStockTicker(query: query)
        
        
        switch result {
        case .success(let searchResult):
            viewState = searchResult.isEmpty ? .loadedWithNoResult(query: query) : .loadedWithResult(searchResult)
        case .failure(let failure):
            viewState = .loadedWithError(description: failure.errorDescription, message: failure.recoverySuggestion)
        }
    }
}

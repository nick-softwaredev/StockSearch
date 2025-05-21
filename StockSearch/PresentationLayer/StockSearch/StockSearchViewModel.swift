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
        case loadedWithResult
        case loadedWithNoResult(query: String)
        case loadedWithError(message: String)
    }

    @Published private(set) var searchResult: [Stock] = []
    @Published var viewState: ViewState = .idle
    @Published var searchText: String = ""

    private var searchTask: Task<Void, Never>?

    private let searchUseCase: StockSearchUseCaseProtocol
    private let debouncer: DebouncerProtocol
    
    init(searchUseCase: StockSearchUseCaseProtocol, debouncer: DebouncerProtocol) {
        self.searchUseCase = searchUseCase
        self.debouncer = debouncer
    }

    @MainActor
    func onSearchTextChanged(_ query: String) async {
        await debouncer.debounce {
             await self.search(query: query)
         }
     }

    @MainActor
    func search(query: String) async {
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            searchTask?.cancel()
            self.searchResult = []
            viewState = .idle
            return
        }
        
        searchTask?.cancel()

        searchTask = Task {
            guard !Task.isCancelled else { return } // Prevent earlier cancelled task from running

            viewState = .loading
            let result = await searchUseCase.searchForStockTicker(query: query)

            guard !Task.isCancelled else { return } // Verify if  still alive, only then update

            switch result {
            case .success(let searchResult):
                viewState = searchResult.isEmpty ? .loadedWithNoResult(query: query) : .loadedWithResult
                self.searchResult = searchResult
            case .failure(let failure):
                viewState = .loadedWithError(message: failure.errorDescription)
                self.searchResult = []
            }
        }
    }
    
    deinit {
        searchTask?.cancel()
    }
}

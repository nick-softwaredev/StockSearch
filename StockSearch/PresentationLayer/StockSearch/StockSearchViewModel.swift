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
        case loadedWithError(description: String, message: String)
    }
    
    @Published var searchResult: [Stock] = []
    @Published var viewState: ViewState = .idle
    @Published var searchText: String = ""
    
    private let searchUseCase: StockSearchUseCaseProtocol
    private let debouncer: DebouncerProtocol
    private let networkMonitor: NetworkMonitoringProtocol
    
    init(searchUseCase: StockSearchUseCaseProtocol, debouncer: DebouncerProtocol, networkMonitor: NetworkMonitoringProtocol) {
        self.searchUseCase = searchUseCase
        self.debouncer = debouncer
        self.networkMonitor = networkMonitor
        self.networkMonitor.startMonitoring()
    }
    
    func onSearchTextChanged(_ query: String) async {
        await debouncer.debounce {
            await self.search(query: query)
        }
    }
    
    func search(query: String) async {
        if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            searchResult = []
            viewState = .idle
            return
        }
        
        if networkMonitor.isConnected == false {
            viewState = .loadedWithError(description: "No Internet Connection", message: "Please, check your internet connection and try again.")
            // do not return and proceed with search request, if internet re appears before request timeout will execute
        }
        
        viewState = .loading
        let result = await searchUseCase.searchForStockTicker(query: query, resultLimit: 10)
        
        switch result {
        case .success(let searchResult):
            self.searchResult = searchResult
            viewState = searchResult.isEmpty ? .loadedWithNoResult(query: query) : .loadedWithResult
        case .failure(let failure):
            if failure == .cancelled {
                // error stating that previous search operation cancelled, do not display to end user.
                return
            }
            searchResult = []
            viewState = .loadedWithError(description: failure.errorDescription, message: failure.recoverySuggestion)
        }
    }
    
    deinit {
        self.networkMonitor.stopMonitoring()
    }
}

//
//  StcokSerachViewModelTests.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

import Testing
@testable import StockSearch

@Suite
struct StockSearchViewModelTests {
    
    @MainActor @Test("ViewModel enters idle state when input query is empty or whitespace")
    func idleStateOnEmptyQuery() async {
        let vm = await MainActor.run {
            StockSearchViewModel(
                searchUseCase: MockEmptyStockSearchUseCase(),
                debouncer: InstantDebouncerMock()
            )
        }
        
        await vm.onSearchTextChanged("   ")
        
        #expect(vm.viewState == .idle, "Expected viewState to be .idle for empty query")
        #expect(vm.searchResult.isEmpty, "Expected searchResult to be empty")
    }
    
    @MainActor @Test("ViewModel sets state to .loadedWithResult and updates results on successful search")
    func successfulSearchSetsLoadedWithResult() async {
        let expectedResult = ([
            Stock(id: 1, name: "Apple Inc.", ticker: "AAPL", averagePrice: 190.2)
        ])
        
        let vm =
        StockSearchViewModel(
            searchUseCase: MockSuccessStockSearchUseCase(expectedResult: expectedResult),
            debouncer: InstantDebouncerMock()
        )
        
        
        await vm.onSearchTextChanged("AAPL")
        
        if case .loadedWithResult = vm.viewState {
            #expect(vm.searchResult.count == expectedResult.count, "Expected one result")
            #expect(vm.searchResult.first?.ticker == expectedResult.first?.ticker, "Expected result ticker to be AAPL")
        } else {
            #expect(Bool(false), "Expected .loadedWithResult state")
        }
    }
    
    @MainActor @Test("ViewModel sets state to .loadedWithNoResult for valid query that returns no matches")
    func emptySearchSetsLoadedWithNoResult() async {
        let vm = await MainActor.run {
            StockSearchViewModel(
                searchUseCase: MockEmptyStockSearchUseCase(),
                debouncer: InstantDebouncerMock()
            )
        }
        
        await vm.onSearchTextChanged("XYZ")
        
        guard case let .loadedWithNoResult(query) = vm.viewState else {
            return #expect(Bool(false), "Expected viewState to be .loadedWithNoResult")
        }
        
        #expect(vm.searchResult.isEmpty, "Expected searchResult to be empty")
        #expect(query == "XYZ", "Expected query to be carried into state")
    }
    
    @MainActor @Test("ViewModel sets state to .loadedWithError when search use case fails")
    func failureSetsLoadedWithError() async {
        let vm = await MainActor.run {
            StockSearchViewModel(
                searchUseCase: MockFailureStockSearchUseCase(),
                debouncer: InstantDebouncerMock()
            )
        }
        
        await vm.onSearchTextChanged("AAPL")
        
        guard case let .loadedWithError(description, recoverySuggestion) = vm.viewState else {
            return #expect(Bool(false), "Expected viewState to be .loadedWithError")
        }
        
        #expect(description == "Search failed", "Expected correct error message")
    }
}

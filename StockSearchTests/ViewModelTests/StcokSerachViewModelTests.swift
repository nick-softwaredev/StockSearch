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

    @Test("ViewModel enters idle state when input query is empty or whitespace")
    func idleStateOnEmptyQuery() async {
        let vm = await MainActor.run {
            StockSearchViewModel(
                searchUseCase: MockSuccessStockSearchUseCase(),
                debouncer: InstantDebouncerMock()
            )
        }

        await vm.onSearchTextChanged("   ")

        await #expect(vm.viewState == .idle, "Expected viewState to be .idle for empty query")
        await #expect(vm.searchResult.isEmpty, "Expected no results for empty query")
    }

    @Test("ViewModel sets state to .loadedWithResult and updates results on successful search")
    func successfulSearchSetsLoadedWithResult() async {
        let vm = await MainActor.run {
            StockSearchViewModel(
                searchUseCase: MockSuccessStockSearchUseCase(),
                debouncer: InstantDebouncerMock()
            )
        }

        await vm.onSearchTextChanged("AAPL")

        await #expect(vm.viewState == .loadedWithResult, "Expected .loadedWithResult state")
        await #expect(vm.searchResult.count == 1, "Expected one result")
        await #expect(vm.searchResult.first?.ticker == "AAPL", "Expected result ticker to be AAPL")
    }

    @Test("ViewModel sets state to .loadedWithNoResult for valid query that returns no matches")
    func emptySearchSetsLoadedWithNoResult() async {
        let vm = await MainActor.run {
            StockSearchViewModel(
                searchUseCase: MockEmptyStockSearchUseCase(),
                debouncer: InstantDebouncerMock()
            )
        }

        await vm.onSearchTextChanged("XYZ")

        guard case let .loadedWithNoResult(query) = await vm.viewState else {
            return #expect(Bool(false), "Expected viewState to be .loadedWithNoResult")
        }

        #expect(query == "XYZ", "Expected query to be carried into state")
        await #expect(vm.searchResult.isEmpty, "Expected empty result list")
    }

    @Test("ViewModel sets state to .loadedWithError when search use case fails")
    func failureSetsLoadedWithError() async {
        let vm = await MainActor.run {
            StockSearchViewModel(
                searchUseCase: MockFailureStockSearchUseCase(),
                debouncer: InstantDebouncerMock()
            )
        }

        await vm.onSearchTextChanged("AAPL")

        guard case let .loadedWithError(message) = await vm.viewState else {
            return #expect(Bool(false), "Expected viewState to be .loadedWithError")
        }

        //#expect(message == "Network error", "Expected correct error message")
        await #expect(vm.searchResult.isEmpty, "Expected no search results on failure")
    }
}

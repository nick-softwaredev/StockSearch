//
//  StockSearchView.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

import SwiftUI

struct StockSearchView: View {
    @StateObject var viewModel: StockSearchViewModel

    var body: some View {
        ZStack {
            StockSearchViewList(stocks: viewModel.searchResult)
            switch viewModel.viewState {
            case .idle:
                EmptyView()
            case .loading:
                EmptyView()
            case .loadedWithResult:
                EmptyView()
            case .loadedWithNoResult(let query):
                StockSearchViewListOverlay(message: .custom("No results for '\(query)'"))
            case .loadedWithError(let description, let message):
                StockSearchViewListOverlay(message: .error(description: description, suggestion: message))
            }
        }
        .navigationTitle("Search Stocks")
        .searchable(text: $viewModel.searchText, prompt: "Search by name or ticker")
        .onChange(of: viewModel.searchText) { newValue in
            Task {
                await viewModel.onSearchTextChanged(newValue)
            }
        }
    }
}

#Preview {
    NavigationStack {
        StockSearchView(
            viewModel: StockSearchViewModel(searchUseCase: StockSearchUseCase(repository: StockSearchRepositoryProtocol_Preview()), debouncer: Debouncer(), networkMonitor: MockNetworkMonitorConnected())
        )
    }
}

struct StockSearchViewList: View {
    let stocks: [Stock]
    
    var body: some View {
        List {
            ForEach(stocks) { stock in
                StockSearchViewRow(stock: stock)
                .padding(.vertical, 4)
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    StockSearchViewList(stocks: Stock.mockList)
}

struct StockSearchViewRow: View {
    let stock: Stock
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(stock.ticker)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(stock.name)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 6) {
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Current")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(stock.currentPrice, format: .currency(code: "USD"))
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
                
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Average")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text(stock.averagePrice, format: .currency(code: "USD"))
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    StockSearchViewRow(stock: .mockGOOG)
}

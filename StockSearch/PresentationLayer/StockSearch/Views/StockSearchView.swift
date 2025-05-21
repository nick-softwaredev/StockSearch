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
        VStack {
            switch viewModel.viewState {
            case .loadedWithResult(let searchResult):
                StockSearchViewList(stocks: searchResult)
            default:
                StockSearchViewListOverlay(viewState: viewModel.viewState)
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
        HStack {
            VStack(alignment: .leading) {
                Text(stock.ticker)
                    .font(.headline)
                Text(stock.name)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(stock.averagePrice, format: .currency(code: "USD"))
                .font(.body)
        }
    }
}

#Preview {
    StockSearchViewRow(stock: .mockGOOG)
}

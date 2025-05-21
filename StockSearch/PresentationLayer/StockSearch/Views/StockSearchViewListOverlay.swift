//
//  StockSearchViewListOverlay.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

import SwiftUI

struct StockSearchViewListOverlay: View {
    let viewState: StockSearchViewModel.ViewState
    
    var body: some View {
        VStack {
            switch viewState {
            case .idle:
                EmptyView()
            case .loading:
                EmptyView()
            case .loadedWithResult:
                EmptyView()
            case .loadedWithNoResult(let query):
                Text("No results for '\(query)'")
                    .animation(.easeIn, value: query)
            case .loadedWithError(let message, let suggestion):
                VStack {
                    Text(message)
                    Text(suggestion)
                        .font(.body)
                }
                .padding()
            }
        }
    }
}

#Preview {
    StockSearchViewListOverlay(viewState: .idle)
}

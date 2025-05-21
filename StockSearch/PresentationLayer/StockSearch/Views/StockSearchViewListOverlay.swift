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
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.orange)
                    
                    Text(message)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)

                    Text(suggestion)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .padding()
            }
        }
    }
}

#Preview {
    StockSearchViewListOverlay(viewState: .idle)
}

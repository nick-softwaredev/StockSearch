//
//  ContentView.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

import SwiftUI
import Resolver

struct RootView: View {
    var body: some View {
        NavigationStack {
            StockSearchView(
                viewModel: StockSearchViewModel(
                    searchUseCase: Resolver.resolve(),
                    debouncer:  Resolver.resolve(),
                    networkMonitor: Resolver.resolve()
                )
            )
        }
    }
}

#Preview {
    RootView()
}


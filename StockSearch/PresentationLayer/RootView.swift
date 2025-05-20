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
            StockSearchView(viewModel: Resolver.resolve(StockSearchViewModel.self))
        }
    }
}

#Preview {
    RootView()
}


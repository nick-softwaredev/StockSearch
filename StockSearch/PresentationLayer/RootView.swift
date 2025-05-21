//
//  ContentView.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

import SwiftUI
import Resolver

@MainActor
final class NavigationPathCoordinator: ObservableObject {
    enum Path: Hashable {

    }
    @Published var path = NavigationPath()
}


struct RootView: View {
    @StateObject var coordinator = NavigationPathCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
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


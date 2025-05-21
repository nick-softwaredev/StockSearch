//
//  Resolver+TestDepenancyInjection.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

import Resolver
@testable import StockSearch

extension Resolver {
    static var test = Resolver(child: .main)
    
    static func registerStockSearchViewModelhMocks() {
         test.register {
             StockSearchViewModel(
                    searchUseCase: test.resolve(StockSearchUseCaseProtocol.self),
                    debouncer: test.resolve(DebouncerProtocol.self)
                )
         }
     }
}

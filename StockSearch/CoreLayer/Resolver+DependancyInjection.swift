//
//  Resolver+DependancyInjection.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

import Resolver

extension Resolver: ResolverRegistering {
  public static func registerAllServices() {
      register { Debouncer() as DebouncerProtocol }
          .scope(.unique)
      
      register { MockStockSearchRepositorySuccess() as StockSearchRepositoryProtocol } // TODO: temp, replace with real thing
          .scope(.unique)

      register { StockSearchUseCase(repository: resolve()) as StockSearchUseCaseProtocol }
          .scope(.application)

      register {
          StockSearchViewModel()
      }
      .scope(.unique)
  }
}

//
//  Resolver+DependancyInjection.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

import Resolver

extension Resolver: @retroactive ResolverRegistering {
    public static func registerAllServices() {
        register { Debouncer() as DebouncerProtocol }
            .scope(.unique)
        
        register { StockAPIClient() as StockAPIClientProtocol }
            .scope(.application)
        
        register { StockAPIClient() as StockAPIClientProtocol }
            .scope(.application)
        
        register { StockRemoteDataService(sessionClient: resolve()) as StockRemoteDataServiceProtocol }
            .scope(.application)
        
        register { StockResponseMerger() as StockResponseMergerProtocol }
            .scope(.application)
        
        register { StockSearchRepository() as StockSearchRepositoryProtocol }
            .scope(.application)
        
        register { StockSearchUseCase(repository: resolve()) as StockSearchUseCaseProtocol }
            .scope(.application)
    }
}

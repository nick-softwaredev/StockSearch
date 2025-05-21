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
        
        register { NetworkMonitor() as NetworkMonitoringProtocol }
            .scope(.application)
        
        register { StockRemoteDataService() as StockRemoteDataServiceProtocol }
            .scope(.application)
        
        register { StockLocalDataService() as StockLocalDataServiceProtocol }
            .scope(.application)
        
        register { StockSearchRepository() as StockSearchRepositoryProtocol }
            .scope(.application)
        
        register { StockSearchUseCase(repository: resolve()) as StockSearchUseCaseProtocol }
            .scope(.application)
    }
}

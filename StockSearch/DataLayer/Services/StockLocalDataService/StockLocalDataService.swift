//
//  StockLocalDataService.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/21/25.
//

import Foundation

/// This service implementation caches data via NSCache and  allows fast thread safe access to data, ideal for storing data ruing app run if no persistency is needed
final class StockLocalDataService: StockLocalDataServiceProtocol {
    private let cache = NSCache<NSString, DataWrapper<[StockDataEntry]>>()
    private let cacheKey = "historic_stock_data"

    func getCachedData() -> [StockDataEntry]? {
        return cache.object(forKey: cacheKey as NSString)?.value
    }

    func setCache(_ data: [StockDataEntry]) {
        cache.setObject(DataWrapper(data), forKey: cacheKey as NSString)
    }
}

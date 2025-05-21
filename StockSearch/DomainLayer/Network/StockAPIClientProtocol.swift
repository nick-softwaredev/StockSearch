//
//  StockAPIClientProtocol.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

import Foundation

protocol StockAPIClientProtocol {
    func fetch<T: Decodable>(_ type: T.Type, from endpoint: StockAPIEndpoint,  timeoutInterval: TimeInterval) async throws -> T
}

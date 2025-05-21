//
//  APIEndpointConfiguration.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

import Foundation

protocol EndpointConfigurationProtocol {
    var scheme: String { get }
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var queryItems: [URLQueryItem]? { get }
    // extendable further for body parameters ...

    func asURLRequest(timeoutInterval: TimeInterval) throws -> URLRequest
}

enum HTTPMethod: String {
    case get
}

enum EndpointError: Error {
    case invalidURL
}

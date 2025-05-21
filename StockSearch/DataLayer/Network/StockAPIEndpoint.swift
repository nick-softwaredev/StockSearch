//
//  StockAPIEndpoint.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

import Foundation

enum StockAPIEndpoint: EndpointConfigurationProtocol, Hashable {
    // no actual search query passed because urls
    case current(String)
    case historical(String)

    var baseURL: String {
        return "gist.githubusercontent.com"
    }
    

    var scheme: String {
        switch self {
        default:
            return "https"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .historical:
            return .get
        case .current:
            return .get
        }
    }

    var path: String {
        switch self {
        case .current:
            return "/rockarts/07e1f458e79ba521a7e62aec6b231479/raw/75484217fab58cd86876ae0bc910bc61020978f5/current.json"
        case .historical:
            return "/rockarts/07e1f458e79ba521a7e62aec6b231479/raw/75484217fab58cd86876ae0bc910bc61020978f5/historical.json"
        }
    }

    var queryItems: [URLQueryItem]? {
        return .none // because no actual backend server API provided but rather static data, this is unimplemented
    }

    func asURLRequest(timeoutInterval: TimeInterval) throws -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = baseURL
        urlComponents.path = path

        guard let url = urlComponents.url else {
            throw EndpointError.invalidURL
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = timeoutInterval
        return urlRequest
    }
}

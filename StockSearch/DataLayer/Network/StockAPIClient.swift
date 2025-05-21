//
//  StockAPIClient.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

import Foundation

final class StockAPIClient: StockAPIClientProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetch<T: Decodable>(_ type: T.Type, from endpoint: StockAPIEndpoint, timeoutInterval: TimeInterval) async throws -> T {
        let request = try endpoint.asURLRequest(timeoutInterval: timeoutInterval)

        let (data, response) = try await session.data(for: request)

        guard
            let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode
        else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}

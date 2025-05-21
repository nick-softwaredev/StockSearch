//
//  StockSearchViewListOverlay.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

import SwiftUI

struct StockSearchViewListOverlay: View {
    enum Messasge {
        case custom(String)
        case error(description: String, suggestion: String)
    }
    let message: Messasge
    
    var body: some View {
        VStack {
            switch message {
            case .custom(let text):
                Text(text)
            case .error(let description, let suggestion):
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.orange)
                    
                    Text(description)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)
                    
                    Text(suggestion)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                        .padding()
                }
            }
        }
    }
}

#Preview {
    StockSearchViewListOverlay(message: .custom("Some Message"))
}

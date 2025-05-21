//
//  DataWrapper.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/21/25.
//

import Foundation

final class DataWrapper<T>: NSObject {
    let value: T
    init(_ value: T) {
        self.value = value
    }
}

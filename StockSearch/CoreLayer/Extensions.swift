//
//  Extensions.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/21/25.
//

import Foundation

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let factor = pow(10.0, Double(places))
        return (self * factor).rounded() / factor
    }
}

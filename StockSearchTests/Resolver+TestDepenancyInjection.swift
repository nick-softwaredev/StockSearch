//
//  Resolver+TestDepenancyInjection.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

import Resolver
@testable import StockSearch

extension Resolver {
    static var test = Resolver(child: .main)
}

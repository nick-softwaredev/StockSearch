//
//  NetworkMonitor.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

import Network
import Combine

protocol NetworkMonitoringProtocol: AnyObject {
    var isConnected: Bool { get }
    func startMonitoring()
    func stopMonitoring()
}

final class MockNetworkMonitorConnected: NetworkMonitoringProtocol {
    var isConnected: Bool { return true }
    private(set) var isMonitoring: Bool = false
    func startMonitoring() {
        isMonitoring = true
    }
    func stopMonitoring() {
        isMonitoring = false
    }
}

final class NetworkMonitor: NetworkMonitoringProtocol {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    private(set) var isConnected: Bool = true

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}

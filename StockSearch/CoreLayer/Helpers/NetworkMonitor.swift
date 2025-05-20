//
//  NetworkMonitor.swift
//  StockSearch
//
//  Created by Nick Nick  on 5/20/25.
//

import Network
import Combine

protocol NetworkMonitoring: AnyObject {
    var connectionStatusSubject: AnyPublisher<Bool, Never> { get }
    var isConnected: Bool { get }
    func startMonitoring()
    func stopMonitoring()
}

final class NetworkMonitor: NetworkMonitoring {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")
    private(set) var isConnected: Bool = true
    private let connectionStatusPublisher = PassthroughSubject<Bool, Never>()
    var connectionStatusSubject: AnyPublisher<Bool, Never> {
        connectionStatusPublisher.eraseToAnyPublisher()
    }

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            self?.connectionStatusPublisher.send(path.status == .satisfied)
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}

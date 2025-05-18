//
//  NetworkMonitor.swift
//  Sports App
//
//  Created by Kerolos on 18/05/2025.
//

import Foundation
import Network

class NetworkMonitor{
    static let shared = NetworkMonitor()
    
    private let monitor : NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    var isConnected:Bool = true
    
    private init() {
        monitor = NWPathMonitor()
        startMonitoring()
    }
    
    func startMonitoring() {
         monitor.start(queue: queue)
         monitor.pathUpdateHandler = { [weak self] path in
             let newConnectionValue = path.status == .satisfied
             self?.isConnected = newConnectionValue
             
             // Post notification only on state change
             if self?.isConnected != newConnectionValue {
                 DispatchQueue.main.async {
                     NotificationCenter.default.post(
                         name: .connectivityStatusChanged,
                         object: nil
                     )
                 }
             }
         }
     }
     
     func stopMonitoring() {
         monitor.cancel()
     }
 }

 extension Notification.Name {
     static let connectivityStatusChanged = Notification.Name("connectivityStatusChanged")
 }

//
//  AppState.swift
//  imagin
//
//  Created by Nicholas Terrell on 20/4/2025.
//

import Foundation
import SwiftUI

class AppState: ObservableObject {
    // The gRPC client instance
    let grpcClient: ImaginGrpcClient

    init(host: String, port: Int = 443, useTLS: Bool = true) {
        self.grpcClient = ImaginGrpcClient(host: host, port: port, useTLS: useTLS)
    }
}

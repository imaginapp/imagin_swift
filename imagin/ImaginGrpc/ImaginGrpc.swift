//
//  ImaginGrpc.swift
//  imagin
//
//  Created by Nicholas Terrell on 20/4/2025.
//

import Foundation
import GRPC
import ImaginProto
import Logging
import NIO
import NIOHPACK

/// Client for communicating with the YourService gRPC service
class ImaginGrpcClient {
    let client: Imagin_External_Service_V1_ImaginServiceNIOClient
    let channel: ClientConnection
    let logger: Logger

    init(host: String, port: Int = 443, useTLS: Bool = true) {
        self.logger = Logger(label: "app.imagin.grpc")
        logger.info("Initializing gRPC client", metadata: ["host": "\(host)", "port": "\(port)", "tls": "\(useTLS)"])

        let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        let target = ConnectionTarget.hostAndPort(host, port)

        var config = ClientConnection.Configuration.default(
            target: target,
            eventLoopGroup: group,
        )

        if useTLS {
            config.tlsConfiguration = .makeClientConfigurationBackedByNIOSSL(
                certificateChain: [],
                privateKey: nil,
                trustRoots: .default,
                hostnameOverride: nil
            )
        }

        config.connectionBackoff = ConnectionBackoff()
        config.connectionKeepalive = ClientConnectionKeepalive(
            interval: .seconds(30),
            timeout: .seconds(10)
        )

        var backgroundLogger = Logger(label: "app.imagin.grpc.activity")
        backgroundLogger.logLevel = .info
        config.backgroundActivityLogger = backgroundLogger

        self.channel = ClientConnection(configuration: config)

        self.client = Imagin_External_Service_V1_ImaginServiceNIOClient(channel: channel)
        
        logger.info("Current connectivity",metadata: ["state": "\(channel.connectivity.state)"])
    }

    func close() {
        logger.info("Closing gRPC connection")
        try? channel.close().wait()
    }

    deinit {
        close()
    }

    func checkConnectivity() -> ConnectivityState {
        let state = channel.connectivity.state
        logger.info("Current connectivity",metadata: ["state": "\(state)"])
        return state
    }

    func isConnected() -> Bool {
        let state = checkConnectivity()
        return state == .ready || state == .idle
    }

    func execute<Request, Response>(
        _ rpcCall: (Request, CallOptions) -> UnaryCall<Request, Response>,
        request: Request,
        methodName: String,
        timeout: TimeAmount = .seconds(10)
    ) async throws -> Response {
        var logger = logger
        logger[metadataKey: "methodName"] = "\(methodName)"
        logger.info("Sending request")

        // Check connection
        if !isConnected() {
            logger.error("Attempted to send request while not connected")
            throw ImaginClientError.notConnected
        }

        // Check if API key exists
        let apiKey = Bundle.main.infoDictionary?["DevinApiKey"] as? String ?? ""
        if apiKey.isEmpty {
            logger.error("API key is missing")
            throw ImaginClientError.apiKeyMissing
        }

        // Add timeout to call options
        var options = CallOptions()
        // add gzip
        options.messageEncoding = .enabled(
            ClientMessageEncoding.Configuration(
                forRequests: .gzip,
                acceptableForResponses: CompressionAlgorithm.all,
                decompressionLimit: .ratio(20)
            ))
        // set timeout
        options.timeLimit = .timeout(timeout)
        // add apiKey to metadata
        options.customMetadata.add(contentsOf: [("x-api-key", apiKey)])

        do {
            let call = rpcCall(request, options)

            // Set up task with timeout handling
            let response = try await withTaskCancellationHandler {
                try await call.response.get()
            } onCancel: {
                self.logger.warning("Request was cancelled")
                call.cancel(promise: nil)
            }

            logger.info("Request successful")
            return response
        } catch let error as GRPCStatus {
            // Handle specific gRPC status errors
            logger.error("Request failed with error", metadata: ["error": "\(error)"])
            throw ImaginClientError.serverError(status: error)
        } catch let error as GRPCConnectionPoolError {
            // Handle connection pool errors
            logger.error("Connection pool error", metadata: ["error": "\(error)"])
            throw ImaginClientError.networkError(underlyingError: error)
        } catch let error as DecodingError {
            // Handle response decoding errors
            logger.error("Decoding error", metadata: ["error": "\(error)"])
            throw ImaginClientError.decodingError(underlyingError: error)
        } catch is CancellationError {
            // Handle cancellation
            logger.warning("Request was cancelled")
            throw ImaginClientError.cancelled
        } catch {
            // Handle other errors
            if error.localizedDescription.contains("timed out") {
                logger.error("Request timed out")
                throw ImaginClientError.connectionTimeout
            }

            logger.error("Request failed with unhandled error", metadata: ["error": "\(error)"])
            throw ImaginClientError.networkError(underlyingError: error)
        }
    }
}

//
//  ImaginGrpcErrors.swift
//  imagin
//
//  Created by Nicholas Terrell on 21/4/2025.
//

import Foundation
import GRPC

extension ImaginGrpcClient {
    enum ImaginClientError: Error, LocalizedError {
        case notConnected
        case connectionTimeout
        case apiKeyMissing
        case serverError(status: GRPCStatus)
        case networkError(underlyingError: Error)
        case decodingError(underlyingError: Error)
        case cancelled
        
        var errorDescription: String? {
            switch self {
            case .notConnected:
                return "Not connected to Imagin service. Please check your internet connection."
            case .connectionTimeout:
                return "Connection to Imagin service timed out. Please try again."
            case .apiKeyMissing:
                return "API key is missing. Please check your app configuration."
            case .serverError(let status):
                return "Server error: \(status.message ?? "Unknown") (Code: \(status.code.rawValue))"
            case .networkError(let error):
                return "Network error: \(error.localizedDescription)"
            case .decodingError(let error):
                return "Failed to process response: \(error.localizedDescription)"
            case .cancelled:
                return "Request was cancelled"
            }
        }
        
        var recoverySuggestion: String? {
            switch self {
            case .notConnected:
                return "Check your internet connection and try again."
            case .connectionTimeout:
                return "The server might be experiencing high load. Try again later."
            case .apiKeyMissing:
                return "Ensure your API key is properly configured in the app bundle."
            case .serverError(let status):
                switch status.code {
                case .unavailable:
                    return "The service is currently unavailable. Please try again later."
                case .resourceExhausted:
                    return "You've exceeded the rate limit. Please wait and try again."
                case .unauthenticated:
                    return "Your API key might be invalid. Check your credentials."
                default:
                    return "Please try again later or contact support if the issue persists."
                }
            case .networkError:
                return "Check your internet connection or try again later."
            case .decodingError:
                return "There may be a version mismatch. Update your app or contact support."
            case .cancelled:
                return "You can try again when ready."
            }
        }
    }
    
    func extractUserFriendlyError(from error: Error) -> String {
        if let imaginError = error as? ImaginClientError {
            let message = imaginError.errorDescription ?? "Unknown error"
            if let suggestion = imaginError.recoverySuggestion {
                return "\(message). \(suggestion)"
            }
            return message
        } else if let grpcStatus = error as? GRPCStatus {
            return "Server error: \(grpcStatus.message ?? "Unknown server error") (Code: \(grpcStatus.code.rawValue))"
        } else {
            return error.localizedDescription
        }
    }
    
}

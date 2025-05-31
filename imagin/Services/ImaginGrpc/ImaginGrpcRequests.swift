//
//  ImaginGrpcRequests.swift
//  imagin
//
//  Created by Nicholas Terrell on 21/4/2025.
//
import Foundation
import GRPC
import ImaginProto
import Logging

extension ImaginGrpcClient {
    func version() async throws -> Imagin_External_Service_V1_GetVersionResponse {
        return try await execute(
            client.getVersion,
            request: Imagin_External_Service_V1_GetVersionRequest(),
            methodName: "getVersion"
        )
    }
    
    func validateInviteCode(_ code: String) async throws -> Imagin_External_Service_V1_ValidateInviteCodeResponse {
        return try await execute(
            client.validateInviteCode,
            request: {
                var req = Imagin_External_Service_V1_ValidateInviteCodeRequest()
                req.code = code
                return req
            }(),
            methodName: "validateInviteCode"
        )
    }
    
}

//
//  VaporRedisClient.swift
//  VaporRedisClient
//
//  Created by Valerio Mazzeo on 21/03/2017.
//  Copyright © 2017 VMLabs Limited. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Lesser General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU Lesser General Public License for more details.
//
//  You should have received a copy of the GNU Lesser General Public License
//  along with this program. If not, see <http://www.gnu.org/licenses/>.
//

import Foundation
import Sockets
import Redis
import RedisClient

public class VaporRedisClient {

    // MARK: Initialization

    public required init(_ client: TCPClient) {
        self.client = client
    }

    // MARK: Setting and Getting Attributes

    public let client: TCPClient
}

extension VaporRedisClient: RedisClient {

    public func execute(_ command: String, arguments: [String]?) throws -> RedisClientResponse {

        let response = try self.client.command(Command(command), arguments ?? [])

        return RedisClientResponse(response: response)
    }
}

extension RedisClientResponse {

    init(response: Redis.Data?) {

        switch response {

        case .none:
            self = .null

        case .some(.string(let value)):
            guard let status = Status(rawValue: value) else {
                self = .error("Unknown status: \(value)")
                return
            }

            self = .status(status)

        case .some(.error(let error)):
            self = .error(error.localizedDescription)

        case .some(.integer(let value)):
            self = .integer(Int64(value))

        case .some(.bulk(let bytes)):
            self = .string(bytes.makeString())

        case .some(.array(let responses)):
            self = .array(responses.map { RedisClientResponse(response: $0) })

        }
    }
}

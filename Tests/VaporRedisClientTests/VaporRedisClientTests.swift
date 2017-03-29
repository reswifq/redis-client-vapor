//
//  VaporRedisClientTests.swift
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

import XCTest
import Sockets
import Foundation
import Redis
import RedisClient
@testable import VaporRedisClient

class VaporRedisClientTests: XCTestCase {

    static let allTests = [
        ("testExecute", testExecute),
        ("testInitWithResponseArray", testInitWithResponseArray),
        ("testInitWithResponseError", testInitWithResponseError),
        ("testInitWithResponseIntegerValue", testInitWithResponseIntegerValue),
        ("testInitWithResponseNil", testInitWithResponseNil),
        ("testInitWithResponseStatus", testInitWithResponseStatus),
        ("testInitWithResponseStatusUnknown", testInitWithResponseStatusUnknown),
        ("testInitWithResponseString", testInitWithResponseString)
    ]

    func testExecute() throws {

        // Attention: Using localhost seems to cause some kind of delay on the socket connection
        let client = VaporRedisClient(try TCPClient(hostname: "127.0.0.1", port: 6379))

        let flushResponse = try client.execute("FLUSHALL", arguments: nil)
        XCTAssertEqual(flushResponse.status, .ok)

        let setResponse = try client.execute("SET", arguments: "test", "1234")
        XCTAssertEqual(setResponse.status, .ok)

        let getResponse = try client.execute("GET", arguments: "test")
        XCTAssertEqual(getResponse.string, "1234")
    }

    func testInitWithResponseArray() {

        let vaporResponse = Redis.Data.array([.string("OK"), .string("QUEUED")])
        let response = RedisClientResponse(response: vaporResponse)

        XCTAssertEqual(response.array?[0].status, .ok)
        XCTAssertEqual(response.array?[1].status, .queued)
    }

    func testInitWithResponseError() {

        let vaporResponse = Redis.Data.error(RedisClientError.enqueueCommandError)
        let response = RedisClientResponse(response: vaporResponse)

        XCTAssertNotNil(response.error)
    }

    func testInitWithResponseIntegerValue() {

        let vaporResponse = Redis.Data.integer(1)
        let response = RedisClientResponse(response: vaporResponse)

        XCTAssertEqual(response.integer, 1)
    }

    func testInitWithResponseNil() {

        let response = RedisClientResponse(response: nil)

        XCTAssertTrue(response.isNull)
    }

    func testInitWithResponseStatus() {

        let vaporResponse = Redis.Data.string("OK")
        let response = RedisClientResponse(response: vaporResponse)

        XCTAssertEqual(response.status, .ok)
    }

    func testInitWithResponseStatusUnknown() {

        let vaporResponse = Redis.Data.string("ERR")
        let response = RedisClientResponse(response: vaporResponse)

        XCTAssertEqual(response.error, "Unknown status: ERR")
    }

    func testInitWithResponseString() {

        let vaporResponse = Redis.Data.bulk("test".makeBytes())
        let response = RedisClientResponse(response: vaporResponse)
        
        XCTAssertEqual(response.string, "test")
    }
}

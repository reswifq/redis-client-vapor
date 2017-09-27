// swift-tools-version:4.0

//
//  Package.swift
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

import PackageDescription

let package = Package(
	name: "VaporRedisClient",
	products: [
		.library(name: "VaporRedisClient", targets: ["VaporRedisClient"])
	],
	dependencies: [
		.package(url: "https://github.com/reswifq/redis-client.git", .upToNextMajor(from: "1.2.0")),
		.package(url: "https://github.com/vapor/redis.git", .upToNextMajor(from: "2.0.0"))
	],
	targets: [
		.target(name: "VaporRedisClient", dependencies: ["RedisClient", "Redis"]),
		.testTarget(name: "VaporRedisClientTests", dependencies: ["VaporRedisClient"])
	]
)

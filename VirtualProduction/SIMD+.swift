//
//  SIMD+.swift
//  VirtualProduction
//
//  Created by blueken on 2025/07/29.
//

import simd

extension simd_float4 {
    var xyz: SIMD3<Float> {
        return SIMD3<Float>(x, y, z)
    }
}

extension simd_float4x4 {
    var position: SIMD3<Float> {
        return columns.3.xyz
    }
}

extension simd_float4x4: Codable {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var columns: [simd_float4] = []
        for _ in 0..<4 {
            let column = try container.decode(simd_float4.self)
            columns.append(column)
        }
        self.init(columns: (columns[0], columns[1], columns[2], columns[3]))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(columns.0)
        try container.encode(columns.1)
        try container.encode(columns.2)
        try container.encode(columns.3)
    }
}

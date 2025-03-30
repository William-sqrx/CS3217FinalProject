//
//  PhysicsBitMask.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 17/3/25.
//

struct PhysicsBitMask {
    static let playerEntity: UInt32 = 0b1 << 0
    static let enemyEntity: UInt32 = 0b1 << 10
    private var bitMask: UInt32

    struct Task {
        static let task: UInt32 = 0b1 << 31
    }

    init(bitMask: UInt32) {
        self.bitMask = bitMask
    }

    func getBitMask() -> UInt32 {
        bitMask
    }
    mutating func setBitMask(_ bitMask: UInt32) {
        self.bitMask = bitMask
    }
}

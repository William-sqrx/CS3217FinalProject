//
//  PhysicsBitMask.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 17/3/25.
//

struct PhysicsBitMask {
    static let none: UInt32 = 0
    static let all = UInt32.max

    static let playerEntity: UInt32 = 0b1 << 0
    static let enemyEntity: UInt32 = 0b1 << 10
    static let task: UInt32 = 0b1 << 31

    var bitMask: UInt32

    init(_ bitMask: UInt32) {
        self.bitMask = bitMask
    }

    func getBitMask() -> UInt32 {
        bitMask
    }
    mutating func setBitMask(_ bitMask: UInt32) {
        self.bitMask = bitMask
    }
}

extension PhysicsBitMask: Equatable {
}

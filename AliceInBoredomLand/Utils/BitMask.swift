//
//  BitMask.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 17/3/25.
//

struct BitMask {
    struct Hero {
        static let tanker: UInt32 = 0x1 << 0
        static let swordsman: UInt32 = 0x1 << 1
        static let archer: UInt32 = 0x1 << 2
    }

    struct Monster {
        static let titan: UInt32 = 0x1 << 3
        static let minion: UInt32 = 0x1 << 4
        static let mage: UInt32 = 0x1 << 5
    }

    struct Castle {
        static let playerCastle: UInt32 = 0x1 << 6
        static let enemyCastle: UInt32 = 0x1 << 7
    }
}

//
//  HP.swift
//  AliceInBoredomLand
//
//  Created by daniel on 21/3/25.
//

import Foundation

protocol HP {
    var hp: Int { get set }
    var maxHP: Int { get set }

    mutating func increaseHP(_ amount: Int)
    mutating func decreaseHP(_ amount: Int)
}

extension HP {
    mutating func increaseHP(_ amount: Int) {
        assert(amount >= 0)
        hp = min(maxHP, hp + amount)
    }

    mutating func decreaseHP(_ amount: Int) {
        print(hp)
        assert(amount >= 0)
        hp = max(0, hp - amount)
    }
}

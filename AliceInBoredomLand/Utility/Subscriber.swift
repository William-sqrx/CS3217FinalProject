//
//  Subscriber.swift
//  AliceInBoredomLand
//
//  Created by daniel on 21/3/25.
//

// Equatable might not work out very well, maybe remove?
protocol Subscriber<V>: Equatable {
    associatedtype V
    func update(_ value: V)
}

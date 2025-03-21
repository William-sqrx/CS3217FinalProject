//
//  Publisher.swift
//  AliceInBoredomLand
//
//  Created by daniel on 21/3/25.
//

import Foundation

protocol Publisher<V> {
    associatedtype V
    func subscribe(_ subscriber: any Subscriber<V>)
    // Can't implement this for now
    // func unsubscribe(_ subscriber: any Subscriber<V>)
    func notifySubscribers()
}

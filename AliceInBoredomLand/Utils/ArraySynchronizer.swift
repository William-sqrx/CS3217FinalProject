//
//  ArraySynchronizer.swift
//  AliceInBoredomLand
//
//  Created by daniel on 1/4/25.
//

import Foundation

struct ArraySynchronizer<T: Equatable, U> {
    typealias Inner = T
    typealias Outer = U

    private var innerArray: [Inner] = []
    private var outerArray: [Outer] = []

    mutating func add(innerElement: Inner, outerElement: Outer) {
        assert(checkRepresentation())
        innerArray.append(innerElement)
        outerArray.append(outerElement)
        assert(checkRepresentation())
    }

    func getInnerElement(outerElement: Outer) -> Inner? where U: Equatable {
        for idx in outerArray.indices where outerArray[idx] == outerElement {
            return innerArray[idx]
        }
        return nil
    }
    func getOuterElement(innerElement: Inner) -> Outer? where T: Equatable {
        for idx in innerArray.indices where innerArray[idx] == innerElement {
            return outerArray[idx]
        }
        return nil
    }

    func getInnerArray() -> [Inner] {
        innerArray
    }
    func getOuterArray() -> [Outer] {
        outerArray
    }
    func getPairedArray() -> [(Inner, Outer)] {
        var result: [(Inner, Outer)] = []
        for idx in innerArray.indices {
            result.append((innerArray[idx], outerArray[idx]))
        }
        return result
    }

    mutating func removeInnerElement(_ innerElement: Inner) where T: Equatable {
        assert(checkRepresentation())
        for idx in innerArray.indices where innerArray[idx] == innerElement {
            innerArray.remove(at: idx)
            outerArray.remove(at: idx)
            break
        }
        assert(checkRepresentation())
    }
    mutating func removeOuterElement(_ outerElement: Outer) where U: Equatable {
        assert(checkRepresentation())
        for idx in outerArray.indices where outerArray[idx] == outerElement {
            innerArray.remove(at: idx)
            outerArray.remove(at: idx)
            break
        }
        assert(checkRepresentation())
    }
    mutating func removeElementPair(innerElement: Inner, outerElement: Outer)
    where T: Equatable, U: Equatable {
        assert(checkRepresentation())
        for idx in outerArray.indices where outerArray[idx] == outerElement {
            if innerArray[idx] == innerElement {
                innerArray.remove(at: idx)
                outerArray.remove(at: idx)
                break
            }
        }
        assert(checkRepresentation())
    }

    mutating func clearAll() {
        assert(checkRepresentation())
        innerArray.removeAll()
        outerArray.removeAll()
        assert(checkRepresentation())
    }

    init(innerArray: [Inner], outerArray: [Outer]) {
        self.innerArray = innerArray
        self.outerArray = outerArray
        assert(checkRepresentation())
    }

    init() {
        innerArray = []
        outerArray = []
        assert(checkRepresentation())
    }

    private func checkRepresentation() -> Bool {
        outerArray.count == innerArray.count
    }
}

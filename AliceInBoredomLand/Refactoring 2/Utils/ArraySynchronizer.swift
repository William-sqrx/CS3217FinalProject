//
//  ArraySynchronizer.swift
//  AliceInBoredomLand
//
//  Created by daniel on 1/4/25.
//

import Foundation

struct ArraySynchronizer<T: Equatable, U: Equatable> {
    typealias Inner = T
    typealias Outer = U

    private var outerArray: [Outer] = []
    private var innerArray: [Inner] = []

    mutating func add(innerElement: Inner, outerElement: Outer) {
        assert(checkRepresentation())
        innerArray.append(innerElement)
        outerArray.append(outerElement)
        assert(checkRepresentation())
    }

    func getInnerElement(outerElement: Outer) -> Inner? {
        for idx in outerArray.indices {
            if outerArray[idx] == outerElement {
                return innerArray[idx]
            }
        }
        return nil
    }
    func getOuterElement(innerElement: Inner) -> Outer? {
        for idx in innerArray.indices {
            if innerArray[idx] == innerElement {
                return outerArray[idx]
            }
        }
        return nil
    }

    func getInnerArray() -> [Inner] {
        return innerArray
    }
    func getOuterArray() -> [Outer] {
        return outerArray
    }

    mutating func removeInnerElement(_ innerElement: Inner) {
        assert(checkRepresentation())
        for idx in innerArray.indices where innerArray[idx] == innerElement {
            innerArray.remove(at: idx)
            outerArray.remove(at: idx)
            break
        }
        assert(checkRepresentation())
    }
    mutating func removeOuterElement(_ outerElement: Outer) {
        assert(checkRepresentation())
        for idx in outerArray.indices where outerArray[idx] == outerElement {
            innerArray.remove(at: idx)
            outerArray.remove(at: idx)
            break
        }
        assert(checkRepresentation())
    }

    init(outerArray: [Outer], innerArray: [Inner]) {
        self.outerArray = outerArray
        self.innerArray = innerArray
        assert(checkRepresentation())
    }

    init() {
        outerArray = []
        innerArray = []
        assert(checkRepresentation())
    }

    private func checkRepresentation() -> Bool {
        return outerArray.count == innerArray.count
    }
}

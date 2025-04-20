//
//  HeroTypeEntry.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 18/4/25.
//

import Foundation

struct HeroTypeEntry: Identifiable {
    let type: (Hero & EntityCreatable & GridSpawnable).Type

    var id: String { type.typeName }
    var label: String { type.typeName.capitalized }
}

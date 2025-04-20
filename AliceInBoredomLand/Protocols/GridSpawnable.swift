//
//  GridSpawnable.swift
//  AliceInBoredomLand
//
//  Created by Wijaya William on 18/4/25.
//
import Foundation

protocol GridSpawnable {
    static func spawn(at tileX: Int, tileY: Int, grid: Grid) -> GameEntity
}

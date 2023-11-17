//
//  Piece.swift
//  PentominoSolver
//
//  Created by Will McGinty on 12/26/22.
//

import Foundation
import SwiftUI

public struct Piece: Hashable, CustomStringConvertible {
    
    // MARK: - Properties
    public let identifier: Character
    public let color: Color
    private(set) var contents: Matrix
    
    // MARK: - Interface
    public var rows: Int { return contents.rows }
    public var columns: Int { return contents.columns }
    public var size: Int { return contents.filter { $0  == 1 }.count }
    public var hasContentAtOrigin: Bool { return contents[0, 0] == 1 }
    
    public func hasContent(at coordinate: Coordinate) -> Bool {
        return contents[coordinate.row, coordinate.col] == 1
    }
    
    public func allCoordinates(fromTopLeft coordinate: Coordinate) -> [Coordinate] {
        return contents.indexed().filter { $0.element == 1 }.map {
            let row = $0.index / rows
            let col = $0.index % rows
            
            return .init(row: row + coordinate.row, col: col + coordinate.col)
        }
    }
    
    public func rotated(andShiftTowardOrigin shouldShift: Bool = true) -> Piece {
        var copy = self
        copy.rotate(andShiftTowardOrigin: shouldShift)
        
        return copy
    }
    
    public func flipped(andShiftTowardOrigin shouldShift: Bool = true) -> Piece {
        var copy = self
        copy.flip(andShiftTowardOrigin: shouldShift)
        
        return copy
    }
    
    public mutating func flip(andShiftTowardOrigin shouldShift: Bool = true) {
        contents.flip()
        
        if shouldShift {
            contents.shiftTowardOrigin()
        }
    }
    
    public mutating func rotate(andShiftTowardOrigin shouldShift: Bool = true) {
        contents.rotate()
        
        if shouldShift {
            contents.shiftTowardOrigin()
        }
    }
    
    public func variations() -> Set<Piece> {
        let flipped = flipped()
        return [self, self.rotated(), self.rotated().rotated(), self.rotated().rotated().rotated(),
                flipped, flipped.rotated(), flipped.rotated().rotated(), flipped.rotated().rotated().rotated()]
    }
    
    // MARK: - CustomStringConvertible
    public var description: String {
        return contents.description(withContentIdentifier: identifier, emptyIdentifier: "⬜")
    }
    
}

// MARK: - Large Game Pieces
public extension Piece {
    
    static let theL = Piece(identifier: "🔴", color: .red, contents: .init(contents: [
        [1, 1, 0, 0],
        [1, 0, 0, 0],
        [1, 0, 0, 0],
        [1, 0, 0, 0]
    ]))
    
    static let rightAngle = Piece(identifier: "🟠", color: .orange, contents: .init(contents: [
        [1, 1, 1],
        [1, 0, 0],
        [1, 0, 0]
    ]))
    
    static let theT = Piece(identifier: "🟡", color: .yellow, contents: .init(contents: [
        [1, 1, 1],
        [0, 1, 0],
        [0, 1, 0]
    ]))
    
    static let stairs = Piece(identifier: "🟢", color: .green, contents: .init(contents: [
        [1, 0, 0],
        [1, 1, 0],
        [0, 1, 1]
    ]))
    
    static let theU = Piece(identifier: "🔵", color: .blue, contents: .init(contents: [
        [1, 0, 0, 1],
        [1, 1, 1, 1],
        [0, 0, 0, 0],
        [0, 0, 0, 0]
    ]))
    
    static let plus = Piece(identifier: "🟣", color: .purple, contents: .init(contents: [
        [0, 1, 0],
        [1, 1, 1],
        [0, 1, 0]
    ]))
    
    static let theH = Piece(identifier: "🟤", color: .brown, contents: .init(contents: [
        [1, 0, 0],
        [1, 1, 1],
        [1, 0, 1]
    ]))
    
    static let figureEight = Piece(identifier: "🟥", color: .cyan, contents: .init(contents: [
        [1, 1, 0],
        [1, 1, 1],
        [0, 1, 1]
    ]))
    
    static let utah = Piece(identifier: "🟧", color: .mint, contents: .init(contents: [
        [1, 0, 0],
        [1, 1, 0],
        [1, 1, 0],
    ]))
    
    static let house = Piece(identifier: "🟨", color: .pink, contents: .init(contents: [
        [1, 0, 0],
        [1, 1, 1],
        [1, 1, 1],
    ]))
    
    static let factory = Piece(identifier: "🟩", color: .teal, contents: .init(contents: [
        [1, 0, 0, 0],
        [1, 0, 1, 1],
        [1, 1, 1, 1],
        [0, 0, 0, 0]
    ]))
}

// MARK: - Small Pieces
public extension Piece {
    static let smallCross = Piece(identifier: "🔵", color: .blue, contents: .init(contents: [[0, 1, 0],
                                                                                             [1, 1, 1],
                                                                                             [0, 1, 0]]))
    
    static let smallU = Piece(identifier: "🔴", color: .red, contents: .init(contents: [[1, 1, 0],
                                                                                        [1, 0, 0],
                                                                                        [1, 1, 0]]))
    
    static let line = Piece(identifier: "🟧", color: .orange, contents: .init(contents: [[1, 1, 1, 1, 1],
                                                                                         [0, 0, 0, 0, 0],
                                                                                         [0, 0, 0, 0, 0],
                                                                                         [0, 0, 0, 0, 0],
                                                                                         [0, 0, 0, 0, 0]]))
    
    static let smallStairs = Piece(identifier: "🟨", color: .yellow, contents: .init(contents: [[0, 1, 1],
                                                                                                [1, 1, 0],
                                                                                                [1, 0, 0]]))
    
    static let weird = Piece(identifier: "🟢", color: .green, contents: .init(contents: [[0, 1, 1],
                                                                                         [1, 1, 0],
                                                                                         [0, 1, 0]]))
    
    static let squarePlusOne = Piece(identifier: "🟩", color: .purple, contents: .init(contents: [[1, 1, 1],
                                                                                                  [1, 1, 0],
                                                                                                  [0, 0, 0]]))
    
    static let ell = Piece(identifier: "🟠", color: .pink, contents: .init(contents: [[0, 0, 1],
                                                                                      [0, 0, 1],
                                                                                      [1, 1, 1]]))
    
    static let snake = Piece(identifier: "🟡", color: .cyan, contents: .init(contents: [[0, 0, 1, 1],
                                                                                        [1, 1, 1, 0],
                                                                                        [0, 0, 0, 0],
                                                                                        [0, 0, 0, 0]]))
}

public extension Array<Piece> {
    static let smallGamePieces: [Piece] = [.smallCross, .smallU, .line, .smallStairs, .weird, .squarePlusOne, .ell, .snake]
    static let largeGamePieces: [Piece] = [.theL, .rightAngle, .theT, .stairs, .theU, .plus, .theH, .figureEight, .utah, .house, .factory]
}

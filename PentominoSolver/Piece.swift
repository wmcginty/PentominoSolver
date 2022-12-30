//
//  Piece.swift
//  PentominoSolver
//
//  Created by Will McGinty on 12/26/22.
//

import Foundation

struct Piece: Hashable, CaseIterable, CustomStringConvertible {

    // MARK: - Properties
    let identifier: Character
    private(set) var contents: Matrix

    // MARK: - Interface
    var rows: Int { return contents.rows }
    var columns: Int { return contents.columns }
    var size: Int { return contents.filter { $0  == 1 }.count }
    var hasContentAtOrigin: Bool { return contents[0, 0] == 1 }

    func allCoordinates(fromTopLeft coordinate: Coordinate) -> [Coordinate] {
        return contents.indexed().filter { $0.element == 1 }.map {
            let row = $0.index / rows
            let col = $0.index % rows

            return .init(row: row + coordinate.row, col: col + coordinate.col)
        }
    }

    func rotated(andShiftTowardOrigin shouldShift: Bool = true) -> Piece {
        var copy = self
        copy.rotate(andShiftTowardOrigin: shouldShift)

        return copy
    }

    func flipped(andShiftTowardOrigin shouldShift: Bool = true) -> Piece {
        var copy = self
        copy.flip(andShiftTowardOrigin: shouldShift)

        return copy
    }

    mutating func flip(andShiftTowardOrigin shouldShift: Bool = true) {
        contents.flip()

        if shouldShift {
            contents.shiftTowardOrigin()
        }
    }

    mutating func rotate(andShiftTowardOrigin shouldShift: Bool = true) {
        contents.rotate()

        if shouldShift {
            contents.shiftTowardOrigin()
        }
    }

    func variations() -> Set<Piece> {
        let flipped = flipped()
        return [self, self.rotated(), self.rotated().rotated(), self.rotated().rotated().rotated(),
                flipped, flipped.rotated(), flipped.rotated().rotated(), flipped.rotated().rotated().rotated()]
    }

    // MARK: - CustomStringConvertible
    var description: String {
        return contents.description(withContentIdentifier: identifier, emptyIdentifier: "⬜")
    }

    // MARK: - Preset
    static let allCases: [Piece] = [.theL, .rightAngle, .theT, .stairs, .theU, .plus, .theH, .figureEight, .utah, .house, .factory]
    static let theL = Piece(identifier: "🔴", contents: .init(contents: [
        [1, 1, 0, 0],
        [1, 0, 0, 0],
        [1, 0, 0, 0],
        [1, 0, 0, 0]
    ]))

    static let rightAngle = Piece(identifier: "🟠", contents: .init(contents: [
        [1, 1, 1],
        [1, 0, 0],
        [1, 0, 0]
    ]))

    static let theT = Piece(identifier: "🟡", contents: .init(contents: [
        [1, 1, 1],
        [0, 1, 0],
        [0, 1, 0]
    ]))

    static let stairs = Piece(identifier: "🟢", contents: .init(contents: [
        [1, 0, 0],
        [1, 1, 0],
        [0, 1, 1]
    ]))

    static let theU = Piece(identifier: "🔵", contents: .init(contents: [
        [1, 0, 0, 1],
        [1, 1, 1, 1],
        [0, 0, 0, 0],
        [0, 0, 0, 0]
    ]))

    static let plus = Piece(identifier: "🟣", contents: .init(contents: [
        [0, 1, 0],
        [1, 1, 1],
        [0, 1, 0]
    ]))

    static let theH = Piece(identifier: "🟤", contents: .init(contents: [
        [1, 0, 0],
        [1, 1, 1],
        [1, 0, 1]
    ]))

    static let figureEight = Piece(identifier: "🟥", contents: .init(contents: [
        [1, 1, 0],
        [1, 1, 1],
        [0, 1, 1]
    ]))

    static let utah = Piece(identifier: "🟧", contents: .init(contents: [
        [1, 0, 0],
        [1, 1, 0],
        [1, 1, 0],
    ]))

    static let house = Piece(identifier: "🟨", contents: .init(contents: [
        [1, 0, 0],
        [1, 1, 1],
        [1, 1, 1],
    ]))

    static let factory = Piece(identifier: "🟩", contents: .init(contents: [
        [1, 0, 0, 0],
        [1, 0, 1, 1],
        [1, 1, 1, 1],
        [0, 0, 0, 0]
    ]))
}

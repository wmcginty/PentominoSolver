//
//  Board.swift
//  PentominoSolver
//
//  Created by Will McGinty on 12/26/22.
//

import Foundation

extension [[Board.Element]] {

    var allCoordinates: Set<Coordinate> {
        var result: Set<Coordinate> = []
        for row in self.indices {
            for col in self[row].indices {
                result.insert(Coordinate(row: row, col: col))
            }
        }

        return result
    }
}

struct Board: Hashable, CustomStringConvertible {

    // MARK: - Board.Element
    enum Element: Hashable, CustomStringConvertible {
        case empty
        case piece(identifier: Character)

        var isFull: Bool {
            switch self {
            case .piece: return true
            default: return false
            }
        }

        // MARK: - CustomStringConvertible
        var description: String {
            switch self {
            case .empty: return "⬜"
            case .piece(let identifier): return String(identifier)
            }
        }
    }

    // MARK: - Properties
    private(set) var elements: [[Element]]
    let allCoordinates: Set<Coordinate>

    // MARK: - Initializer
    init(width: Int, height: Int) {
        self.elements = Array(repeating: Array(repeating: Element.empty, count: width), count: height)
        self.allCoordinates = elements.allCoordinates
    }

    // MARK: - Interface
    var emptyCoordinates: Set<Coordinate> {
        return allCoordinates.filter { element(at: $0) == .empty }
    }

    var hasIslandSquare: Bool {
        return emptyCoordinates.contains {
            let cardinalNeighbots = $0.neighbors(in: [.north, .east, .south, .west])
            return cardinalNeighbots.allSatisfy { !isValid(coordinate: $0) || element(at: $0).isFull }
        }
    }

    func isValid(coordinate: Coordinate) -> Bool {
        return coordinate.row >= 0 && coordinate.row < elements.count && coordinate.col >= 0 && coordinate.col < elements[0].count
    }

    func element(at coordinate: Coordinate) -> Element {
        return elements[coordinate.row][coordinate.col]
    }

    mutating func set(_ element: Element, at coordinate: Coordinate) {
        elements[coordinate.row][coordinate.col] = element
    }

    func possibleCoordinates(for piece: Piece) -> [Coordinate] {
        guard piece.hasContentAtOrigin else {
            return allCoordinates.filter {
                let pieceCoordinates = piece.allCoordinates(fromTopLeft: $0)
                return pieceCoordinates.allSatisfy(emptyCoordinates.contains(_:))
            }
        }

        return emptyCoordinates.filter {
            let pieceCoordinates = piece.allCoordinates(fromTopLeft: $0)
            return pieceCoordinates.allSatisfy(emptyCoordinates.contains(_:))
        }
    }

    mutating func place(piece: Piece, at coordinate: Coordinate) {
        let allCoordinates = piece.allCoordinates(fromTopLeft: coordinate)
        allCoordinates.forEach {
            set(.piece(identifier: piece.identifier), at: $0)
        }
    }

    // MARK: - CustomStringConvertible
    var description: String {
        var result = ""
        for row in elements.indices {
            for col in elements[row].indices {
                result += elements[row][col].description
            }

            result += "\n"
        }

        return result
    }
}

//
//  Board.swift
//  PentominoSolver
//
//  Created by Will McGinty on 12/26/22.
//

import Foundation
import SwiftUI

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

public struct Board: Hashable, CustomStringConvertible {

    // MARK: - Board.Element
    public enum Element: Hashable, CustomStringConvertible, View {
        case empty
        case piece(identifier: Character, color: Color)

        var isFull: Bool {
            switch self {
            case .piece: return true
            default: return false
            }
        }

        // MARK: - CustomStringConvertible
        public var description: String {
            switch self {
            case .empty: return "⬜"
            case .piece(let identifier, _): return String(identifier)
            }
        }

        public var body: some View {
                switch self {
                case .empty:
                    if #available(iOS 17.0, macOS 14.0, *) {
                        Rectangle()
                            .fill(.background.secondary)
                            .border(.black)
                    } else {
                        Color.gray
                            .border(.black)
                    }
                case .piece(_, let color):
                    color
                        .border(.black)
                }
        }
    }

    // MARK: - Properties
    private(set) var elements: [[Element]]
    let allCoordinates: Set<Coordinate>
    public let width: Int
    public let height: Int

    // MARK: - Initializer
    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
        self.elements = Array(repeating: Array(repeating: Element.empty, count: width), count: height)
        self.allCoordinates = elements.allCoordinates
    }

    // MARK: - Interface
    public var emptyCoordinates: Set<Coordinate> {
        return allCoordinates.filter { element(at: $0) == .empty }
    }

    public var hasIslandSquare: Bool {
        return emptyCoordinates.contains {
            let cardinalNeighbots = $0.neighbors(in: [.north, .east, .south, .west])
            return cardinalNeighbots.allSatisfy { !isValid(coordinate: $0) || element(at: $0).isFull }
        }
    }

    public func isValid(coordinate: Coordinate) -> Bool {
        return coordinate.row >= 0 && coordinate.row < elements.count && coordinate.col >= 0 && coordinate.col < elements[0].count
    }

    public func element(at coordinate: Coordinate) -> Element {
        return elements[coordinate.row][coordinate.col]
    }

    public mutating func set(_ element: Element, at coordinate: Coordinate) {
        elements[coordinate.row][coordinate.col] = element
    }

    public func possibleCoordinates(for piece: Piece) -> [Coordinate] {
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

    public mutating func place(piece: Piece, at coordinate: Coordinate) {
        let allCoordinates = piece.allCoordinates(fromTopLeft: coordinate)
        allCoordinates.forEach {
            set(.piece(identifier: piece.identifier, color: piece.color), at: $0)
        }
    }

    // MARK: - CustomStringConvertible
    public var description: String {
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

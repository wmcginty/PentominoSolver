//
//  main.swift
//  PentominoSolver
//
//  Created by Will McGinty on 12/25/22.
//

import Foundation
import Collections

struct State: Hashable {
    let board: Board
    //let remainingPieces: [Piece]
    let remainingPieceIndices: Range<Int>
}

func validSolution(placingPieces pieces: [Piece], in emptyBoard: Board) -> Board? {
    let start = State(board: emptyBoard, remainingPieceIndices: pieces.indices)
    var deque = Deque([start])
    var seen = Set<State>()

    var lastPiece: Int = 0
    while let status = deque.popLast() {
        if status.remainingPieceIndices.isEmpty {
            return status.board
        }

        if status.board.hasIslandSquare {
            continue
        }

        if seen.contains(status) {
            continue
        }
        seen.insert(status)

        if status.remainingPieceIndices.count <= 1 {
            lastPiece += 1
            print("Close: #\(lastPiece)")
            print(status.board)
            print("\nFinal Piece: ")
            print(pieces[status.remainingPieceIndices.first!])
        }

        var remainingPiecesIndices = status.remainingPieceIndices
        let nextPieceIndex = remainingPiecesIndices.removeFirst()
        let nextPiece = pieces[nextPieceIndex]
        let allVariations = nextPiece.variations()

        for piece in allVariations {
            let possibleCoordinates = status.board.possibleCoordinates(for: piece)
            for possibleCoordinate in possibleCoordinates.shuffled() {
                var updatedBoard = status.board
                updatedBoard.place(piece: piece, at: possibleCoordinate)
                deque.append(.init(board: updatedBoard, remainingPieceIndices: remainingPiecesIndices))
            }
        }
    }

    return nil
}

func solve(board: Board, with pieces: [Piece]) {
    let startDate = Date()
    guard let solved = validSolution(placingPieces: pieces, in: board) else {
        return print("No Solution Found :(")
    }

    let duration = startDate..<Date.now
    print("Solved after \(duration.formatted(.components(style: .abbreviated))):")
    print(solved)
}


//// Sanity Check Game
//print("Sanity Check Game...")
//let p1 = Piece(identifier: "🔴", contents: .init(contents: [[1, 1], [1, 1]]))
//let p2 = Piece(identifier: "🟠", contents: .init(contents: [[1, 1], [1, 1]]))
//let p3 = Piece(identifier: "🟡", contents: .init(contents: [[1, 1], [1, 1]]))
//let p4 = Piece(identifier: "🟢", contents: .init(contents: [[1, 1], [1, 1]]))
//solve(board: Board(width: 4, height: 4), with: [p1, p2, p3, p4])

// Small Game
print("Small Game...")
let smallCross = Piece(identifier: "🔵", contents: .init(contents: [[0, 1, 0],
                                                                    [1, 1, 1],
                                                                    [0, 1, 0]]))
let smallU = Piece(identifier: "🔴", contents: .init(contents: [[1, 1, 0],
                                                                [1, 0, 0],
                                                                [1, 1, 0]]))
let line = Piece(identifier: "🟧", contents: .init(contents: [[1, 1, 1, 1, 1],
                                                              [0, 0, 0, 0, 0],
                                                              [0, 0, 0, 0, 0],
                                                              [0, 0, 0, 0, 0],
                                                              [0, 0, 0, 0, 0]]))
let stairs = Piece(identifier: "🟨", contents: .init(contents: [[0, 1, 1],
                                                                [1, 1, 0],
                                                                [1, 0, 0]]))
let weird = Piece(identifier: "🟢", contents: .init(contents: [[0, 1, 1],
                                                               [1, 1, 0],
                                                               [0, 1, 0]]))
let squarePlusOne = Piece(identifier: "🟩", contents: .init(contents: [[1, 1, 1],
                                                                       [1, 1, 0],
                                                                       [0, 0, 0]]))
let ell = Piece(identifier: "🟠", contents: .init(contents: [[0, 0, 1],
                                                             [0, 0, 1],
                                                             [1, 1, 1]]))
let snake = Piece(identifier: "🟡", contents: .init(contents: [[0, 0, 1, 1],
                                                               [1, 1, 1, 0],
                                                               [0, 0, 0, 0],
                                                               [0, 0, 0, 0]]))

let smallGamePieces = [smallCross, smallU, line, stairs, weird, squarePlusOne, ell, snake]
solve(board: Board(width: 8, height: 5), with: smallGamePieces)

// Monster Game
print("Monster Game...")
let monsterGamePieces: [Piece] = [.stairs, .plus, .theH, .factory, .theL, .rightAngle, .theT, .theU, .figureEight, .utah, .house, ]
solve(board: Board(width: 8, height: 8), with: monsterGamePieces)

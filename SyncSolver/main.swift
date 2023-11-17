//
//  main.swift
//  SyncSolver
//
//  Created by Will McGinty on 11/17/23.
//

import Foundation
import Pentominos

func solve(board: Board, with pieces: [Piece]) {
    print("Solving \(board.width)x\(board.height) board with \(pieces.count) pieces.")
    print()

    let solver = Solver.Synchronous()
    solver.onCloseAttempt = { closeAttempt in
        print("Close Attempt #\(closeAttempt.count)")
        print(closeAttempt.board)
        print()
    }

    let start = Date.now
    let solution = solver.solve(board: board, with: pieces)
    let solved = Date.now

    guard let solution else {
        return print("No Solution Found")
    }

    let interval = start..<solved
    print("Solved (after \(interval.formatted(.components(style: .narrow)))):")
    print(solution)
    print()
}

solve(board: Board(width: 8, height: 5), with: .smallGamePieces)
solve(board: Board(width: 8, height: 8), with: .largeGamePieces)


//
//  main.swift
//  PentominoSolver
//
//  Created by Will McGinty on 12/25/22.
//

import Foundation
import Collections
import Pentominos

let solver = Solver()

// Small Game
print("Small Game...")
let solved = solver.solve(board: Board(width: 8, height: 5), with: .smallGamePieces)
print(solved)

// Monster Game
print("Monster Game...")
let solved2 = solver.solve(board: Board(width: 8, height: 8), with: .largeGamePieces)
print(solved2)

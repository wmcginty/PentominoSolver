//
//  Solver.swift
//
//
//  Created by Will McGinty on 7/20/23.
//

import Foundation
import Collections
import SwiftUI

@MainActor
public class Solver: ObservableObject {
    
    // MARK: - Solver.State
    public typealias CloseAttempt = Solver.Synchronous.CloseAttempt

    // MARK: - Properties
    @Published public var isSolving: Bool = false
    @Published public var startDate: Date?
    @Published public var solvedDate: Date?
    @Published public var solvedBoard: Board?
    @Published public var lastCloseAttempt: CloseAttempt?

    public var hasSolution: Bool { return solvedBoard != nil }

    // MARK: - Initializer
    public init() {}
    
    // MARK: - Interface
    public func solve(board: Board, with pieces: [Piece]) async {
        isSolving = true
        startDate = .now

        let solution = await solve(board: board, with: pieces) { closeAttempt in
            Task { @MainActor in
                self.lastCloseAttempt = closeAttempt
            }
        }

        solvedBoard = solution
        solvedDate = solvedBoard != nil ? .now : nil
        isSolving = false
    }

    public func reset() {
        isSolving = false
        startDate = nil
        solvedDate = nil
        solvedBoard = nil
        lastCloseAttempt = nil
    }
}

// MARK: - Helper
private extension Solver {

    func solve(board: Board, with pieces: [Piece], onCloseAttempt: @escaping (CloseAttempt) -> Void) async -> Board? {
        return await withCheckedContinuation { checkedContinuation in
            Task.detached(priority: .userInitiated) {
                let synchronousSolver = Synchronous()
                synchronousSolver.onCloseAttempt = onCloseAttempt

                let solution = synchronousSolver.solve(board: board, with: pieces)
                checkedContinuation.resume(returning: solution)
            }
        }
    }
}

// MARK: - Solver.Synchronous
public extension Solver {

    class Synchronous {

        public struct CloseAttempt {
            public let count: Int // The number of the close attempt
            public let board: Board
            public let finalPiece: Piece
        }

        private struct State: Hashable {
            let board: Board
            let remainingPieceIndices: Range<Int>
        }

        // MARK: - Properties
        public var onCloseAttempt: (CloseAttempt) -> Void = { _ in }

        // MARK: - Initializer
        public init() {}

        // MARK: - Interface
        public func solve(board: Board, with pieces: [Piece]) -> Board? {
            let start = State(board: board, remainingPieceIndices: pieces.indices)
            var deque = Deque([start])
            var seen = Set<State>()
            var closeAttemptCounter: Int = 0

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
                    closeAttemptCounter += 1
                    let closeAttempt = CloseAttempt(count: closeAttemptCounter,
                                                    board: status.board,
                                                    finalPiece: pieces[status.remainingPieceIndices.first!])
                    onCloseAttempt(closeAttempt)
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
    }
}

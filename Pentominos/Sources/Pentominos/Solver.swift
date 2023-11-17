//
//  File.swift
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
    private struct State: Hashable {
        let board: Board
        let remainingPieceIndices: Range<Int>
    }
    
    public struct CloseAttempt {
        public let count: Int // The number of the close attempt
        public let board: Board
        public let finalPiece: Piece
    }
    
    // MARK: - Properties
    @Published public var isSolving: Bool = false
    @Published public var startDate: Date?
    @Published public var solvedDate: Date?
    @Published public var solvedBoard: Board?
    @Published public var closeAttempts: [CloseAttempt] = []
    
    // MARK: - Initializer
    public init() {}
    
    // MARK: - Interface
    public func solve(board: Board, with pieces: [Piece]) async {
        startDate = .now
        isSolving = true
        
        let _solver = _Solver()
        _solver.onCloseAttempt = { closeAttempt in
            Task {
                await MainActor.run {
                    self.closeAttempts.append(closeAttempt)
                }
            }
        }
        
        solvedBoard = await _solver.solve(board: board, with: pieces)
        solvedDate = .now
        isSolving = false
    }
    
    public func reset() {
        isSolving = false
        startDate = nil
        solvedDate = nil
        solvedBoard = nil
        closeAttempts = []
    }
}

class _Solver: ObservableObject {
    
    // MARK: - Solver.State
    struct State: Hashable {
        let board: Board
        let remainingPieceIndices: Range<Int>
    }
    
    typealias CloseAttempt = Solver.CloseAttempt
    
    // MARK: - Properties
    var onCloseAttempt: (CloseAttempt) -> Void = { _ in }
    
    // MARK: - Initializer
    init() {}
    
    // MARK: - Interface
    func solve(board: Board, with pieces: [Piece]) async -> Board? {
        return await withCheckedContinuation { checkedContinuation in
            Task.detached(priority: .userInitiated) {
                let solved = self.solution(placingPieces: pieces, in: board)
                checkedContinuation.resume(returning: solved)
            }
        }
    }
}

// MARK: - Helper
private extension _Solver {
    
    func solution(placingPieces pieces: [Piece], in board: Board) -> Board? {
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

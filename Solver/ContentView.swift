//
//  ContentView.swift
//  Solver
//
//  Created by Will McGinty on 7/20/23.
//

import Pentominos
import SwiftUI

struct ContentView: View {

    private let boardWidth: Int = 8
    private let boardHeight: Int = 8

    @StateObject private var solver = Solver()
    @State private var pieces: [Piece] = .largeGamePieces

    private var board: Board { return .init(width: boardWidth, height: boardHeight) }

    var body: some View {
        VStack {
            boardProgress
            solveProgress

            ScrollView(.horizontal) {
                PiecesView(pieces: pieces)
            }
            .contentMargins(20, for: .scrollContent)
            .containerRelativeFrame(.vertical) { l,_ in l * 0.2 }
            .scrollIndicators(.hidden)

        }
        .toolbar {
            ToolbarItem {
                Button(action: { solver.reset() },
                       label: { Image(systemName: "arrow.circlepath") })
            }
        }
    }

    @ViewBuilder
    var boardProgress: some View {
        Group {
            if let solved = solver.solvedBoard {
                BoardView(board: solved)

            } else if let close = solver.lastCloseAttempt {
                BoardView(board: close.board)
                    .opacity(0.6)
                    .animation(.default, value: close.count)

            } else {
                BoardView(board: board)
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .padding()
    }

    @ViewBuilder
    var solveProgress: some View {
        Group {
            if let startDate = solver.startDate {
                if solver.isSolving {
                    // Solving...
                    Text(startDate, style: .timer)
                        .font(.largeTitle.monospaced())
                        .contentTransition(.numericText())
                        .transaction { $0.animation = .default }

                } else if let endDate = solver.solvedDate, solver.hasSolution {
                    // Solved!
                    let duration = startDate..<endDate
                    Text("Solved after \(duration.formatted(.components(style: .abbreviated)))")

                } else {
                    // No Solution
                    Text("No Solution Found")
                }

            } else {
                // Hasn't started!
                Button("Solve") {
                    Task { await solver.solve(board: board, with: pieces) }
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .font(.largeTitle)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContentView()
        }
    }
}

//
//  ContentView.swift
//  Solver
//
//  Created by Will McGinty on 7/20/23.
//

import Pentominos
import SwiftUI

struct ContentView: View {
    
    @StateObject private var solver = Solver()
    
    @State private var boardWidth: Double = 8
    @State private var boardHeight: Double = 8
    @State private var pieces: [Piece] = .smallGamePieces
    
    private var board: Board { return .init(width: Int(boardWidth),
                                            height: Int(boardHeight)) }
    
    var body: some View {
        HStack {
            VStack {
                VStack {
                    VStack(spacing: 0) {
                        LabeledContent("Width", value: boardWidth.formatted())
                        Slider(value: $boardWidth, in: 3.0...10, step: 1)
                    }
                    
                    VStack(spacing: 0) {
                        LabeledContent("Height", value: boardHeight.formatted())
                        Slider(value: $boardHeight, in: 3...10, step: 1)
                    }
                    
                    if let startDate = solver.startDate, let endDate = solver.solvedDate {
                        let duration = startDate..<endDate
                        Text("Solved after \(duration.formatted(.components(style: .abbreviated)))")
                            .font(.largeTitle)
                    } else if let startDate = solver.startDate {
                        Text(startDate, style: .timer)
                            .contentTransition(.numericText())
                            .font(.largeTitle)
                    } else {
                        Button("Solve") {
                            Task {
                                await solver.solve(board: board, with: pieces)
                            }
                        }
                        .font(.largeTitle)
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.background.secondary)
                }
                .padding()
                
                Spacer()
                
                HStack {
                    if let solved = solver.solvedBoard {
                        BoardView(board: solved)
                            .aspectRatio(1, contentMode: .fit)
                    } else if let close = solver.closeAttempts.last {
                        BoardView(board: close.board)
                            .opacity(0.6)
                            .aspectRatio(1, contentMode: .fit)
                            .animation(.default, value: close.count)
                        
                    } else {
                        BoardView(board: board)
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
                .padding()
                
                Spacer()
            }
            
            ScrollView {
                LazyVStack {
                    ForEach(pieces, id: \.self) { piece in
                        PieceView(piece: piece, width: 4, height: 4)
                    }
                }
                .padding()
                .background(.background.secondary)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .scrollIndicators(.hidden)
            .padding()
            .frame(width: 200)
        }
        .ignoresSafeArea(edges: .bottom)
        .toolbar(content: {
            ToolbarItem {
                Button(action: { solver.reset() },
                       label: { Image(systemName: "arrow.circlepath") })
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

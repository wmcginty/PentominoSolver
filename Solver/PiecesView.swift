//
//  PiecesView.swift
//  Solver
//
//  Created by Will McGinty on 11/17/23.
//

import Pentominos
import SwiftUI

struct PiecesView: View {

    let pieces: [Piece]

    var maxWidth: Int { return pieces.map(\.columns).max() ?? 0 }
    var maxHeight: Int { return pieces.map(\.rows).max() ?? 0 }

    var body: some View {
        LazyHStack {
            ForEach(pieces, id: \.self) { piece in
                PieceView(piece: piece, width: maxWidth, height: maxHeight)
            }
        }
        .padding()
        .background(.background.secondary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct PieceView: View {

    let piece: Piece
    let width: Int
    let height: Int

    func hasContent(for coordinate: Coordinate) -> Bool {
        return coordinate.row < piece.rows && coordinate.col < piece.columns ? piece.hasContent(at: coordinate) : false
    }

    var body: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(0..<width, id: \.self) { column in
                GridRow {
                    ForEach(0..<height, id: \.self) { row in
                        let coordinate = Coordinate(row: row, col: column)
                        let hasContent = hasContent(for: coordinate)

                        ZStack {
                            hasContent ? piece.color : Color.clear
                        }
                        .border(.black)
                    }
                }
                .aspectRatio(1, contentMode: .fit)
            }
        }
    }
}

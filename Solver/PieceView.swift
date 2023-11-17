//
//  PieceView.swift
//  Solver
//
//  Created by Will McGinty on 7/21/23.
//

import Foundation
import Pentominos
import SwiftUI

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

#Preview {
    PieceView(piece: .ell, width: 4, height: 4)
}

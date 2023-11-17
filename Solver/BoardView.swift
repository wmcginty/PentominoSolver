//
//  BoardView.swift
//  Solver
//
//  Created by Will McGinty on 7/20/23.
//

import Foundation
import Pentominos
import SwiftUI

struct BoardView: View {
    
    let board: Board
    
    var body: some View {
        Grid(horizontalSpacing: 0, verticalSpacing: 0) {
            ForEach(0..<board.height, id: \.self) { row in
                GridRow {
                    ForEach(0..<board.width, id: \.self) { column in
                        let coordinate = Coordinate(row: row, col: column)
                        let element = board.element(at: coordinate)
                        element
                    }
                }
                .aspectRatio(1, contentMode: .fit)
            }
        }
    }
}

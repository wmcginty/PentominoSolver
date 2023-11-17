//
//  Matrix.swift
//  PentominoSolver
//
//  Created by Will McGinty on 12/26/22.
//

import Foundation
import Algorithms

struct Matrix: Hashable, CustomStringConvertible {

    // MARK: - Properties
    let rows: Int
    let columns: Int
    private(set) var contents: [Int]

    // MARK: - Initializer
    public init(rows: Int, columns: Int) {
        self.init(contents: Array(repeating: .init(repeating: 0, count: columns), count: rows))
    }

    public init(contents: [[Int]]) {
        self.contents = contents.flatMap { $0 }
        self.rows = contents.count
        self.columns = contents[0].count
    }

    // MARK: - Interface
    public subscript(row: Int, column: Int) -> Int {
        get { return contents[(row * columns) + column] }
        set { contents[(row * columns) + column] = newValue }
    }

    func filter(_ predicate: (Int) throws -> Bool) rethrows -> [Int] {
        return try contents.filter(predicate)
    }


    func indexed() -> IndexedCollection<[Int]> {
        return contents.indexed()
    }

    func rotated() -> Matrix {
        var copy = self
        copy.rotate()

        return copy
    }

    // TODO: This seems horribly inefficent, but I guess we'll see
    mutating func shiftTowardOrigin() {
        let rowChunks = contents.chunks(ofCount: columns)

        // Vertically
        let leadingZeroRows = rowChunks.prefix(while: { array in array.allSatisfy { $0 == 0 } }).count
        contents.removeFirst(leadingZeroRows * columns)
        contents.append(contentsOf: Array(repeating: 0, count: leadingZeroRows * columns))

        // Horizontally
        let leadingZeroColumns = (0..<rowChunks.count).filter { offset in rowChunks.allSatisfy { $0[$0.index($0.startIndex, offsetBy: offset)] == 0 } }.count
        let modifiedRowChunks = rowChunks.map {
            var modifiable = Array($0)
            modifiable.removeSubrange(0..<leadingZeroColumns)
            modifiable.append(contentsOf: Array(repeating: 0, count: leadingZeroColumns))

            return modifiable
        }

        contents = Array(modifiedRowChunks.joined())
    }

    mutating func rotate() {
        let layers = (rows % 2 == 0) ? rows / 2 : (rows - 1) / 2  // rows/2 also works but I trust it less
        for layer in 0 ..< layers {
            let first = layer
            let last = rows - layer - 1

            for i in first..<last {
                let top = (first, i)
                let left = (last - (i - first), first)
                let bottom = (last, last - (i - first))
                let right = (i, last)

                let temp = self[top.0, top.1]

                self[top.0, top.1] = self[left.0, left.1]
                self[left.0, left.1] = self[bottom.0, bottom.1]
                self[bottom.0, bottom.1] = self[right.0, right.1]
                self[right.0, right.1] = temp
            }
        }
    }

    mutating func flip() {
        let rowChunks = contents
            .chunks(ofCount: columns)
            .map { $0.reversed() }
            .joined()

        contents = Array(rowChunks)
    }

    // MARK: - CustomStringConvertible
    func description(withContentIdentifier contentIdentifier: Character, emptyIdentifier: Character) -> String {
        var result = ""
        for index in contents.indices {
            let content = contents[index]
            result += String(content == 1 ? contentIdentifier : emptyIdentifier)

            if (index + 1) % columns == 0 {
                result += "\n"
            }
        }

        return result
    }

    var description: String {
        return description(withContentIdentifier: "1", emptyIdentifier: "0")
    }
}

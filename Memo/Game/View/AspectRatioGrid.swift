//
//  Grid.swift
//  Memo
//
//  Created by Maxim Ivanov on 09.05.2023.
//

import UIKit

struct AspectRatioGrid {

    var dimensions: (rowCount: Int, columnCount: Int) = (0, 0)

    var cellCount = 0 {
        didSet {
            recalculate()
        }
    }

    private var aspectRatio: CGFloat {
        didSet {
            recalculate()
        }
    }
    
    private var frame: CGRect {
        didSet {
            recalculate()
        }
    }
    
    private var cellSize: CGSize {
        return cellFrames.first?.size ?? CGSize.zero
    }
    
    private var cellFrames = [CGRect]()
    
    init(layout: CGFloat, frame: CGRect = CGRect.zero) {
        self.frame = frame
        self.aspectRatio = layout
        recalculate()
    }
    
    subscript(row: Int, column: Int) -> CGRect? {
        return self[row * dimensions.columnCount + column]
    }
    
    subscript(index: Int) -> CGRect? {
        return index < cellFrames.count ? cellFrames[index] : nil
    }
    
    private mutating func recalculate() {
            let cellSize = largestCellSizeThatFitsAspectRatio()
            if cellSize.area > 0 {
                dimensions.columnCount = Int(frame.size.width / cellSize.width)
                dimensions.rowCount =
                (cellCount + dimensions.columnCount - 1) / dimensions.columnCount
            } else {
                dimensions = (0, 0)
            }
            updateCellFrames(to: cellSize)
    }
    
    private mutating func updateCellFrames(to cellSize: CGSize) {
        cellFrames.removeAll()
        
        let boundingSize = CGSize(
            width: CGFloat(dimensions.columnCount) * cellSize.width,
            height: CGFloat(dimensions.rowCount) * cellSize.height
        )
        let offset = (
            dx: (frame.size.width - boundingSize.width) / 2,
            dy: (frame.size.height - boundingSize.height) / 2
        )
        var origin = frame.origin
        origin.x += offset.dx
        origin.y += offset.dy

        if cellCount > 0 {
            for _ in 0..<cellCount {
               cellFrames.append(CGRect(origin: origin, size: cellSize))
                origin.x += cellSize.width
                if round(origin.x) > round(frame.maxX - cellSize.width) {
                    origin.x = frame.origin.x + offset.dx
                    origin.y += cellSize.height
                }
            }
        }
    }
    
    private func largestCellSizeThatFitsAspectRatio() -> CGSize {
        var largestSoFar = CGSize.zero
        if cellCount > 0 && aspectRatio > 0 {
            for rowCount in 1...cellCount {
                largestSoFar = cellSizeAssuming(rowCount: rowCount, minimumAllowedSize: largestSoFar)
            }
            for columnCount in 1...cellCount {
                largestSoFar = cellSizeAssuming(columnCount: columnCount, minimumAllowedSize: largestSoFar)
            }
        }
        return largestSoFar
    }
    
    private func cellSizeAssuming(rowCount: Int? = nil, columnCount: Int? = nil, minimumAllowedSize: CGSize = CGSize.zero) -> CGSize {
        var size = CGSize.zero
        if let columnCount = columnCount {
            size.width = frame.size.width / CGFloat(columnCount)
            size.height = size.width / aspectRatio
        } else if let rowCount = rowCount {
            size.height = frame.size.height / CGFloat(rowCount)
            size.width = size.height * aspectRatio
        }
        if size.area > minimumAllowedSize.area {
            if Int(frame.size.height / size.height) * Int(frame.size.width / size.width) >= cellCount {
                return size
            }
        }
        return minimumAllowedSize
    }
}

private extension CGSize {
    var area: CGFloat {
        return width * height
    }
}

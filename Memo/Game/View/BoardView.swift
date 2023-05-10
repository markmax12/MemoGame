//
//  BoardView.swift
//  Memo
//
//  Created by Maxim Ivanov on 09.05.2023.
//

import UIKit

class BoardView: UIView {

    private struct Constants {
        static let cellAspectRatio: CGFloat = 0.7
        static let spacingDx: CGFloat = 3.0
        static let spacingDy: CGFloat = 3.0
    }
    
    var cardViews = [CardView]()
    
    var rowsGrid: Int {
        return grid?.dimensions.rowCount ?? 0
    }
    
    private var grid: AspectRatioGrid?
    
    private func layoutSetCards() {
        if let grid {
            let columnsGrid = grid.dimensions.columnCount
            for row in 0..<rowsGrid {
                for column in 0..<columnsGrid {
                    if cardViews.count > (row * columnsGrid + column) {
                        self.cardViews[row * columnsGrid + column].frame =
                        grid[row,column]!.insetBy(dx: Constants.spacingDx,
                                                  dy: Constants.spacingDy)
                    }
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        grid = AspectRatioGrid(
            layout: Constants.cellAspectRatio,
            frame: bounds
        )
        grid?.cellCount = cardViews.count
        layoutSetCards()
    }
    
    func setCardViews(with cardView: [CardView]) {
        cardViews += cardView
        cardView.forEach { (setCardView) in
            addSubview(setCardView)
        }
       layoutIfNeeded()
    }
    
    func reset() {
        cardViews.forEach { $0.removeFromSuperview() }
        cardViews = []
        layoutIfNeeded()
    }
}

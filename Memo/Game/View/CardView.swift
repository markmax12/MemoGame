//
//  CardView.swift
//  Memo
//
//  Created by Maxim Ivanov on 09.05.2023.
//

import UIKit

class CardView: UIView {
    
    private struct Constants {
        static let cardBack = "KnkO2xbCzoQ"
        static let shadowColor = UIColor.black.cgColor
        static let shadowOpacity: Float = 0.2
        static let shadowOffset = CGSize(width: 2, height: 2)
        static let shadowRadius: CGFloat = 2
    }
    
    var faceUpBackgroundColor = UIColor.white {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var emoji = "?" {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    var state: CardState = .faceDown {
        didSet {
            setNeedsDisplay()
            setNeedsLayout()
        }
    }
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * 0.06
    }
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        faceUpBackgroundColor.setFill()
        roundedRect.fill()

        if state == .faceUp {
            emojiLabel.text = emoji
            emojiLabel.isHidden = false
        } else if state == .faceDown {
            emojiLabel.isHidden = true
            if let image = UIImage(named: Constants.cardBack, in: Bundle.main, compatibleWith: traitCollection) {
                image.draw(in: bounds)
            }
        } else {
            isHidden = true
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        isOpaque = false
        alpha = 0
        layer.shadowColor = Constants.shadowColor
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowOffset = Constants.shadowOffset
        layer.shadowRadius = Constants.shadowRadius
        setupCardFront()
    }
    
    private func setupCardFront() {
        addSubview(emojiLabel)
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: centerYAnchor)])
    }
}

extension CardView {
    //MARK: - Animation
    
    func animateDeal(from point: CGPoint, delay: TimeInterval) {
        let currentCenter = center
        let currentBounds = bounds
        center = point
        alpha = 1
        bounds = CGRect(x: 0.0,
                        y: 0.0,
                        width: 0.6 * bounds.width,
                        height: 0.6 * bounds.height)
        
        layer.shadowOpacity = 0.0
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 1,
            delay: delay,
            options: [],
            animations: {
            self.center = currentCenter
            self.bounds = currentBounds
            },
            completion: { _ in
                UIView.transition(
                    with: self,
                    duration: 0.3,
                    options: [.transitionFlipFromLeft],
                    animations: {
                        self.isUserInteractionEnabled = false
                        self.state = .faceUp
                        self.layer.shadowOpacity = 0.2
                    })
          })
    }
    
    func animatePeekFlip() {
        UIView.transition(with: self,
                          duration: 0.3,
                          options: [.transitionFlipFromRight],
                          animations: {
            switch self.state {
            case .faceUp:
                self.state = .faceDown
            default:
                break
            }
        }, completion: { _ in
            self.isUserInteractionEnabled = true
        })
    }
    
    func animateFlip() {
        UIView.transition(with: self,
                          duration: 0.3,
                          options: [.transitionFlipFromRight],
                          animations: {})
    }
}

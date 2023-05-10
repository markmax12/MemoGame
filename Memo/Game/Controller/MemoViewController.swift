//
//  ViewController.swift
//  Memo
//
//  Created by Maxim Ivanov on 09.05.2023.
//

import UIKit
import Combine

class MemoViewController: UIViewController {
    
    
    private var boardView = BoardView()
    private var bottomMenu = BottomMenu()
    public var game: MemoModel!
    private var subscripptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .secondarySystemBackground
        setupLayout()
        bindToModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        setupCardDeck()
        bottomMenu.newGameButton.isUserInteractionEnabled = false
    }
    
    func updateView() {
        for index in game.cards.indices {
            let card = game.cards[index]
            let cardView = boardView.cardViews[index]
            updateCardView(cardView, with: card)
            if card.state == .notMatched {
                game.cards[index].state = .faceDown
            }
        }
    }
    
    private func updateCardView(_ cardView: CardView, with card: Card) {
        switch card.state {
        case .matched:
            cardView.state = .faceUp
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
                cardView.state = .matched
            })
        case .notMatched:
            cardView.state = .faceUp
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { timer in
                if cardView.state == .faceDown { timer.invalidate(); return }
                if cardView.state == .faceUp {
                    cardView.state = .faceDown
                    cardView.animateFlip()
                }
            })
        case .faceUp:
            cardView.state = card.state
            cardView.emoji = card.emoji
        case .faceDown:
            if cardView.state == .faceUp {
                cardView.state = .faceDown
                cardView.animateFlip()
            } else {
                cardView.state = card.state
                cardView.emoji = card.emoji
            }
        }
    }
    
    private func newGame() {
        game.resetGame()
        boardView.reset()
        setupCardDeck()
    }
    
    private func backToMenu() {
        boardView.isHidden = true
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - View Setup

extension MemoViewController {
    
    private func setupLayout() {
        view.addSubview(bottomMenu)
        view.addSubview(boardView)
        setupBoardView()
        setupBottomMenu()
    }
    
    private func setupBottomMenu() {
        setupActionsForMenuButtons()
        bottomMenu.translatesAutoresizingMaskIntoConstraints = false
        let layoutMargins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            bottomMenu.leadingAnchor.constraint(equalTo: layoutMargins.leadingAnchor),
            bottomMenu.bottomAnchor.constraint(equalTo: layoutMargins.bottomAnchor),
            bottomMenu.topAnchor.constraint(equalTo: boardView.bottomAnchor, constant: 20),
            bottomMenu.trailingAnchor.constraint(equalTo: layoutMargins.trailingAnchor)
        ])
    }
    
    private func setupActionsForMenuButtons() {
        bottomMenu.newGameButton.addAction(UIAction(handler: { _ in self.newGame() }), for: .touchUpInside)
        bottomMenu.backToMenuButton.addAction(UIAction(handler: { _ in self.backToMenu() }), for: .touchUpInside)
    }

    
    private func setupBoardView() {
        boardView.translatesAutoresizingMaskIntoConstraints = false
        let layoutMarginsGuide = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            boardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            boardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            boardView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 20),
            boardView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor, constant: -90)
        ])
    }
    
    func setupCardDeck() {
        var cards = [CardView]()
        for index in game.cards.indices {
            let card = game.cards[index]
            let cardView = CardView()
            updateCardView(cardView, with: card)
            addTapGestureRecognizer(to: cardView)
            cards.append(cardView)
        }
        boardView.setCardViews(with: cards)
 
        dealAnimation(from: boardView.cardViews.last!.center,
                      flipAfter: Double(boardView.cardViews.count) * 0.33)
    }
    
    private func addTapGestureRecognizer(to cardView: CardView) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapCard(_:)))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        cardView.addGestureRecognizer(gesture)
    }
    
    @objc private func tapCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let cardView = recognizer.view! as? CardView {
                game.choseCard(at: boardView.cardViews.firstIndex(of: cardView)!)
            }
        default:
            break
        }
        updateView()
    }
}

//MARK: - Combine Bindings

extension MemoViewController {
    
    private func bindScoreLabelToModel() {
        game
            .$points
            .receive(on: DispatchQueue.main)
            .map { String("Score: \($0)") }
            .assign(to: \.text, on: bottomMenu.scoreLabel)
            .store(in: &subscripptions)
    }
    
    private func bindFlipCountLabelToModel() {
        game
            .$totalFlips
            .receive(on: DispatchQueue.main)
            .map { String("Flips: \($0)") }
            .assign(to: \.text, on: bottomMenu.flipCountLabel)
            .store(in: &subscripptions)
    }
    
    private func bindMatchedCardsCount() {
        game
            .$matchedCardsCount
            .receive(on: DispatchQueue.main)
            .sink { [weak self] matchCount in
                if matchCount == 10 {
                    self?.showEndGameAlert()
                }
            }.store(in: &subscripptions)
    }
    
    private func bindToModel() {
        bindScoreLabelToModel()
        bindFlipCountLabelToModel()
        bindMatchedCardsCount()
    }
}

//MARK: - Animations

extension MemoViewController {
    
    private func dealAnimation (from point: CGPoint, flipAfter: Double) {
        var currentDealCard = 0
        let timeInterval =  0.15  * Double(boardView.rowsGrid + 1)
        Timer.scheduledTimer(withTimeInterval: timeInterval,
                                      repeats: false) { _ in
            self.bottomMenu.newGameButton.isUserInteractionEnabled = false
            for  cardView in self.boardView.cardViews {
                cardView.animateDeal(from: point,
                                    delay: TimeInterval(currentDealCard) * 0.25)
                currentDealCard += 1
            }
            
            Timer.scheduledTimer(withTimeInterval: flipAfter,
                                 repeats: false) { _ in
                for cardView in self.boardView.cardViews {
                    cardView.state = .faceDown
                    cardView.animatePeekFlip()
                    self.bottomMenu.newGameButton.isUserInteractionEnabled = true
                }
            }
        }
    }
}

//MARK: - End game alert

extension MemoViewController {
    
    func showEndGameAlert() {
        var message = ""
        var alertTitle = ""
        
        if game.points > ScoresSingleton.shared.highScore {
            alertTitle = "Congratulations!"
            message = "New high score, well done!"
            ScoresSingleton.shared.highScore = game.points
            ScoresSingleton.shared.lastScore = game.points
            ScoresSingleton.shared.save(ScoresSingleton.shared,
                                        userInfo: [ScoresSingleton.notificationReason: ScoresSingleton.newHighScore])
        } else {
            alertTitle = "You win!"
            message = "You can do better!"
            ScoresSingleton.shared.lastScore = game.points
            ScoresSingleton.shared.save(ScoresSingleton.shared,
                                        userInfo: [ScoresSingleton.notificationReason: ScoresSingleton.newLastScore])
        }
        
        showAlertController(with: alertTitle, message: message)
    }
    
    private func showAlertController(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let newGameAction = UIAlertAction(title: "New game", style: .default) { _ in
            self.newGame()
        }
        
        let goToMenuAction = UIAlertAction(title: "Back to menu", style: .default) { _ in
            self.backToMenu()
        }
        
        alert.addAction(newGameAction)
        alert.addAction(goToMenuAction)
        
        present(alert, animated: true)
    }
}

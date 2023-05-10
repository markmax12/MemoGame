//
//  OnboardingViewController.swift
//  Memo
//
//  Created by Maxim Ivanov on 09.05.2023.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    private struct Constants {
        static let numberOfCardPairs = 10
        static let shadowColor = UIColor.black.cgColor
        static let shadowOpacity: Float = 0.1
        static let shadowOffset = CGSize(width: 2, height: 2)
        static let shadowRadius: CGFloat = 2
        static let cornerRadius: CGFloat = 7
    }
    
    private var emojiBundles = EmojiBundles.countries
    
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var lastScoreLabel: UILabel!
    @IBOutlet weak var popUpButton: UIButton!

    @IBOutlet weak var scoreView: UIView! {
        didSet {
            scoreView = setViewCornersAndShadow(scoreView)
        }
    }
    
    @IBOutlet weak var emojiBundleOptionView: UIView! {
        didSet {
            emojiBundleOptionView = setViewCornersAndShadow(emojiBundleOptionView)
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPopUpButton()
        setupDynamicLabels()
    }
    
    @IBAction func howToPlayButtonPressed(_ sender: UIButton) {
        presentInfoAlert()
    }
    
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        presentGameViewController(numberOfCardPairs: Constants.numberOfCardPairs,
                                  emojiTheme: emojiBundles.theme)
    }
}

extension OnboardingViewController {
    //MARK: - Label bindings
    
    private func setupDynamicLabels() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: ScoresSingleton.newScoreSet, object: nil)
        highScoreLabel.text = "High score: \(ScoresSingleton.shared.highScore)"
        lastScoreLabel.text = "Last score: \(ScoresSingleton.shared.lastScore)"
    }
    
    @objc private func handleNotification(_ notification: Notification) {
        guard let _ = notification.object as? ScoresSingleton, let reason = notification.userInfo?[ScoresSingleton.notificationReason] as? String else { return }
        if reason == ScoresSingleton.newHighScore {
            highScoreLabel.text = "High score: \(ScoresSingleton.shared.highScore)"
            lastScoreLabel.text = "Last score: \(ScoresSingleton.shared.lastScore)"
        } else if reason == ScoresSingleton.newLastScore {
            lastScoreLabel.text = "Last score: \(ScoresSingleton.shared.lastScore)"
        }
    }
}

extension OnboardingViewController {
    //MARK: - View setup
    
    private func presentInfoAlert() {
        let alertController =
        UIAlertController(
            title: "Instructions",
            message: """
This is a variation of Memory Game, also known as Matching Game.

1. Objective:
Find all matching pairs of cards.
    
2. Gameplay:
Turn over two cards at a time to reveal their images.
If the cards match, you earn a point.
If the cards don't match, they are flipped back face-down.
If you already saw mismatched cards, you get a penalty.
Remember the positions and cards you have seen.

Enjoy the game and test your memory skills!
""",
            preferredStyle: .alert)

        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    private func presentGameViewController(numberOfCardPairs: Int,
                                          emojiTheme: EmojiBundles.EmojiTheme) {
        do {
            let vc = MemoViewController()
            let model = try MemoModel(numberOfCardPairs: numberOfCardPairs,
                                      emojiTheme: emojiTheme)
            vc.game = model
            navigationController?.pushViewController(vc, animated: true)
        } catch {
            switch error {
            case let e as RunTimeError:
                present(e.description)
            default:
                present(error.localizedDescription)
            }
        }
    }
    
    private func setupPopUpButton() {
        
        let handler: UIActionHandler = { (action: UIAction) in
            switch action.title {
            case EmojiBundles.countries.rawValue:
                self.emojiBundles = .countries
            case EmojiBundles.animals.rawValue:
                self.emojiBundles = .animals
            case EmojiBundles.food.rawValue:
                self.emojiBundles = .food
            case EmojiBundles.transport.rawValue:
                self.emojiBundles = .transport
            default:
                self.emojiBundles = .countries
            }
        }
        
        popUpButton.menu  = UIMenu(children: [
            UIAction(title: EmojiBundles.countries.rawValue, handler: handler),
            UIAction(title: EmojiBundles.animals.rawValue, handler: handler),
            UIAction(title: EmojiBundles.food.rawValue, handler: handler),
            UIAction(title: EmojiBundles.transport.rawValue, handler: handler)
        ])
    }
    
    private func setViewCornersAndShadow(_ view: UIView) -> UIView {
        view.layer.shadowColor = Constants.shadowColor
        view.layer.shadowOpacity = Constants.shadowOpacity
        view.layer.shadowOffset = Constants.shadowOffset
        view.layer.shadowRadius = Constants.shadowRadius
        view.layer.cornerRadius = Constants.cornerRadius
        view.layer.masksToBounds = false
        return view
    }
}

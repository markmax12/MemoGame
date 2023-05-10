//
//  BottomMenuButton.swift
//  Memo
//
//  Created by Maxim Ivanov on 10.05.2023.
//

import UIKit

class BottomMenu: UIView {

    lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var flipCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var newGameButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("New Game", for: .normal)
        button.configuration = .filled()
        return button
    }()
    
    lazy var backToMenuButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Menu", for: .normal)
        button.configuration = .filled()
        return button
    }()
    
    private lazy var labelStackView: UIStackView = {
        let labelStackView = UIStackView(arrangedSubviews: [scoreLabel, flipCountLabel])
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.axis = .vertical
        labelStackView.spacing = 10
        labelStackView.distribution = .fillEqually
        labelStackView.alignment = .center
        labelStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        labelStackView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return labelStackView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let buttonStackView = UIStackView(arrangedSubviews: [newGameButton, backToMenuButton])
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.axis = .vertical
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 10
        buttonStackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        buttonStackView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return buttonStackView
    }()
    
    private lazy var buttonAndLabelStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [labelStackView, buttonStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 30
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtonAndLabelStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButtonAndLabelStackView() {
        addSubview(buttonAndLabelStackView)
        
        NSLayoutConstraint.activate([
            buttonAndLabelStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonAndLabelStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            buttonAndLabelStackView.topAnchor.constraint(equalTo: topAnchor),
            buttonAndLabelStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

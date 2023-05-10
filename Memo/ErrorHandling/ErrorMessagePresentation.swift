//
//  ErrorMessagePresentation.swift
//  Memo
//
//  Created by Maxim Ivanov on 09.05.2023.
//

import UIKit

extension UIViewController {
    func present(_ errorMessage: String) {
        let alert = UIAlertController(title: nil, message: errorMessage, preferredStyle: .alert)
        alert.addAction((UIAlertAction(title: "Ok", style: .default)))
        present(alert, animated: true)
    }
}

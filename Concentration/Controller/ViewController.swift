//
//  ViewController.swift
//  Concentration
//
//  Created by Filipp Krupnov on 9/15/20.
//

import UIKit
import SCLAlertView

class ViewController: UIViewController {

    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    var numberOfPairsOfCards: Int {
        return cardButtons.count / 2
    }
    private var themeBackgroundColor: UIColor?
    private var themeCardColor: UIColor?
    private var themeCardTitles: [String]?
    private var emoji = [Card: String]()
    
    private let Emojies = Theme.init(backgroundColor: .black, cardColor: .orange, cardTitles: ["🏖", "⛴", "🧞‍♂️", "🍺", "🚁", "🚧", "⛩", "🦠", "🍆", "🌋", "🛶", "🛸", "🎾", "🍎", "👽", "🐿"])
    
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var timeBonusLabel: UILabel!
    @IBOutlet private(set) var cardButtons: [UIButton]!
    @IBOutlet private weak var restartButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTheme()
        updateView()
        restartButton.isHidden = true
       // SCLAlertView().showInfo("Congratulation", subTitle: "You win!!!")
    }
    
    func showAlert(withMessage message: String) {
            let alertController = UIAlertController(title: "Congratulation", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Restart", style: .default, handler: { [self] _ in
                game.resetCards()
                game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
                emoji.removeAll()
                settingTheme()
                updateView()
            })
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }
    
    private func settingTheme() {
        let themes = [Emojies]
        let randomTheme = themes.count.arc4random
        themeBackgroundColor = themes[randomTheme].backgroundColor
        themeCardColor = themes[randomTheme].cardColor
        themeCardTitles = themes[randomTheme].cardTitles
        view.backgroundColor = themeBackgroundColor
        restartButton.tintColor = themeCardColor
    }
    
    private func updateView() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = .white
                button.isEnabled = false
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : themeCardColor
                button.isEnabled = true
            }
        }
    }
    
    @IBAction private func selectCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateView()
            
        } else {
            print("Chosen card was not in cardButtons")
        }
        if game.matches == numberOfPairsOfCards {
            restartButton.isHidden = true
            showAlert(withMessage: "You win!!!")//.text!)
        }
    }
    
    @IBAction private func restartButtonPressed(_ sender: UIButton) {
        restartButton.isHidden = true
        game.resetCards()
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        emoji.removeAll()
        settingTheme()
        updateView()
    }
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil && themeCardTitles != nil {
            emoji[card] = themeCardTitles!.remove(at: themeCardTitles!.count.arc4random)
        }
        return emoji[card] ?? "?"
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

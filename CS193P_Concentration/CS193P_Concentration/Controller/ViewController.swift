//
//  ViewController.swift
//  CS193P_Concentration
//
//  Created by Илья Москалев on 08.11.2020.
//

import UIKit

class ViewController: UIViewController
{
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards : Int {
            return (cardButtons.count + 1) / 2
    }
    
    @IBOutlet private weak var flipCountLabel : UILabel!
    
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet private  var cardButtons: [UIButton]!
    
    private var emojiChoices =  [String]()
    private var emojiThemes = ["Halloween": ["🦇", "😱", "🙀", "😈", "🎃", "👻", "🍭", "🍬", "🍎", "👽", "💀"],
                               "Sports"   : ["🏄🏻‍♂️", "⛹🏻‍♂️", "🏌🏻‍♂️", "🚣🏻‍♂️", "🏊🏻‍♂️", "🚵🏻‍♂️", "🥋", "🧗🏻‍♀️", "🤾🏻‍♀️", "🤽🏻‍♀️"],
                               "Vehicles" : ["🚖", "🚗", "🚘", "🚙", "🚝", "🚚", "🚞", "✈️", "🛳", "🚁"],
                               "Animals"  : ["🦓", "🦒", "🦩", "🐈", "🦢", "🦥", "🦧", "🦚", "🐁", "🐍"],
                               "Hearts"   : ["💙", "💚", "💛", "💜", "🧡", "❤️", "🖤", "🤎", "💝", "💟"],
                               "Food"     : ["🧀", "🌮", "🍚", "🍟", "🍧", "🍡", "🥗", "🍩", "🍰", "🍙"]]
    //!!!!!!!!____РАЗОБРАТЬ____!!!!!!!!!!
    private var indexTheme = 0 {
        didSet {
            print(indexTheme, keys[indexTheme])
            titleLabel.text = keys[indexTheme]
            emojiChoices = emojiThemes[keys[indexTheme]] ?? []
            emoji = [Card:String]()
        }
    }
    private var keys: [String] {return Array(emojiThemes.keys)}
    
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
        // Изменяем текст flipCountLabel
        let attributesFlip: [NSAttributedString.Key: Any] = [
            .strokeColor : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            .strokeWidth : 5.0 // Обводит снаружи
        ]
        let attributedStringFlip = NSAttributedString(string: "Flips: \(game.flipCount)", attributes: attributesFlip)
        flipCountLabel.attributedText = attributedStringFlip
        // Изменяем текст scoreLabel
        let attributesScore: [NSAttributedString.Key: Any] = [
            .strokeColor : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            .strokeWidth : -5.0 // Закрашивает внутрь
        ]
        let attributedStringScore = NSAttributedString(string: "Score: \(game.score)", attributes: attributesScore)
        scoreLabel.attributedText = attributedStringScore
        
    }
    
    private var emoji = [Card:String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            emoji[card] = emojiChoices.remove(at: emojiChoices.count.arc4random)
        }
        return emoji[card] ?? "?"
    }
    
    @IBAction private func newGameButton(_ sender: UIButton) {
        indexTheme = keys.count.arc4random
        game.resetGame()
        updateViewFromModel()
    }
    
    override func viewDidLoad() {
        indexTheme = keys.count.arc4random
        updateViewFromModel()
    }
}

extension Int {
    var arc4random: Int {
        if self > 0{
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    }
}

//
//  Concentration.swift
//  CS193P_Concentration
//
//  Created by Илья Москалев on 08.11.2020.
//

import Foundation

class Concentration
{
    private(set) var cards = [Card]()
    
    private(set) var score = 0
    private(set) var flipCount = 0
    
    private var seenCards: Set<Int> = []
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter {cards[$0].isFaceUp}.oneAndOnly
//            return faceUpCardIndicies.count == 1 ? faceUpCardIndicies.first : nil
//            var foundIndex : Int?
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    if foundIndex == nil {
//                        foundIndex = index
//                    } else {
//                        return nil
//                    }
//                }
//            }
//            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index is not in the cards")
        if !cards[index].isMatched {
            flipCount += 1
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex] == cards[index] {
                //CARDS MATCH
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    //Increase score
                    score += Points.matchBonus
                } else {
                //Cards didn't match - Penalize
                    if seenCards.contains(index) {
                        score -= Points.missMatchPenalty
                    }
                    if seenCards.contains(matchIndex) {
                        score -= Points.missMatchPenalty
                    }
                    seenCards.insert(index)
                    seenCards.insert(matchIndex)
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
    
    func resetGame() {
        flipCount = 0
        score = 0
        seenCards = []
        for index in cards.indices {
            cards[index].isMatched = false
            cards[index].isFaceUp = false
        }
    }
}

private struct Points {
    static let matchBonus = 2
    static let missMatchPenalty = 1
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}

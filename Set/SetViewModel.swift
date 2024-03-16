//
//  SetViewModel.swift
//  Set
//
//  Created by Teodor Adrian on 3/10/24.
//

import Foundation
import SwiftUI

class SetViewModel: ObservableObject {
    typealias Card = SetGame<ContentShape, ContentPattern, ContentColor>.Card
    
    static var cardContent: [Card.CardContent] = {
        var content: [Card.CardContent] = []
        for numberOfSymbols in 1...3 {
            for color in ContentColor.allCases {
                for shape in ContentShape.allCases {
                    for pattern in ContentPattern.allCases {
                        content.append(Card.CardContent(numberOfSymbols: numberOfSymbols, color: color, shape: shape, fillPattern: pattern))
                    }
                }
            }
        }
        return content.shuffled()
    }()
    
    private static func createSetGame() -> SetGame<ContentShape, ContentPattern, ContentColor> {
        SetGame() { i in cardContent[i] }
    }
    
    @Published private var game = createSetGame()
    
    // MARK: - Vars
    
    var cards: [Card] {
        game.cards
    }
    
    var unplayedCards: [Card] {
        return game.unplayedCards
    }
    
    var matchedCards: [Card] {
        game.matchedCards
    }
    
    var numberOfPlayingCards: Int {
        game.dealtCards
    }
    
    var numberOfTotalCards: Int {
        game.numberOfTotalCards
    }
    
    var score: Int {
        game.score
    }
    
    var isGameOver: Bool {
        game.gameOver
    }
    
    var noRemainingCards: Bool {
        game.noRemainingCards
    }
    
    var noSetsFoundByCheat: Bool {
        game.noSetsFoundByCheat
    }
    // MARK: - Intents
    func newGame() {
        SetViewModel.cardContent.shuffle()
        game = SetViewModel.createSetGame()
    }
    
    func resetMatchedCards(){
        game.resetMatchingCards()
    }
    
    func addThreeMore(){
        game.addThreeMore { index in
            SetViewModel.cardContent[index]
        }
    }
    
    func cheat(){
        game.cheat()
    }
    
    func choose(_ card: Card){
        game.choose(card)
    }
    
    func dismissMessage(){
        game.dismissMessage()
    }
    
    func shuffle() {
        game.shuffle()
    }

}

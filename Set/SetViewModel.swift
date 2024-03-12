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
    
    @Published private var model = createSetGame()
    
    // MARK: - Vars
    
    var cards: [Card] {
        return model.cards
    }
    
    var numberOfPlayingCards: Int {
        model.dealtCards
    }
    
    var numberOfTotalCards: Int {
        model.numberOfTotalCards
    }
    
    var score: Int {
        model.score
    }
    
    var isGameOver: Bool {
        model.gameOver
    }
    
    var noRemainingCards: Bool {
        model.noRemainingCards
    }
    
    
    // MARK: - Intents
    func newGame() {
        SetViewModel.cardContent.shuffle()
        model = SetViewModel.createSetGame()
    }
    
    func addThreeMore(){
        model.addThreeMore { index in
            SetViewModel.cardContent[index]
        }
    }
    
    func cheat(){
        model.cheat()
    }
    
    func choose(_ card: Card){
        model.choose(card)
    }
    
    
    func shuffle() {
        model.shuffle()
    }
    // MARK: - Eums
    
    enum ContentShape: CaseIterable {
        case diamond
        case squiggle
        case rectangle
    }
    
    enum ContentPattern: CaseIterable {
        case empty
        case hashed
        case filled
    }
    
    enum ContentColor: CaseIterable {
        case green
        case indigo
        case pink
        
        func getColor() -> Color {
            switch self {
            case .green:
                return Color.green
            case .indigo:
                return Color.indigo
            case .pink:
                return Color.pink
            }
        }
    }
}

//
//  SetGame.swift
//  Set
//
//  Created by Teodor Adrian on 3/10/24.
//

import Foundation

struct SetGame<SomeShape, SomePattern, SomeColor> where SomeShape: Equatable, SomeColor: Equatable, SomePattern: Equatable {
    private(set) var cards: [Card]
    private(set) var score = 0
    private(set) var gameOver = false
    private(set) var numberOfTotalCards = 81
    private(set) var dealtCards = 12

    
    init(createCardContent: (Int) -> Card.CardContent) {
        cards = []
        for i in 0..<dealtCards {
            let content = createCardContent(i)
            cards.append(Card(id: i, symbol: content))
        }
        shuffle()
    }
    
    mutating func addThreeMore(createCardContent: (Int) -> Card.CardContent){
        if dealtCards >= numberOfTotalCards {
            gameOver = true
        } else {
            for i in dealtCards..<dealtCards + 3 {
                let content = createCardContent(i)
                cards.append(Card(id: i, symbol: content))
            }
        }
        dealtCards += 3
    }
    
    mutating func shuffle(){
        cards.shuffle()
    }
    
    func printCards(){
        print(cards, "\n")
    }
    
    struct Card: Equatable, Identifiable, CustomStringConvertible {
        var description: String {
            "\(id), \(symbol.shape), \(symbol.color), \(symbol.fillPattern)\n"
        }
        
        let id: Int
        let symbol: CardContent
        var isMatched = false
        
        struct CardContent: Equatable {
            let numberOfSymbols: Int
            let color: SomeColor
            let shape: SomeShape
            let fillPattern: SomePattern
        }
    }
}

//
//  SetGame.swift
//  Set
//
//  Created by Teodor Adrian on 3/10/24.
//

import Foundation

struct SetGame<SomeShape, SomePattern, SomeColor> where SomeShape: Equatable & Hashable, SomeColor: Equatable & Hashable, SomePattern: Equatable & Hashable {
    
    private(set) var cards: [Card] // cards that are on the table rn
    private(set) var chosenCards: [Card] // 3 tapped cards will go here for check
    private(set) var unplayedCards: [Card] // an array wich contains all the cards in the game
    
    private(set) var score = 0
    private(set) var gameOver = false
    private(set) var numberOfTotalCards = 81
    private(set) var dealtCards = 12
    private(set) var noRemainingCards = false
    
    
    init(createCardContent: (Int) -> Card.CardContent) {
        cards = []
        chosenCards = []
        unplayedCards = []
        
        for i in 0..<dealtCards {
            let content = createCardContent(i)
            cards.append(Card(id: i, symbol: content))
        }
        
        for i in dealtCards..<numberOfTotalCards {
            let content = createCardContent(i)
            unplayedCards.append(Card(id: i, symbol: content))
        }
        shuffle()
    }
    
    
    
    func verifySet(_ cards: [Card]) -> Bool {
        
        if cards.isEmpty{
            return false
        }
        
        let colorsSet = Set(cards.map({ $0.symbol.color }))
        let shapesSet = Set(cards.map({ $0.symbol.shape }))
        let numberOfSymbolsSet = Set(cards.map({ $0.symbol.numberOfSymbols }))
        let patternSet = Set(cards.map({ $0.symbol.fillPattern }))
        
        if colorsSet.count == 2 || shapesSet.count == 2 || numberOfSymbolsSet.count == 2 || patternSet.count == 2 {
            return false
        }
        return true
    }
    
    func checkRemainingSets(in cards: [Card]) -> Bool {
        
        if cards.isEmpty{
            return false
        }

        let numberOfCards = cards.count
        for i in 0..<numberOfCards - 2 {
            for j in (i + 1)..<numberOfCards - 1 {
                for k in (j + 1)..<numberOfCards {
                    if (verifySet([cards[i], cards[j], cards[k]])){
                        return true
                    }
                }
            }
        }
        return false
    }
    
    mutating func addThreeMore(createCardContent: (Int) -> Card.CardContent){
        if dealtCards >= numberOfTotalCards {
            noRemainingCards = true
        } else {
            if (verifySet(cards)) {
                score -= 10
            }
            
            var newCards: [Card] = []
            
            for i in dealtCards..<dealtCards + 3 {
                let content = createCardContent(i)
                let newCard = Card(id: i, symbol: content)
                cards.append(newCard)
                newCards.append(newCard)
            }
            
            for newCard in newCards {
                if let indexToRemove = unplayedCards.firstIndex(of: newCard){
                    unplayedCards.remove(at: indexToRemove)
                }
            }
        }
        dealtCards += 3
    }
    
    mutating func choose(_ card: Card){
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }){
            
            if chosenCards.isEmpty {
                for card in cards {
                    if let index = cards.firstIndex(of: card){
                        cards[index].isNotMatched = false
                    }
                }
            }
            
            if !cards[chosenIndex].touched {
                cards[chosenIndex].touched.toggle()
                chosenCards.append(cards[chosenIndex])
                if chosenCards.count == 3 {
                    if (verifySet(chosenCards)) {
                        score += 15
                        
                        for chosenCard in chosenCards {
                            if let index = cards.firstIndex(of: chosenCard) {
                                cards[index].isMatched = true
                                cards.remove(at: index)
                                if let newCard = unplayedCards.randomElement() {
                                    cards.append(newCard)
                                }
                            }
                        }
                        
                        gameOver = checkGameOver(cards)
                        
                    } else {
                        score -= 5
                        for chosenCard in chosenCards {
                            if let index = cards.firstIndex(of: chosenCard) {
                                cards[index].touched = false
                                cards[index].isNotMatched = true
                            }
                        }
                    }
                    chosenCards.removeAll()
                }
            } else {
                if let indexToRemove = chosenCards.firstIndex(of: cards[chosenIndex]) {
                    chosenCards.remove(at: indexToRemove)
                } else {
                    print("Card not found in chosenCards.")
                }
                cards[chosenIndex].touched = false
            }
        }
    }
    
    mutating func shuffle(){
        cards.shuffle()
    }
    
    mutating func checkGameOver(_ cards: [Card]) -> Bool {
        if checkRemainingSets(in: cards){
            return false
        }
        return true
    }
    
    struct Card: Equatable, Identifiable, CustomStringConvertible {
        var description: String {
            "\(id), \(symbol.shape), \(symbol.color), \(symbol.fillPattern)\n"
        }
        
        let id: Int
        let symbol: CardContent
        var isMatched = false
        var isNotMatched = false
        var touched = false
        
        struct CardContent: Equatable {
            let numberOfSymbols: Int
            let color: SomeColor
            let shape: SomeShape
            let fillPattern: SomePattern
        }
    }
}

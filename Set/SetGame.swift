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
    private(set) var noSetsFoundByCheat = false
    
    
    init(createCardContent: (Int) -> Card.CardContent) {
        // initialing the 3 arrays i'm using
        cards = []
        chosenCards = []
        unplayedCards = []
        
        // i'm appending 12 cards initially in the array which is on the table
        for i in 0..<dealtCards {
            let content = createCardContent(i)
            cards.append(Card(id: i, symbol: content))
        }
        
        // and the rest i'm appening to the unplayedCards array
        for i in dealtCards..<numberOfTotalCards {
            let content = createCardContent(i)
            unplayedCards.append(Card(id: i, symbol: content))
        }
        
        // shuffle for the effect :)
        shuffle()
    }
    
    
    
    func verifySet(_ cards: [Card]) -> Bool {
        
        if cards.isEmpty{
            return false
        }
        
        // 4 variables conforming to the rules of Set
        let colorsSet = Set(cards.map({ $0.symbol.color }))
        let shapesSet = Set(cards.map({ $0.symbol.shape }))
        let numberOfSymbolsSet = Set(cards.map({ $0.symbol.numberOfSymbols }))
        let patternSet = Set(cards.map({ $0.symbol.fillPattern }))
        
        if colorsSet.count == 2 || shapesSet.count == 2 || numberOfSymbolsSet.count == 2 || patternSet.count == 2 {
            return false
        }
        return true
    }
    
    func setOnTable(in cards: [Card]) -> [Card]? {
        // if there are no cards on table then the game is done
        if cards.isEmpty{
            return nil
        }
        
        // i'm searching for the first possible match
        let numberOfCards = cards.count
        for i in 0..<numberOfCards - 2 {
            for j in (i + 1)..<numberOfCards - 1 {
                for k in (j + 1)..<numberOfCards {
                    if (verifySet([cards[i], cards[j], cards[k]])){
                        return [cards[i], cards[j], cards[k]]
                    }
                }
            }
        }
        return nil
    }
    
    mutating func addThreeMore(createCardContent: (Int) -> Card.CardContent){
        if dealtCards >= numberOfTotalCards {
            noRemainingCards = true
        } else {
            // if a set is already existing on the table, penalize the player with -10 points
            if let _ = setOnTable(in: cards){
                score -= 10
            }
            
            resetisNotMatched()
            dealThreeCards()
        }
        dealtCards += 3
    }
    
    mutating func dealThreeCards(){
        //im appending 3 cards from de unplayed array to the cards that are on the table
        for _ in 1...3 {
            if let newCard = unplayedCards.randomElement(){
                cards.append(newCard)
                if let index = unplayedCards.firstIndex(of: newCard){
                    unplayedCards.remove(at: index)
                }
            }
        }
    }
    
    mutating func resetisNotMatched(){
        if chosenCards.isEmpty {
            for card in cards {
                if let index = cards.firstIndex(of: card){
                    cards[index].isNotMatched = false
                }
            }
        }
    }
    
    mutating func choose(_ card: Card){
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }){
            resetisNotMatched()
            
            if !cards[chosenIndex].touched {
                
                cards[chosenIndex].touched.toggle()
                chosenCards.append(cards[chosenIndex])
                
                // if in chosenCards are 3 cards it means the user selected 3 cards and i'll check if
                // the 3 selected cards form a set or not
                if chosenCards.count == 3 {
                    //if they do form a set, i'm increasgin his score, marking the cards as matched and removing
                    // them from the table
                    if (verifySet(chosenCards)) {
                        score += 15
                        
                        // marking the cards as matched
                        for chosenCard in chosenCards {
                            if let index = cards.firstIndex(of: chosenCard) {
                                cards[index].isMatched = true
                            }
                        }
                        
                        // removing all the 3 cards that are matching and appending 3 new ones
                        cards.removeAll { $0.isMatched }
                        dealThreeCards()
                        
                        // checking if there are sets left
                        gameOver = checkGameOver(cards)
                        
                    } else {
                        // im resetting the cards proprties to default
                        score -= 5
                        for chosenCard in chosenCards {
                            if let index = cards.firstIndex(where: { $0.id == chosenCard.id }) {
                                cards[index].touched = false
                                cards[index].isMatched = false
                                cards[index].isNotMatched = true
                            }
                        }
                    }
                    // emptying the chosenCards array
                    chosenCards.removeAll()
                }
            } else {
                // untapping the cards
                for i in chosenCards {
                    if card.id == i.id {
                        chosenCards.removeAll { $0.id == card.id }
                        if let index = cards.firstIndex(where: {$0.id == card.id}) {
                            cards[index].touched = false
                            cards[index].isMatched = false
                            cards[index].isNotMatched = false
                        }
                    }
                }
            }
        }
    }
    
    mutating func dismissMessage() {
        noSetsFoundByCheat = false
    }
    
    mutating func cheat() {
        // if i have cards in chosenCards, i'm just removing them
        // to start searching for the best match
        if chosenCards.count > 0 {
            for i in chosenCards {
                if let index = cards.firstIndex(where: {$0.id == i.id }){
                    cards[index].touched = false
                }
            }
            chosenCards.removeAll()
        }
        
        resetisNotMatched()
        // i'm checking if a set is on the table and if it is, i'm appending the first 2 cards to the chosenCards
        // array and i mark them as matched
        if let existingSet = setOnTable(in: cards) {
            score -= 25
            
            chosenCards.append(existingSet[0])
            chosenCards.append(existingSet[1])
            
            for card in existingSet.prefix(2) {
                if let index = cards.firstIndex(of: card) {
                    cards[index].isMatched = true
                    cards[index].touched = true
                }
            }
        } else {
            noSetsFoundByCheat = true
            dealThreeCards()
        }
    }
    
    mutating func shuffle(){
        cards.shuffle()
    }
    
    mutating func checkGameOver(_ cards: [Card]) -> Bool {
        // if there are no remaining cards and no set then the game is over
        if noRemainingCards{
            if setOnTable(in: cards) == nil {
                return true
            }
        }
        return false
    }
    
    struct Card: Equatable, Identifiable, CustomStringConvertible {
        
        var description: String {
            "\(symbol.numberOfSymbols), \(symbol.shape), \(symbol.color), \(symbol.fillPattern), \(id)\n"
        }
        
        let id: Int // id of the card
        let symbol: CardContent //propetries of the card
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

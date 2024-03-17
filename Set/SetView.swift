//
//  ContentView.swift
//  Set
//
//  Created by Teodor Adrian on 3/10/24.
//

import SwiftUI

struct SetView: View {
    @ObservedObject var game: SetViewModel
    typealias Card = SetGame<ContentShape, ContentPattern, ContentColor>.Card
    
    private let aspectRatio: CGFloat = 2/3
    
    var body: some View {
        VStack{
            if !game.isGameOver {
                VStack{
                    Text("SET!").font(.system(size: 50)).foregroundStyle(.black)
                    Text("Score: \(game.score)").bold().foregroundStyle(.black)
                    cheatMessage
                    layout.padding(.leading).padding(.trailing)
                    commandCentre
                }.monospaced()
            } else {
                gameOverScreen
            }
        }.background(Color.white)
    }
    
    
    private var layout: some View {
        AspectVGrid(game.cards, aspectRatio: 2/3) { card in
            returnCardsView(card)
        }
    }
    
    func returnCardsView(_ card: SetView.Card) -> some View{
            CardView(card)
                .aspectRatio(aspectRatio, contentMode: .fit)
                .matchedGeometryEffect(id: card.id, in: dealing)
                .matchedGeometryEffect(id: card.id, in: discarding)
                .transition(.asymmetric(insertion: .identity, removal: .identity))
                .onTapGesture {
                    withAnimation(.bouncy(duration: 1)) {
                        game.choose(card)
                        
                    }
                }
    }
    
    func basicButton(name: String, function: @escaping () -> ()) -> some View {
        Button(action: {
            function()
        }, label: {
            Text(name)
                .foregroundStyle(.white)
                .padding(9)
                .background {
                    RoundedRectangle(cornerRadius: 25.0)
                }
        })
    }
    
    @Namespace private var dealing
    @Namespace private var discarding
    
    @State private var dealt = Set<Card.ID>()
    
    private var undealtCards: [Card] {
        game.unplayedCards
    }
    
    
    @ViewBuilder
    private var deck: some View {
        ZStack {
            ForEach(undealtCards) { card in
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealing)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: 80, height: 85 / aspectRatio)
        .foregroundStyle(.blue)
        .onTapGesture {
            var delay: TimeInterval = 0
            for card in undealtCards {
                withAnimation(.easeInOut(duration: 1).delay(delay)){
                    _ = dealt.insert(card.id)
                }
                delay += 0.25
            }
            withAnimation(.bouncy(duration: 1, extraBounce: 0.1)) {
                game.addThreeMore()
            }
        }
        
    }
    
    @State private var rotationAngleApplied = false
    
    @ViewBuilder
    private var discardPile: some View {
        ZStack {
            ForEach(game.matchedCards.indices, id: \.self) { index in
                let card = game.matchedCards[index]
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: discarding)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .offset(x: CGFloat(index) * 2, y: CGFloat(index) * -2)
                    .onAppear {
                        
                    }
                    .rotationEffect(game.matchedCards[index].rotationAngle)
                
            }
        }
        .frame(width: 90, height: 90 / aspectRatio)
        
    }
    
    private var rotationAngle: Angle {
        if !rotationAngleApplied {
            rotationAngleApplied = true
            return .degrees(Double.random(in: 1...3))
        } else {
            return .degrees(0)
        }
    }
    
    private var newGameButton: some View {
        basicButton(name: "New Game") {
            game.newGame()
            dealt = []
        }
    }
    
    private var threeMoreButton: some View{
        basicButton(name: "3 More Cards") {
            withAnimation(.bouncy(duration: 1)) {
                game.addThreeMore()
            }
            
        }
    }
    
    private var cheatButton: some View {
        basicButton(name: "Cheat") {
            game.cheat()
        }
    }
    
    private var shuffleButton: some View{
        basicButton(name: "Shuffle") {
            withAnimation {
                game.shuffle()
            }
        }
    }
    
    private var cheatMessage: some View {
        Text("No sets can be made. I'm dealing 3 cards.\nPress on this message to dismiss it.")
            .font(.footnote)
            .foregroundStyle(.black)
            .opacity(game.noSetsFoundByCheat ? 1 : 0)
            .multilineTextAlignment(.center)
            .onTapGesture {
                game.dismissMessage()
            }
    }
    
    
    private var commandCentre: some View {
        HStack{
            VStack{
                deck.padding(.leading)
                Text("  Deal\n").foregroundStyle(.black)
            }
            VStack{
                discardPile
                Text("Discarded\nCards").foregroundStyle(.black).multilineTextAlignment(.center)
            }
            Spacer()
            VStack{
                newGameButton
                shuffleButton
                Group {
                    cheatButton
                }
            }.padding(.trailing)
        }
    }
    
    private var gameOverScreen: some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
            }
            Text("GAME OVER!").font(.largeTitle).foregroundStyle(.black)
            Text("Your final score was: \(game.score)").foregroundStyle(.black)
            Spacer()
            newGameButton.foregroundStyle(.black)
        }.monospaced()
            .background(Color.white)
    }
}

#Preview {
    SetView(game: SetViewModel())
}

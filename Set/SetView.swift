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
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 0)], spacing: 0) {
                ForEach(game.cards, id: \.id) { card in
                    VStack{
                        CardView(card)
                            .aspectRatio(aspectRatio, contentMode: .fit)
                            .matchedGeometryEffect(id: card.id, in: dealing)
                            .matchedGeometryEffect(id: card.id, in: discarding)
                            .transition(.asymmetric(insertion: .identity, removal: .identity))
                            .onTapGesture {
                                withAnimation {
                                    game.choose(card)
                                }
                            }
                    }
                }
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
    
//    private func isDealt(_ card: Card) -> Bool {
//        dealt.contains(card.id)
//    }
    
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
            withAnimation(.bouncy(duration: 1)) {
                game.addThreeMore()
            }
        }
        
    }
    
    @ViewBuilder
    private var discardPile: some View {
        ZStack{
            ForEach(game.matchedCards) { card in
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: discarding)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }.frame(width: 90, height: 90 / aspectRatio)
    }
    
    private var newGameButton: some View {
        basicButton(name: "New Game") {
            game.newGame()
            dealt = []
        }
    }
    
    private var threeMoreButton: some View{
        basicButton(name: "3 More Cards") {
            game.addThreeMore()
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
            Text("GAME OVER!").font(.largeTitle).foregroundStyle(.black)
            Text("Your final score was: \(game.score)").foregroundStyle(.black)
            Spacer()
            newGameButton.padding(.bottom).foregroundStyle(.black)
        }.monospaced().padding(75)
    }
}

#Preview {
    SetView(game: SetViewModel())
}

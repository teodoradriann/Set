//
//  ContentView.swift
//  Set
//
//  Created by Teodor Adrian on 3/10/24.
//

import SwiftUI

struct SetView: View {
    @ObservedObject var game: SetViewModel
    
    var body: some View {
        VStack{
            if !game.isGameOver {
                VStack{
                    Text("SET!").font(.system(size: 50)).foregroundStyle(.black)
                    Text("Score: \(game.score)").bold().foregroundStyle(.black)
                    cards.animation(.default, value: game.cards).padding()
                    HStack{
                        newGameButton.padding(.leading)
                        Spacer()
                        Group {
                            threeMoreButton.disabled(game.noRemainingCards)
                            cheatButton
                                .padding(.trailing)
                        }
                    }
                }.monospaced()
            } else {
                VStack{
                    Spacer()
                    Text("GAME OVER!").font(.largeTitle).foregroundStyle(.black).padding()
                    Text("Your final score was: \(game.score)").foregroundStyle(.black)
                    Spacer()
                    newGameButton.padding(.bottom).foregroundStyle(.black)
                }.monospaced().padding(75)
            }
        }.background(Color.white)
        
    }
    
    
    private var cards: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 0)], spacing: 0) {
                ForEach(game.cards) { card in
                    VStack{
                        CardView(card)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                game.choose(card)
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
    
    private var newGameButton: some View {
        basicButton(name: "New Game") {
            game.newGame()
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
}

#Preview {
    SetView(game: SetViewModel())
}

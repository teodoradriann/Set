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
            Text("SET!").font(.system(size: 50)).monospaced()
            Text("Score: \(game.score)").monospaced().bold()
            cards.animation(.default, value: game.cards).padding()
            HStack{
                newGameButton.padding(.leading)
                Spacer()
                threeMoreButton
                cheatButton.padding(.trailing)
            }
        }
    }
    
    
    private var cards: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 0)], spacing: 0) {
                ForEach(game.cards) { card in
                    VStack{
                        CardView(card)
                            .aspectRatio(2/3, contentMode: .fit)
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
                .font(.system(size: 18))
                .padding(9)
                .background {
                    RoundedRectangle(cornerRadius: 25.0)
                        .foregroundStyle(.blue)
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

//
//  CardView.swift
//  Set
//
//  Created by Teodor Adrian on 3/10/24.
//

import SwiftUI

struct CardView: View {
    let base = RoundedRectangle(cornerRadius: 10)
    let card: SetViewModel.Card
    
    init(_ card: SetViewModel.Card) {
        self.card = card
    }
    
    var body: some View {
        if !card.facedDown {
            ZStack{
                base.strokeBorder(lineWidth: 2)
                    .background(card.touched && !card.isMatched ? base.fill(.orange) : base.fill(.white))
                    .foregroundStyle(card.touched && !card.isMatched ? .orange : .black)
                if card.isNotMatched{
                        base.strokeBorder(lineWidth: 2)
                            .background(base.fill(.gray)).opacity(0.5)
                }
                if card.isMatched {
                    base.strokeBorder(lineWidth: 2)
                        .background(base.fill(.yellow))
                }
                VStack{
                    ForEach(0..<card.symbol.numberOfSymbols, id: \.self) { _ in
                        addShape(for: card)
                    }
                }.padding()
            }.padding(5)
                .rotationEffect(card.isNotMatched ? .degrees(5) : .zero)
        } else {
            base.strokeBorder(lineWidth: 2)
                .foregroundStyle(.black)
                .overlay{
                    Text("❓").font(.largeTitle)
                }
        }
        
    }
    
    
    
    @ViewBuilder
    private func addShape(for card: SetViewModel.Card) -> some View {
        switch card.symbol.shape {
        case .diamond:
            fillShape(of: card.symbol, shape: DiamondShape())
        case .squiggle:
            fillShape(of: card.symbol, shape: SquiggleShape())
        case .rectangle:
            fillShape(of: card.symbol, shape: RoundedRectangle(cornerRadius: 50)
            )
        }
    }
    
    @ViewBuilder
    private func fillShape(of symbol: SetViewModel.Card.CardContent, shape: some Shape) -> some View{
        switch symbol.fillPattern {
        case .empty:
            shape.stroke(symbol.color.getColor(), lineWidth: 2).aspectRatio(2, contentMode: .fit)
        case .filled:
            shape.foregroundStyle(symbol.color.getColor()).aspectRatio(2, contentMode: .fit)
        case .hashed:
            Hash(shape: shape, color: symbol.color.getColor()).aspectRatio(2, contentMode: .fit)
        }
    }
}

#Preview {
    VStack{
        Text("SET").font(.largeTitle).monospaced()
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 0)], spacing: 0) {
            ForEach(0..<12) { _ in
                CardView(SetViewModel.Card(id: 1, symbol: SetGame<ContentShape, ContentPattern, ContentColor>.Card.CardContent(numberOfSymbols: 3, color: .green, shape: .diamond, fillPattern: .empty)))            }
        }.foregroundStyle(.red)
    }
}

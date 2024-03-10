//
//  Hash.swift
//  Set
//
//  Created by Teodor Adrian on 3/10/24.
//

import SwiftUI

struct Hash<someShape: Shape>: View{
    let shape: someShape
    let color: Color
    let spacingColor = Color.white
    
    
    var body: some View {
        HStack(spacing: 0.3) {
            ForEach(0..<10) { _ in
                spacingColor
                color
            }
            spacingColor
        }
        .mask(shape)
        .overlay(shape.stroke(color, lineWidth: 3))
    }
}

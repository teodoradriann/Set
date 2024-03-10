//
//  DiamondShape.swift
//  Set
//
//  Created by Teodor Adrian on 3/10/24.
//

import CoreGraphics
import SwiftUI

struct DiamondShape: Shape, InsettableShape {
    
    var insetAmount = 0.0
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let width = rect.width
        let height = rect.width / 2
        
        let topPoint = CGPoint(x: center.x, y: center.y + height/2)
        let bottomPoint = CGPoint(x: center.x, y: center.y - height/2)
        let leftPoint = CGPoint(x: center.x - width/2, y: center.y)
        let rightPoint = CGPoint(x: center.x + width/2, y: center.y)
        
        p.move(to: topPoint)
        p.addLine(to: leftPoint)
        p.addLine(to: bottomPoint)
        p.addLine(to: rightPoint)
        p.addLine(to: topPoint)
        
        return p
    }
}

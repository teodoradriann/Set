//
//  GenericContents.swift
//  Set
//
//  Created by Teodor Adrian on 3/15/24.
//

import SwiftUI


enum ContentShape: CaseIterable {
    case diamond
    case squiggle
    case rectangle
}

enum ContentPattern: CaseIterable {
    case empty
    case hashed
    case filled
}

enum ContentColor: CaseIterable {
    case green
    case indigo
    case pink
    
    func getColor() -> Color {
        switch self {
        case .green:
            return Color.green
        case .indigo:
            return Color.indigo
        case .pink:
            return Color.pink
        }
    }
}

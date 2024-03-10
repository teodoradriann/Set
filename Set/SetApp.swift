//
//  SetApp.swift
//  Set
//
//  Created by Teodor Adrian on 3/10/24.
//

import SwiftUI

@main
struct SetApp: App {
    @StateObject var game = SetViewModel()
    var body: some Scene {
        WindowGroup {
            SetView(game: game)
        }
    }
}

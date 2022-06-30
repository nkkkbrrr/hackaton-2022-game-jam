//
//  MainMenu.swift
//  Astropics
//
//  Created by Никита on 28.06.2022.
//

import SwiftUI

struct MainMenu: View {
    @Binding var currentGameState: ContentView.CurrentGameState
    @Binding var currentMenuView: ContentView.CurrentMenuView
    
    var body: some View {
        VStack {
            Group {
                Button("Играть") { currentGameState = .map }
//                Button("Достижения") { currentMenuView = .achievements }
                Button("Настройки") { currentMenuView = .settings }
            }
            .buttonStyle(.menuButtonStyle)
        }
    }
}

struct InGameMenu: View {
    @Binding var currentGameState: ContentView.CurrentGameState
    @Binding var currentMenuView: ContentView.CurrentMenuView
    
    var body: some View {
        VStack {
            Group {
                Button("Продолжить") { currentGameState = .game }
                Button("Главное меню") { currentGameState = .mainMenu }
            }
            .buttonStyle(.menuButtonStyle)
        }
    }
}

struct MenuButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .black))
            .padding()
            .frame(minWidth: 100, idealWidth: 200, maxWidth: 300)
            .background(Color("Green Sheen"))
            .cornerRadius(15)
            .padding(.horizontal)
    }
}

extension ButtonStyle where Self == MenuButtonStyle {
    static var menuButtonStyle: Self {
        return .init()
    }
}

//
//  ContentView.swift
//  Astropics
//
//  Created by Никита on 28.06.2022.
//

import SwiftUI

struct ContentView: View {
    enum CurrentGameState {
        case mainMenu, game, map, shop
    }
    enum CurrentMenuView {
        case none, achievements, settings
    }
    
    @State var currentGameState: CurrentGameState = .mainMenu
    @State var currentMenuView: CurrentMenuView = .none
    
    @AppStorage("show-debugging") var showDebugging: Bool = false
    
    var body: some View {
        ZStack {
            if currentGameState == .mainMenu {
                Color("Independence")
                MainMenu(currentGameState: $currentGameState, currentMenuView: $currentMenuView)
            } else if currentGameState == .map {
                MapView(currentGameState: $currentGameState)
            } else if currentGameState == .shop {
                ShopView(currentGameState: $currentGameState)
            } else {
                GameView(
                    currentGameState: $currentGameState,
                    currentMenuView: $currentMenuView,
                    showDebugging: $showDebugging,
                    sceneRendererDelegate: SceneRendererDelegate(showDebugging: showDebugging)
                )
            }
            
            Blur(style: .systemUltraThinMaterialDark)
                .opacity(currentMenuView == .settings ? 1.0 : 0.0)
            settingsView
                .opacity(currentMenuView == .settings ? 1.0 : 0.0)
        }
        .statusBar(hidden: true)
    }
    
    var settingsView: some View {
        VStack {
            Text("Настройки")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .foregroundColor(.white)
            
            Spacer()
            
            Button {
                showDebugging.toggle()
            } label: {
                HStack {
                    Image(systemName: showDebugging ? "checkmark.square.fill" : "square")
                    Text("Показывать отладку")
                }
                .foregroundColor(.white)
                .padding()
                .padding(.horizontal)
                .background(Color("Green Sheen"))
                .cornerRadius(10)
            }
            
            Spacer()
            
            Button {
                currentMenuView = .none
            } label: {
                HStack {
                    Text("Готово")
                        .fontWeight(.heavy)
                }
                .padding()
                .padding(.horizontal)
                .background(Color("Green Sheen"))
                .cornerRadius(10)
            }
            .buttonStyle(.plain)
        }
        .padding(50)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cornerRadius(15)
    }
}
struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style = .systemMaterial
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

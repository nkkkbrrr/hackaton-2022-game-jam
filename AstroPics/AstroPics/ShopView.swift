//
//  ShopView.swift
//  AstroPics
//
//  Created by Никита on 30.06.2022.
//

import SwiftUI

class StoreItem: Equatable {
    let title: String
    let systemImage: String
    let price: Int
    
    init(title: String, systemImage: String, price: Int) {
        self.title = title
        self.systemImage = systemImage
        self.price = price
    }
    
    static func == (lhs: StoreItem, rhs: StoreItem) -> Bool {
        lhs.title == rhs.title
    }
}

struct ShopView: View {
    @Binding var currentGameState: ContentView.CurrentGameState
    
    @AppStorage("money-amount") var moneyAmount: Int = 1000
    @AppStorage("night-vision-bought") var nightVisionBought: Bool = false
    @AppStorage("night-vision-is-on") var nightVisionIsOn: Bool = false
    
    @State var selectedItem: StoreItem? = nil
    let nightVision: StoreItem = StoreItem(title: "Ночное зрение", systemImage: "eye", price: 100)
    
    var body: some View {
        VStack {
            Text("Земной магазин")
                .font(.title)
                .fontWeight(.heavy)
                .padding(.top)
            
            Text("Тут вы можете улучшить своего робота")
            
            Text("Баланс: \(moneyAmount)")
                .padding(.top, 5)
            
            Spacer()
            
            
            #warning("а если куплен???????")
            Button {
                selectedItem = nightVision
            } label: {
                StoreItemView(selectedItem: $selectedItem, storeItem: nightVision)
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            Button {
                if selectedItem == nightVision {
                    if nightVisionBought {
                        nightVisionIsOn.toggle()
                    } else {
                        nightVisionBought = true
                        nightVisionIsOn = true
                    }
                }
                if selectedItem != nightVision || !nightVisionBought {
                    if let selectedItem = selectedItem {
                        moneyAmount -= selectedItem.price
                    }
                }
            } label: {
                HStack {
                    Image("cart")
                    
                    if let selectedItem = selectedItem {
                        if selectedItem == nightVision && nightVisionBought {
                            if nightVisionIsOn {
                                HStack {
                                    Image(systemName: "checkmark.square.fill")
                                    Text("Включено")
                                }
                            } else {
                                HStack {
                                    Image(systemName: "xmark.app")
                                    Text("Выключено")
                                }
                            }
                        } else {
                            Text("Купить за \(selectedItem.price)")
                                .fontWeight(.heavy)
                        }
                    } else {
                        Text("Для покупки выберете предмет")
                            .fontWeight(.heavy)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("Green Sheen"))
                .cornerRadius(10)
                .disabled(selectedItem == nil || selectedItem!.price < moneyAmount)
            }
            .buttonStyle(.plain)
            
            Button {
                currentGameState = .map
            } label: {
                HStack {
                    Image("checkmark")
                    Text("Готово")
                        .fontWeight(.heavy)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("Green Sheen"))
                .cornerRadius(10)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(Color("Independence"))
    }
}

struct StoreItemView: View {
    @Binding var selectedItem: StoreItem?
    let storeItem: StoreItem
    
    var body: some View {
        HStack {
            Image(systemName: storeItem.systemImage)
            Text(storeItem.title)
            
            Spacer()
            
            Text("Цена: \(storeItem.price)")
        }
        .padding()
        .background(Color.white.opacity(selectedItem == storeItem ? 0.5 : 0.1))
        .cornerRadius(10)
    }
}

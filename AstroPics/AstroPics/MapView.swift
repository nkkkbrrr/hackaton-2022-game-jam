//
//  MapView.swift
//  AstroPics
//
//  Created by Никита on 30.06.2022.
//

import SwiftUI

enum Planet {
    case earth, unknown
}

struct MapView: View {
    @Binding var currentGameState: ContentView.CurrentGameState
    @State var selectedPlanet: Planet = .unknown
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                if geometry.size.width > geometry.size.height {
                    HStack {
                        HorizontalPlanetPickerView(selectedPlanet: $selectedPlanet)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    VStack {
                        VerticalPlanetPickerView(selectedPlanet: $selectedPlanet)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                Button {
                    switch selectedPlanet {
                        case .earth:
                            currentGameState = .shop
                        case .unknown:
                            currentGameState = .game
                    }
                } label: {
                    Text("Отправиться")
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal)
                        .background(Color("Green Sheen"))
                        .cornerRadius(10)
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
    }
}

private struct VerticalPlanetPickerView: View {
    @Binding var selectedPlanet: Planet
    
    
    var body: some View {
        VStack {
            PlanetView(planetName: "???")
                .frame(width: 175)
                .padding(.vertical)
            
            dashedLine
            
            Button {
                selectedPlanet = .unknown
            } label: {
                ZStack {
                    PlanetView(planetName: "Неизвестная планета")
                        .frame(width: 175)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(selectedPlanet == .unknown ? .white.opacity(0.25) : .clear)
                        )
                }
            }
            .buttonStyle(.plain)
            
            dashedLine
            
            Button {
                selectedPlanet = .earth
            } label: {
                ZStack {
                    PlanetView(planetName: "Земля")
                        .frame(width: 175)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(selectedPlanet == .earth ? .white.opacity(0.25) : .clear)
                        )
                }
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var dashedLine: some View {
        VStack {
            ForEach(0..<3) { _ in
                Capsule()
                    .frame(width: 5, height: 10)
                    .foregroundColor(.white)
            }
        }
    }
}

private struct HorizontalPlanetPickerView: View {
    @Binding var selectedPlanet: Planet
    
    var body: some View {
        HStack {
            Button {
                selectedPlanet = .earth
            } label: {
                ZStack {
                    PlanetView(planetName: "Земля")
                        .frame(width: 175)
                        .padding(.vertical)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(selectedPlanet == .earth ? .white.opacity(0.25) : .clear)
                        )
                }
            }
            .buttonStyle(.plain)
            
            dashedLine
            
            Button {
                selectedPlanet = .unknown
            } label: {
                ZStack {
                    PlanetView(planetName: "Неизвестная планета")
                        .frame(width: 175)
                        .padding(.vertical)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(selectedPlanet == .unknown ? .white.opacity(0.25) : .clear)
                        )
                }
            }
            .buttonStyle(.plain)
            
            dashedLine
            
            PlanetView(planetName: "???")
                .frame(width: 175)
                .padding(.vertical)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var dashedLine: some View {
        HStack {
            ForEach(0..<3) { _ in
                Capsule()
                    .frame(width: 10, height: 5)
                    .foregroundColor(.white)
            }
        }
    }
}

private struct PlanetView: View {
    let planetName: String
    
    var body: some View {
        VStack {
            Image(planetName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 75, height: 75)
            
            Text(planetName)
                .font(.caption)
                .fontWeight(.black)
        }
        .padding(.vertical)
    }
}

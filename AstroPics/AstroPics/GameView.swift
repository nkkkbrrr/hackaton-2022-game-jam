//
//  GameView.swift
//  Astropics
//
//  Created by Никита on 28.06.2022.
//

import SwiftUI
import SceneKit

class SceneRendererDelegate: NSObject, SCNSceneRendererDelegate {
    var renderer: SCNSceneRenderer?
    var onEachFrame: (() -> ())? = nil
    let showSDebugging: Bool
    
    init(showDebugging: Bool) {
        self.showSDebugging = showDebugging
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if self.renderer == nil {
            self.renderer = renderer
        }
        
        onEachFrame?()
        if showSDebugging {
            self.renderer?.showsStatistics = true
        }
    }
}

struct GameView: View {
    // menu ui
    @Binding var currentGameState: ContentView.CurrentGameState
    @Binding var currentMenuView: ContentView.CurrentMenuView
    @State var showMapMenu: Bool = false
    
    // settings
    @Binding var showDebugging: Bool
    
    // sceneRenderer
    let sceneRendererDelegate: SceneRendererDelegate
    var scene: SCNScene = SCNScene(named: "MainScene.scn")!
    
    // robot
    @State var gestureVector: SCNVector3 = SCNVector3()
    @State var currentWalkingRobotFrame: Int = 0
    @State var imageCaptured: Bool = false
    
    var body: some View {
        ZStack {
            SceneView(
                scene: scene,
                pointOfView: cameraNode,
                delegate: sceneRendererDelegate
            )
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    if showMapMenu {
                        Button {
                            currentGameState = .map
                        } label: {
                            HStack {
                                Image(systemName: "map")
                                Text("Отправиться в путешествие")
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical)
                            .background(Color("Independence"))
                            .cornerRadius(15)
                        }
                        .transition(.move(edge: .top))
                    } else {
                        Spacer()
                    }
                    
                    Button {
                        currentGameState = .mainMenu
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                            .rotationEffect(Angle(degrees: 90))
                            .padding()
                            .background(Color("Independence"))
                            .cornerRadius(15)
                    }
                }
                .padding()
                .animation(.easeInOut, value: showMapMenu)
                
                Spacer()
                
                if imageCaptured {
                    VStack {
                        Text("Вы сделали снимок")
                            .fontWeight(.heavy)
                        
                        Button {
                            imageCaptured = false
                        } label: {
                            Text("Ура")
                                .padding()
                                .padding(.horizontal)
                                .background(Color("Green Sheen"))
                                .cornerRadius(15)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding()
                    .background(Color("Independence"))
                    .cornerRadius(15)
                }
                
                Spacer()
                
                Button {
                    imageCaptured = true
                } label: {
                    HStack {
                        Image(systemName: "camera.shutter.button")
                        Text("Сделать снимок")
                    }
                    .padding()
                    .background(Color("Independence"))
                    .cornerRadius(15)
                }
                .padding(.bottom, showDebugging ? 150 : 15)
            }
        }
        .onAppear {
            if !UserDefaults.standard.bool(forKey: "night-vision-is-on") {
                nightVisionNode.isHidden = true
            }
        }
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    let normalizedVector = normalize(
                        SIMD2(
                            x: gesture.location.x - gesture.startLocation.x,
                            y: gesture.location.y - gesture.startLocation.y
                        )
                    )
                    
                    gestureVector = SCNVector3(
                        x: Float(normalizedVector.x)/5,
                        y: 0,
                        z: Float(normalizedVector.y)/5
                    )
                    
                    robotFlashlightNode.eulerAngles.y = atan2(gestureVector.z, gestureVector.x) - .pi/2
                    
                    if CGPointDistance(from: spaceshipNode.presentation.position, to: robotNode.presentation.position) < 3 {
                        showMapMenu = true
                    } else {
                        showMapMenu = false
                    }
                }
                .onEnded { _ in
                    gestureVector = SCNVector3()
                    
                    robotNode.childNode(withName: "body", recursively: true)?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "robot-front-still")!
                }
        )
        .onDisappear {
          sceneRendererDelegate.onEachFrame = nil
        }
        .onAppear {
            sceneRendererDelegate.onEachFrame = {
                let robotPosition: SCNVector3 = robotNode.presentation.position
                
                let cameraDamping: Float = 0.3
                let selfieStickPosition: SCNVector3 = selfieStickNode.position
                
                selfieStickNode.position = SCNVector3(
                    x: selfieStickPosition.x * (1 - cameraDamping) + robotPosition.x * cameraDamping,
                    y: selfieStickPosition.y * (1 - cameraDamping) + robotPosition.y * cameraDamping,
                    z: selfieStickPosition.z * (1 - cameraDamping) + robotPosition.z * cameraDamping
                )
                
                robotNode.physicsBody?.velocity += gestureVector
                
                if gestureVector.x != 0 && gestureVector.z != 0 {
                    animateRobotWalk()
                }
            }
        }
    }
    
    func CGPointDistanceSquared(from: SCNVector3, to: SCNVector3) -> Float {
        return (from.x - to.x) * (from.x - to.x) + (from.z - to.z) * (from.z - to.z)
    }

    func CGPointDistance(from: SCNVector3, to: SCNVector3) -> Float {
        return sqrt(CGPointDistanceSquared(from: from, to: to))
    }
}

// camera
extension GameView {
    var cameraNode: SCNNode? {
        scene.rootNode.childNode(
            withName: "camera",
            recursively: true
        )
    }
    
    var selfieStickNode: SCNNode {
        scene.rootNode.childNode(
            withName: "selfieStick",
            recursively: true
        )!
    }
}

// robot
extension GameView {
    var robotNode: SCNNode {
        scene.rootNode.childNode(
            withName: "robot",
            recursively: true
        )!
    }
    
    var robotFlashlightNode: SCNNode {
        scene.rootNode.childNode(
            withName: "flashlight",
            recursively: true
        )!
    }
    
    func animateRobotWalk() {
        switch currentWalkingRobotFrame {
            case 0: robotNode.childNode(withName: "body", recursively: true)?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "robot-front-moving-1")!
                currentWalkingRobotFrame += 1
            case 10:  robotNode.childNode(withName: "body", recursively: true)?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "robot-front-moving-2")!
                currentWalkingRobotFrame += 1
                
            case 19: currentWalkingRobotFrame = 0
            default: currentWalkingRobotFrame += 1
        }
    }
    
    var nightVisionNode: SCNNode {
        scene.rootNode.childNode(
            withName: "nightVision",
            recursively: true
        )!
    }
}

// robot
extension GameView {
    var spaceshipNode: SCNNode {
        scene.rootNode.childNode(
            withName: "spaceship",
            recursively: true
        )!
    }
}

private func += (left: inout SCNVector3, right: SCNVector3) {
    left = SCNVector3(x: left.x + right.x, y: left.y + right.y, z: left.z + right.z)
}

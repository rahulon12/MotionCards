//
//  ContentView.swift
//  MotionCards
//
//  Created by Rahul on 1/25/24.
//

import SwiftUI

struct ContentView: View {
    @State private var senseMotion = true
    @State private var oneCardShown = false
    @State private var motionManager = MotionManager()
    @State private var pitch = 0.0
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                ForEach(colors.indices, id: \.self) { colorIndex in
                    RoundedRectangle(cornerRadius: 20.0)
                        .fill(colors[colorIndex].gradient)
                        .offset(y: CGFloat(colorIndex) * cardOffset)
                        .shadow(radius: 12, x: 0, y: oneCardShown ? 0 : -5)
                        .rotation3DEffect(
                            .degrees(oneCardShown ? 0 : 20),
                            axis: (1, 0, 0),
                            perspective: 0.5
                        )
                        .offset(y: colorIndex != 0 && oneCardShown ? geo.size.height + 10 : 0)
                        .animation(.spring.delay(Double(colors.count - colorIndex) * 0.05), value: oneCardShown)
                        .padding()
                        .onTapGesture {
                            colors.swapAt(0, colorIndex)
                        }
                }
                
                
                HStack {
                    Button(oneCardShown ? "All Cards" : "Top Card", action: switchState)
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        .foregroundStyle(.ultraThickMaterial)
                    
                    Spacer()
                    
                    Toggle(isOn: $senseMotion, label: {
                        Text("Motion")
                    })
                    .fixedSize(horizontal: true, vertical: true)
                    .padding(4)
                    .padding(.horizontal, 2)
                    .background(.ultraThinMaterial)
                    .cornerRadius(10.0)
                }
                .padding([.bottom, .horizontal])
            }
            .overlay(alignment: .top) {
                
            }
        }
        .onAppear {
            motionManager.handler = updateMotion
        }
        .onChange(of: self.pitch) { oldPitch, newPitch in
            if senseMotion {
                if oldPitch < 0.5, newPitch > 0.5 {
                    oneCardShown = true
                } else if oldPitch > 0.5, newPitch < 0.5 {
                    oneCardShown = false
                }
            }
        }
        .animation(.spring, value: colors)
    }
    
    private func updateMotion(pitch: Double, roll: Double, yaw: Double) {
        self.pitch = pitch
    }
    
    private func switchState() {
        oneCardShown.toggle()
    }
    
    private let cardOffset: CGFloat = 80.0
    @State private var colors: [Color] = [
        .red,
        .blue,
        .purple,
        .yellow,
        .green,
        .orange,
        .accentColor,
        .pink
    ]
}

#Preview {
    ContentView()
}

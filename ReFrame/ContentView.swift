//
//  ContentView.swift
//  ReFrame
//
//  Created by Kiera Castner on 2/20/26.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showMicro = false
    @State private var showPanic = false
    @State private var showSTOP = false
    @State private var showRumination = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                CalmingBackground() // Using our new theme!
                
                VStack(spacing: 25) {
                    Text("ReFrame")
                        .font(.system(.largeTitle, design: .rounded))
                        .bold()
                        .foregroundStyle(.white)
                        .padding(.top, 40)
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            ProtocolCard(title: "Panic Spike Reset") { showPanic = true }
                            ProtocolCard(title: "Rumination Interrupt") { showRumination = true }
                            ProtocolCard(title: "STOP Protocol") { showSTOP = true }
                            ProtocolCard(title: "90-Second Micro Reset") { showMicro = true }
                        }
                        .padding()
                    }
                }
            }
            // Your existing .navigationDestination modifiers stay exactly the same here
            .navigationDestination(isPresented: $showPanic) { PMRSessionView(protocol: ResetLibrary.panicSpike) }
            .navigationDestination(isPresented: $showRumination) { PMRSessionView(protocol: ResetLibrary.ruminationInterrupt) }
            .navigationDestination(isPresented: $showSTOP) { PMRSessionView(protocol: ResetLibrary.stopProtocol) }
            .navigationDestination(isPresented: $showMicro) { PMRSessionView(protocol: ResetLibrary.microPMR) }
        }
    }


    struct ProtocolCard: View {
        let title: String
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                HStack {
                    Text(title)
                        .font(.headline)
                    Spacer()
                    Image(systemName: "arrow.right.circle.fill")
                        .opacity(0.5)
                }
                .padding(.vertical, 20)
                .padding(.horizontal)
                .background(.white.opacity(0.08))
                .cornerRadius(20)
                .foregroundStyle(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white.opacity(0.1), lineWidth: 1)
                )
            }
        }
    }
}

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
            VStack(spacing: 30) {
                
                Text("ReFrame")
                    .font(.largeTitle)
                    .bold()
                
                Button("Panic Spike Reset") {
                    showPanic = true
                }
                .buttonStyle(.borderedProminent)
                
                Button("Rumination Loop Interrupt") {
                    showRumination = true
                }
                .buttonStyle(.borderedProminent)
                
                Button("STOP Protocol") {
                    showSTOP = true
                }
                .buttonStyle(.borderedProminent)
                
                Button("90-Second Micro Reset") {
                    showMicro = true
                }
                .buttonStyle(.borderedProminent)
                
            }
            .navigationDestination(isPresented: $showPanic) {
                PMRSessionView(protocol: ResetLibrary.panicSpike)
            }
            .navigationDestination(isPresented: $showRumination) {
                PMRSessionView(protocol: ResetLibrary.ruminationInterrupt)
            }
            .navigationDestination(isPresented: $showSTOP) {
                PMRSessionView(protocol: ResetLibrary.stopProtocol)
            }
            .navigationDestination(isPresented: $showMicro) {
                PMRSessionView(protocol: ResetLibrary.microPMR)
            }

        }
    }
}

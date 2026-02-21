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
                
                Button("90-Second Micro Reset") {
                    showMicro = true
                }
                .buttonStyle(.borderedProminent)
                
            }
            .navigationDestination(isPresented: $showMicro) {
                PMRSessionView(protocol: ResetLibrary.microPMR)
            }
            .navigationDestination(isPresented: $showPanic) {
                PMRSessionView(protocol: ResetLibrary.panicSpike)
            }
        }
    }
}

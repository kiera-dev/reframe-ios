//
//  ContentView.swift
//  ReFrame
//
//  Created by Kiera Castner on 2/18/26.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = PMRViewModel()
    
    var body: some View {
        VStack(spacing: 30) {
            
            Text(viewModel.currentInstruction)
                .font(.title2)
                .multilineTextAlignment(.center)
            
            if viewModel.isRunning {
                Button("Stop") {
                    viewModel.stopSession()
                }
            } else {
                Button("Start PMR") {
                    viewModel.startSession()
                }
            }
        }
        .padding()
    }
}


#Preview {
    ContentView()
}

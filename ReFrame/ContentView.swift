//
//  ContentView.swift
//  ReFrame
//
//  Created by Kiera Castner on 2/20/26.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showPMR = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                
                Text("ReFrame")
                    .font(.largeTitle)
                    .bold()
                
                Button("90-Second Micro Reset") {
                    showPMR = true
                }
                .buttonStyle(.borderedProminent)
                
            }
            .navigationDestination(isPresented: $showPMR) {
                PMRSessionView()
            }
        }
    }
}

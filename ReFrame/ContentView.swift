//
//  ContentView.swift
//  ReFrame
//
//  Created by Kiera Castner on 2/18/26.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = PMRViewModel()
    @State private var animatePulse = false
    @State private var pulseAmount: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 40) {
            
            Text(viewModel.currentInstruction)
                .font(.title2)
                .multilineTextAlignment(.center)
            
            if viewModel.isRunning {
                
                Circle()
                    .fill(colorForStep(viewModel.currentStepType))
                    .overlay(
                        Circle()
                            .stroke(Color.primary.opacity(0.2), lineWidth: 2)
                    )
                    .frame(width: 120, height: 120)
                    .scaleEffect(scaleForStep(viewModel.currentStepType))
                    .opacity(opacityForStep(viewModel.currentStepType))
                    .animation(
                        .easeInOut(duration: animationDuration(viewModel.currentStepType)),
                        value: viewModel.currentStepType
                    )

                
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
    
    func scaleForStep(_ type: StepType) -> CGFloat {
        switch type {
        case .inhale: return 1.3
        case .exhale: return 0.8
        case .tense: return 0.75
        case .release: return 1.1
        case .neutral: return 1.05
        }
    }

    func opacityForStep(_ type: StepType) -> Double {
        switch type {
        case .inhale: return 0.55
        case .exhale: return 0.45
        case .tense: return 0.65
        case .release: return 0.5
        case .neutral: return 0.5
        }
    }

    func colorForStep(_ type: StepType) -> Color {
        switch type {
        case .inhale, .exhale:
            return Color.accentColor.opacity(0.35)
        case .tense:
            return Color.orange.opacity(0.4)
        case .release:
            return Color.green.opacity(0.35)
        case .neutral:
            return Color.gray.opacity(0.25)
        }
    }

    func animationDuration(_ type: StepType) -> Double {
        switch type {
        case .inhale: return 4
        case .exhale: return 6
        case .tense: return 4
        case .release: return 3
        case .neutral: return 2.5
        }
    }


}



#Preview {
    ContentView()
}

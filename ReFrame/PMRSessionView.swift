//
//  PMRSessionView.swift
//  ReFrame
//
//  Created by Kiera Castner on 2/18/26.
//

import SwiftUI

struct PMRSessionView: View {
    
    @StateObject private var viewModel: PMRViewModel
    
    // NEW initializer
    init(protocol: ResetProtocol) {
        _viewModel = StateObject(
            wrappedValue: PMRViewModel(protocol: `protocol`)
        )
    }
    
    var body: some View {
        ZStack {
            CalmingBackground()
            
            VStack(spacing: 50) {
                VStack(spacing: 12) {
                    Text(viewModel.currentInstruction)
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                        .animation(.easeInOut, value: viewModel.currentInstruction)
                    
                    if let helper = viewModel.currentHelperText {
                        Text(helper)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white.opacity(0.7))
                            .padding(.horizontal, 30)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }
                }
                .frame(height: 120) // Keeps text from jumping around
                
                // --- THE NEW ANIMATED GLOWING CIRCLE ---
                ZStack {
                    if viewModel.isRunning && viewModel.currentStepType.showsCircle {
                        // Background Glow
                        Circle()
                            .fill(colorForStep(viewModel.currentStepType))
                            .frame(width: 180, height: 180)
                            .blur(radius: 40)
                            .scaleEffect(scaleForStep(viewModel.currentStepType) * 1.2)
                        
                        // Main Circle
                        Circle()
                            .fill(.ultraThinMaterial) // Makes it look like frosted glass
                            .overlay(
                                Circle()
                                    .stroke(colorForStep(viewModel.currentStepType).opacity(0.5), lineWidth: 3)
                            )
                            .frame(width: 160, height: 160)
                            .scaleEffect(scaleForStep(viewModel.currentStepType))
                    }
                }
                .frame(height: 200)
                .animation(.easeInOut(duration: animationDuration(viewModel.currentStepType)), value: viewModel.currentStepType)
                
                // --- BUTTONS ---
                VStack(spacing: 20) {
                    if viewModel.isRunning {
                        if viewModel.isManualMode {
                            Button("Tap to Continue") { viewModel.nextStep() }
                                .buttonStyle(.bordered)
                                .tint(.white)
                                .controlSize(.large)
                        }
                        
                        Button("End Session") { viewModel.stopSession() }
                            .foregroundStyle(.white.opacity(0.5))
                            .font(.subheadline)
                    } else {
                        Button("Begin Reset") { viewModel.startSession() }
                            .buttonStyle(.borderedProminent)
                            .tint(.softTeal)
                            .controlSize(.large)
                            .clipShape(Capsule())
                    }
                }
            }
            .padding()
        }
    }
    
    // MARK: - Animation Helpers
    
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
    PMRSessionView(protocol: ResetLibrary.microPMR)
}

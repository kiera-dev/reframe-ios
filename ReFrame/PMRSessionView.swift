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
                        .id(viewModel.currentInstruction)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .offset(y: 10)),
                            removal: .opacity.combined(with: .offset(y: -10))
                        ))
                    
                    if let helper = viewModel.currentHelperText {
                        Text(helper)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.white.opacity(0.7))
                            .padding(.horizontal, 30)
                            .id(helper)
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .offset(y: 8)),
                                removal: .opacity.combined(with: .offset(y: -8))
                            ))
                    }
                }
                .frame(height: 120)
                
                // --- ANIMATED GLOWING CIRCLE ---
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
                            .fill(.ultraThinMaterial)
                            .overlay(
                                Circle()
                                    .stroke(colorForStep(viewModel.currentStepType).opacity(0.5), lineWidth: 3)
                            )
                            .frame(width: 160, height: 160)
                            .scaleEffect(scaleForStep(viewModel.currentStepType))
                    }
                }
                .frame(height: 200)
                .animation(animationForStep(viewModel.currentStepType), value: viewModel.currentStepType)
                
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
    
    // Per-phase animation curves: inhale/exhale use a sinusoidal ease that lingers
    // at both extremes (feels like a real breath); tense snaps in; release bounces out.
    func animationForStep(_ type: StepType) -> Animation {
        switch type {
        case .inhale:
            return .timingCurve(0.37, 0, 0.63, 1, duration: 4)
        case .exhale:
            return .timingCurve(0.37, 0, 0.63, 1, duration: 6)
        case .tense:
            return .easeIn(duration: 4)
        case .release:
            return .spring(response: 3, dampingFraction: 0.72)
        case .neutral:
            return .easeInOut(duration: 2.5)
        }
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
}

#Preview {
    PMRSessionView(protocol: ResetLibrary.microPMR)
}

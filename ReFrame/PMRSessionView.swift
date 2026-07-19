//
//  PMRSessionView.swift
//  ReFrame
//
//  Created by Kiera Castner on 2/18/26.
//

import SwiftUI

struct PMRSessionView: View {
    
    @StateObject private var viewModel: PMRViewModel
    
    @AppStorage("appTheme") private var themeRaw = AppTheme.twilight.rawValue
    private var theme: AppTheme { AppTheme(rawValue: themeRaw) ?? .twilight }
    
    // NEW initializer
    init(protocol: ResetProtocol) {
        _viewModel = StateObject(
            wrappedValue: PMRViewModel(protocol: `protocol`)
        )
    }
    
    var body: some View {
        ZStack {
            CalmingBackground(theme: theme)
            
            VStack(spacing: 50) {
                VStack(spacing: 14) {
                    Text(viewModel.currentInstruction)
                        .font(.system(size: 26, weight: .light, design: .rounded))
                        .tracking(0.5)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(theme.textPrimary)
                        .id(viewModel.currentInstruction)
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .offset(y: 14)),
                            removal: .opacity.combined(with: .offset(y: -10))
                        ))
                    
                    if let helper = viewModel.currentHelperText {
                        Text(helper)
                            .font(.system(.callout, design: .rounded))
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .foregroundStyle(theme.textSecondary)
                            .padding(.horizontal, 30)
                            .id(helper)
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .offset(y: 10)),
                                removal: .opacity.combined(with: .offset(y: -8))
                            ))
                    }
                }
                .frame(height: 130)
                
                // --- BREATHING ORB ---
                ZStack {
                    if viewModel.isRunning && viewModel.currentStepType.showsCircle {
                        let orb = theme.orbColor(for: viewModel.currentStepType)
                        let scale = scaleForStep(viewModel.currentStepType)
                        
                        // Soft outer glow
                        Circle()
                            .fill(RadialGradient(
                                colors: [orb.opacity(0.55), orb.opacity(0)],
                                center: .center,
                                startRadius: 5,
                                endRadius: 120
                            ))
                            .frame(width: 240, height: 240)
                            .scaleEffect(scale * 1.25)
                        
                        // Ripple rings — scale at slightly different rates for a
                        // water-ripple feel
                        Circle()
                            .stroke(orb.opacity(0.15), lineWidth: 1)
                            .frame(width: 200, height: 200)
                            .scaleEffect(scale * 1.18)
                        
                        Circle()
                            .stroke(orb.opacity(0.30), lineWidth: 1)
                            .frame(width: 180, height: 180)
                            .scaleEffect(scale * 1.08)
                        
                        // Main orb: frosted glass with a glowing core
                        Circle()
                            .fill(.ultraThinMaterial)
                            .overlay(
                                Circle().fill(RadialGradient(
                                    colors: [orb.opacity(0.35), orb.opacity(0)],
                                    center: .center,
                                    startRadius: 5,
                                    endRadius: 80
                                ))
                            )
                            .overlay(
                                Circle().stroke(orb.opacity(0.5), lineWidth: 1.5)
                            )
                            .frame(width: 160, height: 160)
                            .scaleEffect(scale)
                    }
                }
                .frame(height: 240)
                .animation(animationForStep(viewModel.currentStepType), value: viewModel.currentStepType)
                
                // --- BUTTONS ---
                VStack(spacing: 22) {
                    if viewModel.isRunning {
                        if viewModel.isManualMode {
                            Button { viewModel.nextStep() } label: {
                                Text("Continue")
                                    .font(.system(.body, design: .rounded))
                                    .fontWeight(.medium)
                                    .tracking(1)
                                    .foregroundStyle(theme.textPrimary)
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 44)
                                    .background(.ultraThinMaterial, in: Capsule())
                                    .overlay(Capsule().stroke(theme.cardStroke, lineWidth: 1))
                            }
                            .buttonStyle(.plain)
                        }
                        
                        Button("End Session") { viewModel.stopSession() }
                            .font(.system(.footnote, design: .rounded))
                            .foregroundStyle(theme.textSecondary.opacity(0.7))
                    } else {
                        Button { viewModel.startSession() } label: {
                            Text("Begin Reset")
                                .font(.system(.body, design: .rounded))
                                .fontWeight(.medium)
                                .tracking(1)
                                .foregroundStyle(theme.textPrimary)
                                .padding(.vertical, 16)
                                .padding(.horizontal, 52)
                                .background(theme.accent.opacity(theme == .twilight ? 0.35 : 0.40), in: Capsule())
                                .background(.ultraThinMaterial, in: Capsule())
                                .overlay(Capsule().stroke(theme.accent.opacity(0.5), lineWidth: 1))
                        }
                        .buttonStyle(.plain)
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
}

#Preview {
    PMRSessionView(protocol: ResetLibrary.microPMR)
}

//PMRViewModel.swift

import Foundation
import Combine
import SwiftUI
import UIKit

class PMRViewModel: ObservableObject {
    
    @Published var currentInstruction: String = "Ready to begin?"
    @Published var isRunning = false
    @Published var currentStepType: StepType = .neutral
    @Published var isManualMode = false
    @Published var currentHelperText: String? = nil
    
    private let engine = ResetEngine()
    private let resetProtocol: ResetProtocol
    private let haptic = UIImpactFeedbackGenerator(style: .soft)
    
    init(protocol: ResetProtocol) {
        self.resetProtocol = `protocol`
        self.isManualMode = `protocol`.isManual
        
        engine.onStepChange = { [weak self] step in
            DispatchQueue.main.async {
                if step != nil {
                    self?.haptic.impactOccurred(intensity: 0.6)
                    self?.haptic.prepare()
                }
                // Slow, soft spring so text surfaces gently rather than snapping
                withAnimation(.spring(response: 0.9, dampingFraction: 0.85)) {
                    self?.currentInstruction = step?.instruction ?? ""
                    self?.currentStepType = step?.type ?? .neutral
                    self?.currentHelperText = step?.helperText
                }
            }
        }
        
        engine.onSessionComplete = { [weak self] in
            DispatchQueue.main.async {
                // A session only reaches here by running to the end — early
                // "End Session" taps go through stopSession() and don't count.
                SessionStore.shared.recordCompletion()
                withAnimation(.spring(response: 0.9, dampingFraction: 0.85)) {
                    self?.isRunning = false
                    self?.currentInstruction = "Session complete."
                    self?.currentHelperText = nil
                    self?.currentStepType = .neutral
                }
            }
        }
    }
    
    func startSession() {
        guard !isRunning else { return }
        isRunning = true
        haptic.prepare()
        engine.start(with: resetProtocol)
    }
    
    func nextStep() {
        engine.nextStep()
    }
    
    func stopSession() {
        isRunning = false
        engine.stop()
        currentInstruction = "Ready to begin?"
        currentHelperText = nil
        currentStepType = .neutral
    }
    
    deinit {
        print("PMRViewModel deallocated")
    }
}

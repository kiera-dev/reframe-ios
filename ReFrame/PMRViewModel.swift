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
                self?.isRunning = false
                self?.currentInstruction = "Session complete."
                self?.currentStepType = .neutral
            }
        }
    }
    
    func startSession() {
        guard !isRunning else { return }
        isRunning = true
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

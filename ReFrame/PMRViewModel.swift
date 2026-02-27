//PMRViewModel.swift

import Foundation
import Combine
import SwiftUI

class PMRViewModel: ObservableObject {
    
    @Published var currentInstruction: String = "Ready to begin?"
    @Published var isRunning = false
    @Published var currentStepType: StepType = .neutral
    @Published var isManualMode = false
    @Published var currentHelperText: String? = nil
    
    private let engine = ResetEngine()
    private let resetProtocol: ResetProtocol
    
    init(protocol: ResetProtocol) {
        self.resetProtocol = `protocol`
        self.isManualMode = `protocol`.isManual
        
        engine.onStepChange = { [weak self] step in
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 0.95)) {
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

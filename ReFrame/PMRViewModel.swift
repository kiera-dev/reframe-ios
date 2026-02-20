//
//  PMRViewModel.swift
//  ReFrame
//
//  Created by Kiera Castner on 2/18/26.
//

import Foundation
import Combine


class PMRViewModel: ObservableObject {
    
    @Published var currentInstruction: String = "Ready to begin?"
    @Published var isRunning = false
    @Published var currentStepType: StepType = .neutral

    
    private let engine = ResetEngine()
    
    init() {
        engine.onStepChange = { [weak self] step in
            DispatchQueue.main.async {
                self?.currentInstruction = step?.instruction ?? ""
                self?.currentStepType = step?.type ?? .neutral
            }
        }
        
        engine.onSessionComplete = { [weak self] in
            DispatchQueue.main.async {
                self?.isRunning = false
                self?.currentInstruction = "Session complete."
            }
        }
    }
    
    func startSession() {
        guard !isRunning else { return }
        isRunning = true
        engine.start(with: ResetLibrary.microPMR)
    }
    
    func stopSession() {
        isRunning = false
        engine.stop()
    }
}

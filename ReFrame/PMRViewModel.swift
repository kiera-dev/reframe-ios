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
    
    private let engine = PMREngine()
    
    init() {
        engine.onStepChange = { [weak self] step in
            DispatchQueue.main.async {
                self?.currentInstruction = step?.instruction ?? ""
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
        isRunning = true
        engine.start()
    }
    
    func stopSession() {
        isRunning = false
        engine.stop()
    }
}

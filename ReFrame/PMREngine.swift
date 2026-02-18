//
//  PMRStep.swift
//  ReFrame
//
//


import Foundation

struct PMRStep {
    let instruction: String
    let duration: TimeInterval
}

class PMREngine {
    
    private(set) var steps: [PMRStep] = []
    private var currentIndex = 0
    private var timer: Timer?
    
    var onStepChange: ((PMRStep?) -> Void)?
    var onSessionComplete: (() -> Void)?
    
    init() {
        steps = [
            PMRStep(instruction: "Take a slow breath in.", duration: 5),
            PMRStep(instruction: "Gently tense your shoulders.", duration: 5),
            PMRStep(instruction: "Release your shoulders.", duration: 5),
            PMRStep(instruction: "Clench your fists softly.", duration: 5),
            PMRStep(instruction: "Release your hands.", duration: 5)
        ]
    }
    
    func start() {
        currentIndex = 0
        runStep()
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    private func runStep() {
        guard currentIndex < steps.count else {
            onSessionComplete?()
            return
        }
        
        let step = steps[currentIndex]
        onStepChange?(step)
        
        timer = Timer.scheduledTimer(withTimeInterval: step.duration, repeats: false) { _ in
            self.currentIndex += 1
            self.runStep()
        }
    }
}

//
//  PMREngine.swift
//  ReFrame
//
//


import Foundation

class ResetEngine {
    
    private var steps: [ResetStep] = []
    private var currentIndex = 0
    private var timer: Timer?
    
    var onStepChange: ((ResetStep?) -> Void)?
    var onSessionComplete: (() -> Void)?
    
    func start(with protocol: ResetProtocol) {
        stop()
        steps = `protocol`.steps
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
        
        timer = Timer(timeInterval: step.duration, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.currentIndex += 1
            self.runStep()
        }
        
        RunLoop.main.add(timer!, forMode: .common)
    }
}

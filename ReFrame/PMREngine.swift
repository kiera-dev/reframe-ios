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
    private var isManual = false
    
    var onStepChange: ((ResetStep?) -> Void)?
    var onSessionComplete: (() -> Void)?
    
    func start(with protocol: ResetProtocol) {
        stop()
        steps = `protocol`.steps
        isManual = `protocol`.isManual
        currentIndex = 0
        runStep()
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    func nextStep() {
        guard isManual else { return }
        currentIndex += 1
        runStep()
    }
    
    private func runStep() {

        // 🔥 Invalidate any existing timer first
        timer?.invalidate()
        timer = nil

        guard currentIndex < steps.count else {
            onSessionComplete?()
            return
        }

        let step = steps[currentIndex]
        onStepChange?(step)

        // Only schedule timer for automatic protocols with positive duration
        if !isManual && step.duration > 0 {
            timer = Timer(timeInterval: step.duration, repeats: false) { [weak self] _ in
                guard let self = self else { return }
                self.currentIndex += 1
                self.runStep()
            }

            if let timer = timer {
                RunLoop.main.add(timer, forMode: .common)
            }
        }
    }
    
    
    deinit {
        print("ResetEngine deallocated")
    }
}

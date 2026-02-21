import Foundation
import Combine

class PMRViewModel: ObservableObject {
    
    @Published var currentInstruction: String = "Ready to begin?"
    @Published var isRunning = false
    @Published var currentStepType: StepType = .neutral
    
    private let engine = ResetEngine()
    private let resetProtocol: ResetProtocol
    
    // Updated initializer
    init(protocol: ResetProtocol) {
        self.resetProtocol = `protocol`
        
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
                self?.currentStepType = .neutral
            }
        }
    }
    
    func startSession() {
        guard !isRunning else { return }
        isRunning = true
        engine.start(with: resetProtocol)   // Uses injected protocol
    }
    
    func stopSession() {
        isRunning = false
        engine.stop()
        currentInstruction = "Ready to begin?"
        currentStepType = .neutral
    }
}

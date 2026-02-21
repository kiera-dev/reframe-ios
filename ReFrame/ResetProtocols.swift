//
//  ResetProtocols.swift
//  ReFrame
//
//  Created by Kiera Castner on 2/18/26.
//

import Foundation

struct ResetLibrary {
    
    static let panicSpike = ResetProtocol(
        name: "Panic Spike Reset",
        steps: [
            ResetStep(
                instruction: "Stop. Sit or plant your feet.",
                duration: 4,
                type: .neutral
            ),
            ResetStep(
                instruction: "Look around and name 3 visible objects.",
                duration: 8,
                type: .neutral
            ),
            ResetStep(
                instruction: "Press your feet firmly into the ground.",
                duration: 6,
                type: .neutral
            ),
            ResetStep(
                instruction: "Inhale slowly.",
                duration: 4,
                type: .inhale
            ),
            ResetStep(
                instruction: "Exhale slowly.",
                duration: 6,
                type: .exhale
            ),
            ResetStep(
                instruction: "Gently tense your hands.",
                duration: 3,
                type: .tense
            ),
            ResetStep(
                instruction: "Release.",
                duration: 4,
                type: .release
            ),
            ResetStep(
                instruction: "One more slow breath.",
                duration: 6,
                type: .inhale
            ),
            ResetStep(
                instruction: "This will pass.",
                duration: 5,
                type: .neutral
            )
        ],
        isManual: true
    )
    
    static let microPMR = ResetProtocol(
        name: "90-Second Micro PMR",
        steps: [
            ResetStep(instruction: "Take a slow breath in.", duration: 4, type: .inhale),
            ResetStep(instruction: "Exhale slowly.", duration: 6, type: .exhale),
            ResetStep(instruction: "Gently tense your shoulders.", duration: 4, type: .tense),
            ResetStep(instruction: "Release.", duration: 4, type: .release),
            ResetStep(instruction: "Clench your hands softly.", duration: 4, type: .tense),
            ResetStep(instruction: "Release.", duration: 4, type: .release),
            ResetStep(instruction: "Press your feet into the ground.", duration: 5, type: .neutral),
            ResetStep(instruction: "Let everything soften.", duration: 5, type: .release),
            ResetStep(instruction: "One more slow breath.", duration: 6, type: .inhale)
        ],
        isManual: false
    )
    

}

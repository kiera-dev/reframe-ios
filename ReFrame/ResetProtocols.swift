//
//  ResetProtocols.swift
//  ReFrame
//
//  Created by Kiera Castner on 2/18/26.
//

import Foundation

struct ResetLibrary {
    
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
        ]
    )
}

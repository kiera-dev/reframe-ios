//
//  ResetModels.swift
//  ReFrame
//
//  Created by Kiera Castner on 2/18/26.
//

import Foundation


enum StepType {
    case inhale
    case exhale
    case tense
    case release
    case neutral
}

extension StepType {
    var showsCircle: Bool {
        switch self {
        case .inhale, .exhale, .tense, .release:
            return true
        case .neutral:
            return false
        }
    }
}

struct ResetStep {
    let instruction: String
    let duration: TimeInterval
    let type: StepType
    let helperText: String?

    init(
        instruction: String,
        duration: TimeInterval,
        type: StepType,
        helperText: String? = nil   // default value
    ) {
        self.instruction = instruction
        self.duration = duration
        self.type = type
        self.helperText = helperText
    }
}

struct ResetProtocol {
    let name: String
    let steps: [ResetStep]
    let isManual: Bool
}




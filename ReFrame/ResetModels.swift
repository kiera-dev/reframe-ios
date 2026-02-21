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

struct ResetStep {
    let instruction: String
    let duration: TimeInterval
    let type: StepType
}

struct ResetProtocol {
    let name: String
    let steps: [ResetStep]
    let isManual: Bool
}



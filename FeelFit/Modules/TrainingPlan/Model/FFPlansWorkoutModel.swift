//
//  FFPlansModel.swift
//  FeelFit
//
//  Created by Константин Малков on 06.11.2023.
//

import UIKit

struct PlanWorkoutModel: Codable, Hashable {
    let time: Int
    let muscle: String
    let location: String
    let equipment: String
    
    
    static func == (lhs: PlanWorkoutModel, rhs: PlanWorkoutModel) -> Bool {
        return lhs.equipment == rhs.equipment && lhs.muscle == rhs.muscle
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(muscle)
        hasher.combine(equipment)
    }
}

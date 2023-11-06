//
//  FFPlansCustomizedPlan.swift
//  FeelFit
//
//  Created by Константин Малков on 06.11.2023.
//

import UIKit

struct CustomPlanModel: Codable, Hashable  {
    
    let time: Int
    let muscle: String
    let equipment: String
    let fitnessLevel: String
    let fitnessGoals: String
    
    private enum CodingKeys: String, CodingKey {
        case time, muscle, equipment, fitnessLevel = "fitness_level", fitnessGoals = "fitness_goals"
    }
    
    
    static func == (lhs: CustomPlanModel, rhs: CustomPlanModel) -> Bool {
        return lhs.equipment == rhs.equipment && lhs.muscle == rhs.muscle
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(muscle)
        hasher.combine(equipment)
    }
}

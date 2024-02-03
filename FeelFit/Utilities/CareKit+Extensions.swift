//
//  CareKit+Extensions.swift
//  FeelFit
//
//  Created by Константин Малков on 03.02.2024.
//

import CareKit

extension OCKStore {
    func saveDataToCareKitStore(_ values: [HealthModelValue]) {
        guard let model = (values.first) else { return }
        let taskId = OCKLocalVersionID(model.identifier)
        let unit = values.first?.unit
        var outcomeValue = [OCKOutcomeValue]()
        for value in values {
            let outcomeValueStep = value.value as OCKOutcomeValueUnderlyingType
            outcomeValue.append(OCKOutcomeValue(outcomeValueStep, units: unit?.unitString))
        }
        let outcome = OCKOutcome(taskID: taskId, taskOccurrenceIndex: 0, values: outcomeValue)
        self.addOutcome(outcome) { result in
            switch result {
            case .success(_):
                print("Saved to OCKStore successfully")
            case .failure(_):
                print("Did not saved to OCKStore successfully")
            }
        }
    }
}

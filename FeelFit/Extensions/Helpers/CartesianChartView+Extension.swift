//
//  CartesianChartView+Extension.swift
//  FeelFit
//
//  Created by Константин Малков on 19.01.2024.
//

import UIKit
import CareKit

extension OCKCartesianChartView {
    func applyConfiguration(){
        applyDefaultStyle()
        
        let numberFormatter = NumberFormatter()
        
        numberFormatter.numberStyle = .none
        
        graphView.numberFormatter = numberFormatter
        graphView.yMinimum = 0
    }
    
    ///Function for display min and max Y for VO 2 Max 
    func setupCardioAxisY(){
        graphView.yMinimum = 10
        graphView.yMaximum = 70
    }
    
    func applyDefaultStyle(){
        headerView.detailLabel.textColor = FFResources.Colors.detailTextColor
        contentStackView.distribution = .fillProportionally
    }
    
    func applyHeaderStyle(){
        applyDefaultStyle()
        
        customStyle = ChartHeaderStyle()
    }
}

struct ChartHeaderStyle: OCKStyler {
    var appearance: OCKAppearanceStyler {
        NoShadowAppearance()
    }
}

struct NoShadowAppearance: OCKAppearanceStyler {
    var shadowOpacity1: Float = 0
    var shadowOffset1: CGSize = .zero
    var shadowRadius1: CGFloat = 0
}

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
        
    }
    
    func applyDefaultStyle(){
        headerView.detailLabel.textColor = FFResources.Colors.detailTextColor
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

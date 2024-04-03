//
//  DataTips.swift
//  FeelFit
//
//  Created by Константин Малков on 02.04.2024.
//

import UIKit
import TipKit

struct InformationDataTip: Tip {
    var title: Text
    var message: Text?
    var image: Image?
    
    init(title: Text, message: Text? = nil, image: Image? = nil) {
        self.title = title
        self.message = message
        self.image = image
    }
}

//
//  DataTips.swift
//  FeelFit
//
//  Created by Константин Малков on 02.04.2024.
//

import UIKit
import TipKit

struct FavoritesTip: Tip {
    var title: Text {
        Text("Short Information")
    }
    
    var message: Text? {
        Text("This row show up user's detail information. It include full name, and some important Health Data")
    }
    
    var image: Image? {
        Image(systemName: "info.circle")
    }
}


struct ActionTip: Tip {
    var title: Text
    var message: Text?
    var image: Image?
    
    init(title: Text, message: Text? = nil, image: Image? = nil) {
        self.title = title
        self.message = message
        self.image = image
    }
    
    var actions: [Action] {
        Action(id: "reset-password", title: "Drop password")
        Action(id: "not-reset-password", title: "Drop password")
    }
}

//
//  TextFieldToolBar.swift
//  FeelFit
//
//  Created by Константин Малков on 08.03.2024.
//

import UIKit

class TextFieldToolBar: UIToolbar {
    
    private var selector: Selector?
    private weak var target: AnyObject?
    
    init(frame: CGRect, selector: Selector?,target: AnyObject) {
        self.init()
        self.frame = frame
        self.selector = selector
        self.target = target
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.barStyle = .default
        self.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: target, action: selector)
        let items = [flexibleSpace,doneButtonItem]
        self.setItems(items, animated: true)
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

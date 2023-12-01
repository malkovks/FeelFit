//
//  FFCreateTrainProgramViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 01.12.2023.
//

import UIKit

class FFCreateTrainProgramViewModel {
    
    //MARK: - Action methods
    func setupItalicText(textView: UITextView) -> NSMutableAttributedString {
        let currentAttributes = textView.typingAttributes
        let range = textView.selectedRange
        
        let attributes = NSMutableAttributedString(string: textView.text)
        attributes.addAttribute(.font, value: UIFont.textLabelFont(size: 20), range: NSRange(location: 0, length: attributes.length))
        
        if let font = currentAttributes[NSAttributedString.Key.font] as? UIFont,
           font.fontDescriptor.symbolicTraits.contains(.traitItalic) {
            let originFont = UIFont.textLabelFont(size: 20)
            let newAttributes = [NSAttributedString.Key.font: originFont]
            let attributedString = NSMutableAttributedString(string: textView.text)
            attributedString.addAttributes(newAttributes, range: range)
            return attributedString
        } else {
            attributes.addAttribute(.font, value: UIFont.italicSystemFont(ofSize: 20), range: range)
            return attributes
        }
    }
    
    func setupUnderlineText(textView: UITextView) -> NSMutableAttributedString {
        let currentAttributes = textView.typingAttributes
        let range = textView.selectedRange
        let symbolsCount = textView.offset(from: textView.beginningOfDocument, to: textView.selectedTextRange!.start)
        let unselectedRange = NSMakeRange(symbolsCount, 0)
        
        let attributedString = NSMutableAttributedString(string: textView.text)
        
        if let underlineStyle = currentAttributes[NSAttributedString.Key.underlineStyle] as? NSUnderlineStyle,
           underlineStyle == .single {
            let newAttributes = [NSAttributedString.Key.underlineStyle: 0]
            let attributedString = NSMutableAttributedString(string: textView.text)
            attributedString.addAttributes(newAttributes, range: range )
            attributedString.addAttribute(.font, value: UIFont.textLabelFont(size: 20), range: range)
        } else {
            let newAttributes = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
            
            attributedString.addAttributes(newAttributes, range: range)
            attributedString.addAttribute(.font, value: UIFont.textLabelFont(size: 20), range: unselectedRange)
        }
        return attributedString
    }
    
    func setupBoldText(textView: UITextView) -> NSMutableAttributedString {
        let currentAttributes = textView.typingAttributes
        let range = textView.selectedRange
        
        let attributes = NSMutableAttributedString(string: textView.text)
        attributes.addAttribute(.font, value: UIFont.textLabelFont(size: 20), range: NSRange(location: 0, length: attributes.length))
        
        if let font = currentAttributes[NSAttributedString.Key.font] as? UIFont,
           font.fontDescriptor.symbolicTraits.contains(.traitBold) {
            let originFont = UIFont.textLabelFont(size: 20)
            let newAttributes = [NSAttributedString.Key.font: originFont]
            let attributedString = NSMutableAttributedString(string: textView.text)
            attributedString.addAttributes(newAttributes, range: range)
            return attributedString
        } else {
            attributes.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 20), range: range)
            return attributes
        }
    }
    
    //MARK: UIMenu methods
    func setLocationMenu(handler: @escaping (String) -> () ) -> UIMenu {
        var actions: [UIAction] {
            [UIAction(title: "Indoor", handler: { _ in
                handler("Indoor")
            }),
             UIAction(title: "Outdoor", handler: { _ in
                handler("Outdoor")
            })]
        }
        let menu = UIMenu(title: "Choose location of your training",image: UIImage(systemName: "location"),children: actions)
        return menu
    }
    
    func setTrainingTypeMenu(handler: @escaping (String) -> ()) -> UIMenu {
        var actions: [UIAction] {
            [UIAction(title: "Cardio", handler: {  _ in
                handler("Cardio")
            }),
             UIAction(title: "Strength", handler: {  _ in
                handler("Strength")
            }),
             UIAction(title: "Endurance", handler: { _ in
                handler("Endurance")
            }),
             UIAction(title: "Flexibility", handler: { _ in
                handler("Flexibility")
                
            })]
        }
        
        let menu = UIMenu(title: "Choose Type of your training",image: UIImage(systemName: "figure.highintensity.intervaltraining"),children: actions)
        return menu
    }
}

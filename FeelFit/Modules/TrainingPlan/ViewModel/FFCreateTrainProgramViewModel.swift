//
//  FFCreateTrainProgramViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 01.12.2023.
//

import UIKit

class FFCreateTrainProgramViewModel {
    
    private let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func confirmAndContinue(model: CreateTrainProgram,textfield: UITextField,textView: UITextView,alertView: ()->()) {
        guard let firstText = textfield.text, !firstText.isEmpty,
              let secondText = textView.text, !secondText.isEmpty
        else {
            alertView()
            return
        }
        var data = model
        data.name = firstText
        data.note = secondText
        let vc = FFAddExerciseViewController(trainProgram: data)
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Action methods
    /// method for making selected text italic style
    /// - Parameter textView: input textview and selected text
    /// - Returns: return converted italic text for selected text from textview
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
    
    /// method for adding underline for selected text
    /// - Parameter textView: input text view
    /// - Returns: return converted text to selected text from textview
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
    
    /// Method for setting up selected text in bold style
    /// - Parameter textView: input textview
    /// - Returns: return converted text for textview
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
    
    func openDatePickerController(){
        let vc = FFDatePickerViewController()
        let nav = FFNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        nav.sheetPresentationController?.prefersGrabberVisible = true
        nav.sheetPresentationController?.detents = [.custom(resolver: { [unowned self] context in
            return viewController.view.frame.size.height/1.5
        })]
        nav.isNavigationBarHidden = false
        viewController.present(nav, animated: true)
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
    
    

    
    /// Method for setting up toolbar for uitextview when user start to work with textviews keyboard
    /// - Parameters:
    ///   - boldAction: setting up selected text to bold
    ///   - italicAction: setting up selected text to italic
    ///   - underlineAction: setting up selected text to italic
    ///   - doneAction: dismiss keyboard
    /// - Returns: return sets up toolbar
    func setupToolBar(boldAction: Selector,italicAction: Selector,underlineAction: Selector,doneAction: Selector) -> UIToolbar{
        let toolBar = UIToolbar(frame: .zero)
        toolBar.sizeToFit()
        toolBar.tintColor = FFResources.Colors.activeColor
        let boldText = UIBarButtonItem(image: UIImage(systemName: "bold"), style: .done, target: self, action: boldAction)
        let italicText = UIBarButtonItem(image: UIImage(systemName: "italic"),style: .done, target: self, action: italicAction)
        let underlineText = UIBarButtonItem(image: UIImage(systemName: "underline"), style: .done, target: self, action: underlineAction)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: doneAction)
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([boldText, space, italicText, space, underlineText, space, doneButton], animated: true)
        return toolBar
    }
}

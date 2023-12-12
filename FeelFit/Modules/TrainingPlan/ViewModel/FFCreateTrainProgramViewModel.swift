//
//  FFCreateTrainProgramViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 01.12.2023.
//

import UIKit
import UserNotifications

class FFCreateTrainProgramViewModel {
    
    var completionData: ((Date,Bool) -> ())?
    
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
        data.notificationStatus ? createNotification(data) : nil
        let vc = FFAddExerciseViewController(trainProgram: data)
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func createNotification(_ model: CreateTrainProgram){
        let sound = UNNotificationSound(named: UNNotificationSoundName("ringtone.mp3"))
//        guard let image = Bundle.main.url(forResource: "traps", withExtension: "jpeg") else { return }
        
        let dateComponents: DateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: model.date)
        let id = UUID().uuidString
//        let attachment = try! UNNotificationAttachment(identifier: id, url: image, options: nil)
        
        let content = UNMutableNotificationContent()
        content.title = model.name.capitalized
        content.body = model.note.capitalized
        content.sound = sound
//        content.attachments = [attachment]
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if error == nil {
                DispatchQueue.main.async {
                    self.viewController.viewAlertController(text: "Notification was created", startDuration: 0.5, timer: 2, controllerView: self.viewController.view)
                }
            } else {
                print("Error")
            }
        }
        
        
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
        vc.handler = { date, status in
            self.completionData?(date,status)
        }
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

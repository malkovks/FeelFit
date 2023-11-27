//
//  FFCreateTrainProgramViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 26.11.2023.
//

import UIKit


class FFCreateTrainProgramViewController: UIViewController, SetupViewController {
    
    var trainPlanData = ["","","",""]
    
    private let trainingPlanTextField: UITextField = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        let field = UITextField(frame: .zero)
        field.font = UIFont.textLabelFont()
        field.placeholder = "Enter the name of training"
        field.leftView = view
        field.leftViewMode = .always
        field.clearButtonMode = .whileEditing
        field.layer.cornerRadius = 15
        field.borderStyle = .roundedRect
        field.textColor = FFResources.Colors.textColor
        field.backgroundColor = FFResources.Colors.tabBarBackgroundColor
        return field
    }()
    
    private let noteTrainingPlanTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.font = UIFont.textLabelFont(size: 20)
        textView.textAlignment = .justified
        textView.textColor = FFResources.Colors.textColor
        textView.layer.cornerRadius = 8
        textView.allowsEditingTextAttributes = false
        textView.allowsKeyboardScrolling = true
        textView.setContentHuggingPriority( .defaultHigh, for: .vertical)
        textView.backgroundColor = FFResources.Colors.tabBarBackgroundColor
        return textView
    }()

    private let locationButton: UIButton = {
       let button = UIButton()
        button.configuration = .borderedTinted()
        button.configuration?.title = "Choose Training Location"
        button.configuration?.image = UIImage(systemName: "location")
        button.configuration?.imagePadding = 2
        button.configuration?.imagePlacement = .leading
        button.configuration?.baseBackgroundColor = FFResources.Colors.activeColor
        button.configuration?.baseForegroundColor = FFResources.Colors.textColor
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    private let trainingTypeButton: UIButton = {
       let button = UIButton()
        button.titleLabel?.font = UIFont.detailLabelFont()
        button.configuration = .borderedTinted()
        button.configuration?.title = "Choose Training Type"
        button.configuration?.image = UIImage(systemName: "figure.highintensity.intervaltraining")
        button.configuration?.imagePadding = 2
        button.configuration?.imagePlacement = .leading
        button.configuration?.baseBackgroundColor = FFResources.Colors.darkPurple
        button.configuration?.baseForegroundColor = FFResources.Colors.darkPurple
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    private var textViewToolBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationController()
        setupConstraints()
        setupButtons()
        setupTextViewInsets()
        dismissKeyboardBySwipe()
        setupToolBar()
    }
    //MARK: - Target methods
    @objc private func didTapSwipeKeyboard(){
        view.endEditing(true)
    }
    
    @objc private func didTapBoldText(){
        let currentAttributes = noteTrainingPlanTextView.typingAttributes
        let range = noteTrainingPlanTextView.selectedRange
        
        let attributes = NSMutableAttributedString(string: noteTrainingPlanTextView.text)
        attributes.addAttribute(.font, value: UIFont.textLabelFont(size: 20), range: NSRange(location: 0, length: attributes.length))
        
        if let font = currentAttributes[NSAttributedString.Key.font] as? UIFont,
           font.fontDescriptor.symbolicTraits.contains(.traitBold) {
            let originFont = UIFont.textLabelFont(size: 20)
            let newAttributes = [NSAttributedString.Key.font: originFont]
            let attributedString = NSMutableAttributedString(string: noteTrainingPlanTextView.text)
            attributedString.addAttributes(newAttributes, range: range)
        } else {
            attributes.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 20), range: range)
            noteTrainingPlanTextView.attributedText = attributes
        }
    }
    
    @objc private func didTapItalicText(){
        let currentAttributes = noteTrainingPlanTextView.typingAttributes
        let range = noteTrainingPlanTextView.selectedRange
        
        let attributes = NSMutableAttributedString(string: noteTrainingPlanTextView.text)
        attributes.addAttribute(.font, value: UIFont.textLabelFont(size: 20), range: NSRange(location: 0, length: attributes.length))
        
        if let font = currentAttributes[NSAttributedString.Key.font] as? UIFont,
           font.fontDescriptor.symbolicTraits.contains(.traitItalic) {
            let originFont = UIFont.textLabelFont(size: 20)
            let newAttributes = [NSAttributedString.Key.font: originFont]
            let attributedString = NSMutableAttributedString(string: noteTrainingPlanTextView.text)
            attributedString.addAttributes(newAttributes, range: range)
        } else {
            attributes.addAttribute(.font, value: UIFont.italicSystemFont(ofSize: 20), range: range)
            noteTrainingPlanTextView.attributedText = attributes
        }
    }
    
    @objc private func didTapUnderlineText(){
        let currentAttributes = noteTrainingPlanTextView.typingAttributes
        let range = noteTrainingPlanTextView.selectedRange
        if let underlineStyle = currentAttributes[NSAttributedString.Key.underlineStyle] as? NSUnderlineStyle,
           underlineStyle == .single {
            let newAttributes = [NSAttributedString.Key.underlineStyle: 0]
            let attributedString = NSMutableAttributedString(string: noteTrainingPlanTextView.text)
            attributedString.addAttributes(newAttributes, range: range )
            noteTrainingPlanTextView.attributedText = attributedString
        } else {
            let newAttributes = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
            let attributedString = NSMutableAttributedString(string: noteTrainingPlanTextView.text)
            attributedString.addAttributes(newAttributes, range: range)
            noteTrainingPlanTextView.attributedText = attributedString
            
        }
    }

    //MARK: - ДОДЕЛАТЬ ОТСТУП у TEXTVIEW
    func setupToolBar(){
        textViewToolBar = UIToolbar(frame: .zero)
        textViewToolBar.sizeToFit()
        textViewToolBar.tintColor = FFResources.Colors.activeColor
        let boldText = UIBarButtonItem(image: UIImage(systemName: "bold"), style: .done, target: self, action: #selector(didTapBoldText))
        let italicText = UIBarButtonItem(image: UIImage(systemName: "italic"),style: .done, target: self, action: #selector(didTapItalicText))
        let underlineText = UIBarButtonItem(image: UIImage(systemName: "underline"), style: .done, target: self, action: #selector(didTapUnderlineText))
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapSwipeKeyboard))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        textViewToolBar.setItems([boldText, space, italicText, space, underlineText, space, doneButton], animated: true)
        noteTrainingPlanTextView.inputAccessoryView = textViewToolBar
        
    }
    
    func setupTextViewInsets(){
        let style = NSMutableParagraphStyle()
        style.firstLineHeadIndent = 20
        let attributes = [NSAttributedString.Key.paragraphStyle: style]
        let string = NSAttributedString(string: "", attributes: attributes)
        noteTrainingPlanTextView.attributedText = string
    }
    
    func dismissKeyboardBySwipe(){
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(didTapSwipeKeyboard))
        swipe.direction = .down
        view.addGestureRecognizer(swipe)
    }
    
    func setLocationMenu() -> UIMenu {
        var actions: [UIAction] {
            [UIAction(title: "Inside", handler: { [unowned self] _ in
                trainPlanData[2] = "Inside"
                locationButton.configuration?.title = trainPlanData[2]
            }),
             UIAction(title: "Outside", handler: { [unowned self] _ in
                trainPlanData[2] = "Outside"
                locationButton.configuration?.title = trainPlanData[2]
            })]
        }
        
        let menu = UIMenu(title: "Choose location of your training",image: UIImage(systemName: "location"),children: actions)
        return menu
    }
    
    private func setTrainingTypeMenu() -> UIMenu {
        var actions: [UIAction] {
            [UIAction(title: "Cardio", handler: { [unowned self] _ in
                trainPlanData[3] = "Inside"
                trainingTypeButton.configuration?.title = trainPlanData[3]
            }),
             UIAction(title: "Strength", handler: { [unowned self] _ in
                trainPlanData[3] = "Strength"
                trainingTypeButton.configuration?.title = trainPlanData[3]
            }),
             UIAction(title: "Endurance", handler: { [unowned self] _ in
                trainPlanData[3] = "Endurance"
                trainingTypeButton.configuration?.title = trainPlanData[3]
            }),
             UIAction(title: "Flexibility", handler: { [unowned self] _ in
                trainPlanData[3] = "Flexibility"
                trainingTypeButton.configuration?.title = trainPlanData[3]
            })]
        }
        
        let menu = UIMenu(title: "Choose Type of your training",image: UIImage(systemName: "figure.highintensity.intervaltraining"),children: actions)
        return menu
    }
    
    func setupGradient(){
        let gradient = CAGradientLayer()
        gradient.frame = view.frame
        gradient.colors = [FFResources.Colors.activeColor.cgColor,FFResources.Colors.darkPurple.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }

    func setupView() {
        trainingPlanTextField.becomeFirstResponder()
//        setupGradient()
        view.backgroundColor = FFResources.Colors.backgroundColor
    }
    
    func setupButtons(){
        locationButton.menu = setLocationMenu()
        trainingTypeButton.menu = setTrainingTypeMenu()
    }
    
    func setupNavigationController() {
        title = "Create program"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func addToolBar(){
        let toolBar = UIToolbar()
    }
}

extension FFCreateTrainProgramViewController {
    private func setupConstraints(){
        let stackView = UIStackView(arrangedSubviews: [locationButton,trainingTypeButton])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        
        view.addSubview(trainingPlanTextField)
        trainingPlanTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalToSuperview().multipliedBy(0.05)
        }
        
        view.addSubview(noteTrainingPlanTextView)
        noteTrainingPlanTextView.snp.makeConstraints { make in
            make.top.equalTo(trainingPlanTextField.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalToSuperview().multipliedBy(0.65)
        }
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(noteTrainingPlanTextView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-15)
        }
    }
}

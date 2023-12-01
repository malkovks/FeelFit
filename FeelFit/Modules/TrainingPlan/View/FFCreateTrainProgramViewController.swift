//
//  FFCreateTrainProgramViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 26.11.2023.
//

import UIKit

struct CreateTrainProgram {
    var name: String
    var note: String
    var type: String
    var location: String
}


/// Class which create base information about future training
class FFCreateTrainProgramViewController: UIViewController, SetupViewController {
    
    private var viewModel: FFCreateTrainProgramViewModel!
    
    var trainPlanData = CreateTrainProgram(name: "", note: "", type: "", location: "")
    
    private let trainingPlanTextField: UITextField = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        let field = UITextField(frame: .zero)
        field.returnKeyType = .continue
        field.enablesReturnKeyAutomatically = true
        field.tintColor = .blue
        field.font = UIFont.textLabelFont()
        field.placeholder = "Enter the name of training"
        field.leftView = view
        field.leftViewMode = .always
        field.clearButtonMode = .whileEditing
        field.layer.cornerRadius = 8
        field.layer.borderWidth = 0.2
        field.layer.borderColor = FFResources.Colors.textColor.cgColor
        field.layer.masksToBounds = true
        field.textColor = FFResources.Colors.textColor
        field.backgroundColor = FFResources.Colors.tabBarBackgroundColor
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private let noteTrainingPlanTextView: UITextView = {
        let textView = UITextView(frame: .zero)
        textView.font = UIFont.textLabelFont(size: 20)
        textView.returnKeyType = .next
        textView.textAlignment = .justified
        textView.textColor = FFResources.Colors.textColor
        textView.layer.cornerRadius = 8
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.allowsEditingTextAttributes = false
        textView.allowsKeyboardScrolling = true
        textView.setContentHuggingPriority( .defaultHigh, for: .vertical)
        textView.backgroundColor = FFResources.Colors.tabBarBackgroundColor
        textView.layer.borderColor = FFResources.Colors.textColor.cgColor
        textView.layer.borderWidth = 0.2
        textView.layer.masksToBounds = true
        textView.translatesAutoresizingMaskIntoConstraints = false
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
        button.translatesAutoresizingMaskIntoConstraints = false
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
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var textViewToolBar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupView()
        setupNavigationController()
        setupConstraints()
        setupButtons()
        setupTextViewInsets()
        dismissKeyboardBySwipe()
        setupToolBar()
        setupDelegates()
        
        
    }
    //MARK: - Target methods
    @objc private func didTapSwipeKeyboard(){
        view.endEditing(true)
    }
    
    @objc private func didTapBoldText(){
        noteTrainingPlanTextView.attributedText = viewModel.setupBoldText(textView: noteTrainingPlanTextView)
    }
    
    @objc private func didTapItalicText(){
        noteTrainingPlanTextView.attributedText = viewModel.setupItalicText(textView: noteTrainingPlanTextView)
    }
    
    @objc private func didTapUnderlineText(){
        noteTrainingPlanTextView.attributedText = viewModel.setupUnderlineText(textView: noteTrainingPlanTextView)
    }
    
    @objc private func didTapContinue(){
        guard let firstText = trainingPlanTextField.text, firstText != "",
              let secondText = noteTrainingPlanTextView.text, secondText != ""
        else {
            viewAlertController(text: "Fill in all the fields", startDuration: 0.5, timer: 1.5, controllerView: self.view)
            return
        }
        trainPlanData.name = firstText
        trainPlanData.note = secondText
        let vc = FFAddExerciseViewController(trainProgram: trainPlanData)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func didTapQuestion(){
        
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
    
    func setupViewModel(){
        viewModel = FFCreateTrainProgramViewModel()
    }
    
    func setupTextViewInsets(){
        let style = NSMutableParagraphStyle()
        style.firstLineHeadIndent = 20
        let attributes = [NSAttributedString.Key.paragraphStyle: style]
        let string = NSAttributedString(string: noteTrainingPlanTextView.text, attributes: attributes)
        noteTrainingPlanTextView.attributedText = string
    }
    
    func dismissKeyboardBySwipe(){
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(didTapSwipeKeyboard))
        swipe.direction = .down
        view.addGestureRecognizer(swipe)
    }
    
    func setupDelegates(){
        trainingPlanTextField.delegate = self
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
        locationButton.menu = viewModel.setLocationMenu(handler: { [unowned self] location in
            trainPlanData.location = location
            locationButton.configuration?.title = location
        })
        trainingTypeButton.menu = viewModel.setTrainingTypeMenu(handler: { [unowned self] type in
            trainPlanData.type = type
            trainingTypeButton.configuration?.title = type
            
        })
    }
    
    func setupNavigationController() {
        title = "Create program"
        navigationItem.largeTitleDisplayMode = .never
        let continueButton = addNavigationBarButton(title: "Create", imageName: "" , action: #selector(didTapContinue), menu: nil)
        navigationItem.rightBarButtonItem = continueButton
    }
    

}

extension FFCreateTrainProgramViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = trainingPlanTextField.text,
           !text.isEmpty {
            trainPlanData.name = text
            trainingPlanTextField.resignFirstResponder()
            noteTrainingPlanTextView.becomeFirstResponder()
            return true
        } else {
            return false
        }
    }
}

extension FFCreateTrainProgramViewController {
    private func setupConstraints(){
        let stackView = UIStackView(arrangedSubviews: [locationButton,trainingTypeButton])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
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

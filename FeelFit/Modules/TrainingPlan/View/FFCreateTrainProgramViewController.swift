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
    var date: Date
    var notificationStatus: Bool
}


/// Class which create base information about future training
class FFCreateTrainProgramViewController: UIViewController, SetupViewController {
    
    private var viewModel: FFCreateTrainProgramViewModel!
    
    var trainPlanData = CreateTrainProgram(name: "", note: "", type: "", location: "",date: Date(),notificationStatus: false)
    
    private let trainingPlanTextField: UITextField = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        let field = UITextField(frame: .zero)
        field.returnKeyType = .continue
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
    
    private let datePickerButton: UIButton = {
       let button = UIButton()
        button.titleLabel?.font = UIFont.detailLabelFont()
        button.configuration = .borderedTinted()
        button.configuration?.title = "Select Training Date"
        button.configuration?.image = UIImage(systemName: "calendar.badge.plus")
        button.configuration?.imagePadding = 2
        button.configuration?.imagePlacement = .leading
        button.configuration?.baseBackgroundColor = .systemBlue
        button.configuration?.baseForegroundColor = .systemBlue
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
        viewModel.confirmAndContinue(model: trainPlanData, textfield: trainingPlanTextField, textView: noteTrainingPlanTextView) {
            viewAlertController(text: "Fill all the fields", startDuration: 0.5, timer: 2, controllerView: self.view)
        }
    }
    
    @objc private func didTapOpenDatePicker(){
        viewModel.openDatePickerController()
        viewModel.completionData = { [unowned self] date, status in
            trainPlanData.date = date
            trainPlanData.notificationStatus = status
            let dateString = date.formatted(date: .abbreviated, time: .shortened)
            datePickerButton.configuration?.title = "Planned date: " + dateString
        }
    }
    //MARK: - ДОДЕЛАТЬ ОТСТУП у TEXTVIEW
    
    private func setupToolBar(){
        textViewToolBar = viewModel.setupToolBar(boldAction: #selector(didTapBoldText),
                                                 italicAction: #selector(didTapItalicText),
                                                 underlineAction: #selector(didTapUnderlineText),
                                                 doneAction: #selector(didTapSwipeKeyboard)
        )
    }
    
    func setupViewModel(){
        viewModel = FFCreateTrainProgramViewModel(viewController: self)
    }
    
    private func setupTextViewInsets(){
        let style = NSMutableParagraphStyle()
        style.firstLineHeadIndent = 20
        let attributes = [NSAttributedString.Key.paragraphStyle: style]
        let string = NSAttributedString(string: noteTrainingPlanTextView.text, attributes: attributes)
        noteTrainingPlanTextView.attributedText = string
    }
    
    private func dismissKeyboardBySwipe(){
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(didTapSwipeKeyboard))
        swipe.direction = .down
        view.addGestureRecognizer(swipe)
    }
    
    private func setupDelegates(){
        trainingPlanTextField.delegate = self
    }
    
    

    func setupView() {
        trainingPlanTextField.becomeFirstResponder()
        view.backgroundColor = FFResources.Colors.backgroundColor
    }
    
    private func setupButtons(){
        locationButton.menu = viewModel.setLocationMenu(handler: { [unowned self] location in
            trainPlanData.location = location
            locationButton.configuration?.title = location
        })
        trainingTypeButton.menu = viewModel.setTrainingTypeMenu(handler: { [unowned self] type in
            trainPlanData.type = type
            trainingTypeButton.configuration?.title = type
        })
        
        datePickerButton.addTarget(self, action: #selector(didTapOpenDatePicker), for: .primaryActionTriggered)
    }
    
    func setupNavigationController() {
        title = "Create program"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = addNavigationBarButton(title: "Create", imageName: "" , action: #selector(didTapContinue), menu: nil)
    }
}

extension FFCreateTrainProgramViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = trainingPlanTextField.text,
           !text.isEmpty {
            trainPlanData.name = text
            trainingPlanTextField.enablesReturnKeyAutomatically = true
            trainingPlanTextField.resignFirstResponder()
            noteTrainingPlanTextView.becomeFirstResponder()
            return true
        } else {
            trainingPlanTextField.enablesReturnKeyAutomatically = false
            return false
        }
    }
}

extension FFCreateTrainProgramViewController {
    private func setupConstraints(){
        let stackView = UIStackView(arrangedSubviews: [locationButton, datePickerButton,trainingTypeButton])
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
            make.height.equalToSuperview().multipliedBy(0.6)
        }
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(noteTrainingPlanTextView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-15)
        }
    }
    //UNUSED
    func setupGradient(){
        let gradient = CAGradientLayer()
        gradient.frame = view.frame
        gradient.colors = [FFResources.Colors.activeColor.cgColor,FFResources.Colors.darkPurple.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }
}

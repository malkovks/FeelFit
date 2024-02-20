//
//  FFCreateTrainProgramViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 26.11.2023.
//

import UIKit
import RealmSwift

struct CreateTrainProgram {
    var name: String
    var note: String
    var type: String?
    var location: String?
    var date: Date
    var notificationStatus: Bool
}


/// Class which create base information about future training
class FFCreateTrainProgramViewController: UIViewController, SetupViewController {
    
    private var viewModel: FFCreateTrainProgramViewModel!
    
    let isViewEditing: Bool
    var trainPlanData: CreateTrainProgram
    var exercises: List<FFExerciseModelRealm>?
    var trainModel: FFTrainingPlanRealmModel?
    
    init( isViewEditing: Bool = false, trainPlanData: CreateTrainProgram?,_ exercises: List<FFExerciseModelRealm>? = nil,trainPlanRealmModel: FFTrainingPlanRealmModel? = nil) {
        let plan = CreateTrainProgram(name: "", note: "", type: "", location: "", date: Date(), notificationStatus: false)
        
        self.isViewEditing = isViewEditing
        self.trainPlanData = trainPlanData ?? plan
        self.exercises = exercises
        self.trainModel = trainPlanRealmModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        textView.returnKeyType = .done
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
    
    private let placeholderLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.detailLabelFont(size: 18,weight: .thin)
        label.textAlignment = .left
        label.textColor = FFResources.Colors.detailTextColor
        label.text = "Enter your workout details"
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupView()
        setupNavigationController()
        setupToolBar()
        setupConstraints()
        setupButtons()
        setupTextViewInsets()
        dismissKeyboardBySwipe()
        setupEditingView(isViewEditing)
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
        viewModel.confirmAndContinue(model: trainPlanData, textfield: trainingPlanTextField, textView: noteTrainingPlanTextView, exercises, isViewEditing, trainModel) {
            viewAlertController(text: "Fill all the fields", startDuration: 0.5, timer: 2, controllerView: self.view)
        }
    }
    
    @objc private func didTapOpenDatePicker(){
        viewModel.openDatePickerController(date: trainPlanData.date)
        viewModel.completionData = { [unowned self] date, status in
            trainPlanData.date = date
            trainPlanData.notificationStatus = status
            let dateString = date.formatted(date: .abbreviated, time: .shortened)
            datePickerButton.configuration?.title = "Planned date: " + dateString
        }
    }
    //MARK: - ДОДЕЛАТЬ ОТСТУП у TEXTVIEW
    
    func setupEditingView(_ isEditing: Bool) {
        if isEditing {
            let dateString = DateFormatter.localizedString(from: trainPlanData.date, dateStyle: .short, timeStyle: .short)
            trainingPlanTextField.text = trainPlanData.name
            noteTrainingPlanTextView.text = trainPlanData.note
            locationButton.setTitle(trainPlanData.location, for: .normal)
            datePickerButton.setTitle(dateString, for: .normal)
            trainingTypeButton.setTitle(trainPlanData.type, for: .normal)
            placeholderLabel.isHidden = true
        }
    }
    
    private func setupToolBar(){
        let toolBar = UIToolbar(frame: .zero)
        toolBar.sizeToFit()
        toolBar.tintColor = FFResources.Colors.activeColor
        let boldText = UIBarButtonItem(image: UIImage(systemName: "bold"), style: .done, target: self, action: #selector(didTapBoldText))
        let italicText = UIBarButtonItem(image: UIImage(systemName: "italic"),style: .done, target: self, action: #selector(didTapItalicText))
        let underlineText = UIBarButtonItem(image: UIImage(systemName: "underline"), style: .done, target: self, action: #selector(didTapUnderlineText))
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapSwipeKeyboard))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([boldText, space, italicText, space, underlineText, space, doneButton], animated: true)
        noteTrainingPlanTextView.inputAccessoryView = toolBar
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
        noteTrainingPlanTextView.delegate = self
        placeholderLabel.isHidden = !noteTrainingPlanTextView.text.isEmpty
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
    
    private func setupButtons(location: String = "",type: String = "",date: Date = Date()){
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

extension FFCreateTrainProgramViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        viewModel.textView(textView, shouldChangeTextIn: range, replacementText: text)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

extension FFCreateTrainProgramViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let (status,text) = viewModel.textFieldShouldReturn(textField, trainingPlanTextField, textView: noteTrainingPlanTextView)
        trainPlanData.name = text
        return status
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        viewModel.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
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
        
        noteTrainingPlanTextView.addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(10)
            make.width.equalToSuperview().inset(10)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(noteTrainingPlanTextView.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
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

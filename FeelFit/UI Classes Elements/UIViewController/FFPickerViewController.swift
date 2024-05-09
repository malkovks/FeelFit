//
//  FFPickerViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 13.03.2024.
//

import UIKit

protocol FFPickerViewDelegate: AnyObject {
    func didReceiveSelectedDate(selectedDate: Date?, index: Int)
    func didReceiveSelectedValue(selectedValue: String?,index: Int)
}

class FFPickerViewController: UIViewController {
    
    weak var delegate: FFPickerViewDelegate?

    
    private var pickerData: [String]?
    private var tableViewIndex: Int
    private var blurEffect: UIBlurEffect.Style?
    private var vibrancyEffect: UIVibrancyEffectStyle?
    
    private var selectedValue: String?
    
    //Доделать инициализатор
    //Должен брать на вход опциональные данные в случае если они имеются и выбирать уже существующий кейс из enum
    init(
        selectedValue: String,
        tableViewIndex: Int,
        title: String? = nil,
        blurEffectStyle: UIBlurEffect.Style?,
        vibrancyEffect: UIVibrancyEffectStyle?) {
            
            self.selectedValue = selectedValue
            self.tableViewIndex = tableViewIndex
            self.blurEffect = blurEffectStyle
            self.vibrancyEffect = vibrancyEffect
            super.init(nibName: nil, bundle: nil)
            self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private let pickerView : UIPickerView = UIPickerView(frame: .zero)
    
    private let datePickerView: UIDatePicker = {
        let picker = UIDatePicker(frame: .zero)
        picker.preferredDatePickerStyle = .wheels
        picker.timeZone = TimeZone.current
        picker.datePickerMode = .date
        picker.isHidden = true
        return picker
    }()
    
    private let selectedRowLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.textLabelFont(size: 24, for: .title1, weight: .thin, width: .standard)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.contentMode = .scaleToFill
        label.setupLabelShadowColor()
        return label
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        enumProvider(tableViewIndex)
    }
    
    //MARK: - Action methods
    
    /// Function prepare visual part of view and process input index and return converted index
    /// - Parameter index: selected index of table view
    func enumProvider(_ index: Int) {
        switch index {
        case 0:
            setupDisplayDatePickerView(true)
            if selectedValue != nil {
                let value: Date = selectedValue?.convertStringToDate() ?? Date()
                datePickerView.setDate(value, animated: true)
            }
            pickerData = nil
        case 1:
            setupPickerData(HealthStoreRequest.BloodTypeResult.self)
        case 2:
            setupPickerData(HealthStoreRequest.GenderTypeResult.self)
        case 3:
            setupPickerData(HealthStoreRequest.FitzpatricSkinTypeResult.self)
        case 4:
            setupPickerData(HealthStoreRequest.WheelchairTypeResult.self)
        default:
            setupDisplayDatePickerView(false)
            fatalError("Invalid index. Try again later")
        }
    }
    
    
    /// Function take as input value enum type for processing data, convert to array, return as data for displaying in picker view and select row of picker view if value is not equal nil
    /// - Parameter cases: Enum cases types where enum.rawValue == String
    func setupPickerData<T: RawRepresentable & CaseIterable>(_ cases: T.Type) where T.RawValue == String {
            setupDisplayDatePickerView(false)
            let data = cases.allCases.compactMap({ $0.rawValue })
            pickerData = data
            guard let value = selectedValue,
                  !value.isEmpty,
                  let index = data.firstIndex(where: { $0 == value })
            else {
                return
            }
            pickerView.selectRow(index, inComponent: 0, animated: true)
            
        }

    
    private func setupDisplayDatePickerView(_ isDatePickerPresented: Bool) {
        datePickerView.isHidden = !isDatePickerPresented
        pickerView.isHidden = isDatePickerPresented
    }
    
    @objc private func didTapSaveResult(){
        
        if tableViewIndex == 0 {
            let selectedDate = datePickerView.date
            delegate?.didReceiveSelectedDate(selectedDate: selectedDate, index: tableViewIndex)
        }
        self.dismiss(animated: true)
    }
    
    @objc private func didTapSelectDate(_ sender: UIDatePicker){
        let selectedDate = datePickerView.date
        let dateComponents = selectedDate.convertDateToDateComponents()
        let dateString = dateComponents.convertComponentsToDateString()
        DispatchQueue.main.async {
            self.selectedRowLabel.text = dateString
        }
    }
}

//MARK: - Setup methods
extension FFPickerViewController: SetupViewController {
    func setupView() {
        setupNavigationController()
        setupViewModel()
        setupPickerView()
        view.backgroundColor = .clear
        
        let visualEffect = UIVisualEffectView(effect: UIBlurEffect(style: blurEffect ?? .regular))
        visualEffect.frame = view.bounds
        view.addSubview(visualEffect)
        
        setupConstraints()
        
    }
    
    private func setupDatePickerView(){
        datePickerView.backgroundColor = .systemRed
        datePickerView.tintColor = .customBlack
        datePickerView.backgroundColor = .clear
        datePickerView.addTarget(self, action: #selector(didTapSelectDate), for: .primaryActionTriggered)
    }
    
    private func setupPickerView(){
        pickerView.backgroundColor = .systemRed
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .clear
    }
    
    func setupNavigationController() {
        navigationItem.rightBarButtonItem = addNavigationBarButton(title: "Done", imageName: "", action: #selector(didTapSaveResult), menu: nil)
    }
    
    func setupViewModel() {
        
    }
}

extension FFPickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData?.count ?? 0
    }
}

extension FFPickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let value = pickerData?[row] else { return }
        selectedRowLabel.text = value
        selectedValue = value
        delegate?.didReceiveSelectedValue(selectedValue: value, index: tableViewIndex)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData?[row]
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 44))
        label.numberOfLines = 1
        label.contentMode = .scaleAspectFit
        label.font = UIFont.detailLabelFont(size: 20)
        label.text = pickerData?[row]
        label.textAlignment = .center
        label.textColor = .customBlack
        return label
    }
    
    
}

extension FFPickerViewController {
    private func setupConstraints(){
        let height = view.frame.size.height * 0.3
        
        preferredContentSize = CGSize(width: view.frame.size.width, height: height * 2 )
        
        view.addSubview(selectedRowLabel)
        selectedRowLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        
        view.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.top.equalTo(selectedRowLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(height)
        }
        
        view.addSubview(datePickerView)
        datePickerView.snp.makeConstraints { make in
            make.top.equalTo(selectedRowLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(height)
        }
    }
}

#Preview {
    let navVC = UINavigationController(rootViewController: FFPickerViewController(selectedValue: "Not Set", tableViewIndex: 3, blurEffectStyle: .regular, vibrancyEffect: .fill))
    navVC.modalPresentationStyle = .pageSheet
    navVC.sheetPresentationController?.detents = [.custom(resolver: { context in
        return 300.0
    })]
    navVC.sheetPresentationController?.prefersGrabberVisible = true
    return navVC
}


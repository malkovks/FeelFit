//
//  FFPickerViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 13.03.2024.
//

import UIKit

protocol FFPickerViewDelegate: AnyObject {
    func didReceiveSelectedData(selectedDate: Date?,selectedValue: String?,selectedIndex: Int)
}

class FFPickerViewController: UIViewController {
    
    weak var delegate: FFPickerViewDelegate?
    
//    var completionText: ((String) -> Void)?
//    var completionDate: ((Date) -> Void)?
    
    private var pickerData: [String]?
    private var tableViewIndex: Int
    private var blurEffect: UIBlurEffect.Style?
    private var vibrancyEffect: UIVibrancyEffectStyle?
    
    private var selectedValue: String = ""
    
    //Доделать инициализатор
    //Должен брать на вход опциональные данные в случае если они имеются и выбирать уже существующий кейс из enum
    init(
        tableViewIndex: Int,
        blurEffectStyle: UIBlurEffect.Style?,
        vibrancyEffect: UIVibrancyEffectStyle?) {
        self.tableViewIndex = tableViewIndex
        self.blurEffect = blurEffectStyle
        self.vibrancyEffect = vibrancyEffect
        super.init(nibName: nil, bundle: nil)
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
    
    func enumProvider(_ index: Int) {
        switch index {
        case 0:
            setupDisplayDatePickerView(true)
            pickerData = nil
        case 1:
            setupDisplayDatePickerView(false)
            pickerData = HealthStoreRequest.BloodTypeResult.allCases.compactMap({ $0.rawValue })
        case 2:
            setupDisplayDatePickerView(false)
            pickerData = HealthStoreRequest.GenderTypeResult.allCases.compactMap({ $0.rawValue })
        case 3:
            setupDisplayDatePickerView(false)
            pickerData = HealthStoreRequest.FitzpatricSkinTypeResult.allCases.compactMap({ $0.rawValue })
        case 4:
            setupDisplayDatePickerView(false)
            pickerData = HealthStoreRequest.WheelchairTypeResult.allCases.compactMap({ $0.rawValue })
        default:
            setupDisplayDatePickerView(false)
            fatalError("Invalid index. Try again later")
        }
    }
    
    private func setupDisplayDatePickerView(_ isDatePickerPresented: Bool) {
        if isDatePickerPresented {
            datePickerView.isHidden = false
            pickerView.isHidden = true
        } else {
            datePickerView.isHidden = true
            pickerView.isHidden = false
        }
    }
    
    @objc private func didTapSaveResult(){
        
        if tableViewIndex == 0 {
            let selectedDate = datePickerView.date
            delegate?.didReceiveSelectedData(selectedDate: selectedDate, selectedValue: nil, selectedIndex: tableViewIndex)
        } else {
            let selectedText = selectedRowLabel.text
            delegate?.didReceiveSelectedData(selectedDate: nil, selectedValue: selectedText, selectedIndex: tableViewIndex)
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

extension FFPickerViewController: SetupViewController {
    func setupView() {
        setupNavigationController()
        setupViewModel()
        setupPickerView()
        view.backgroundColor = .clear
        setupBlurEffectBackgroundView(blurEffect, vibrancyEffect)
        
        let vbe = UIVisualEffectView(effect: UIBlurEffect(style: blurEffect ?? .regular))
        vbe.frame = view.bounds
        view.addSubview(vbe)
        
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
    let navVC = UINavigationController(rootViewController: FFPickerViewController(tableViewIndex: 3, blurEffectStyle: .regular, vibrancyEffect: .fill))
    navVC.modalPresentationStyle = .pageSheet
    navVC.sheetPresentationController?.detents = [.custom(resolver: { context in
        return 300.0
    })]
    navVC.sheetPresentationController?.prefersGrabberVisible = true
    return navVC
}


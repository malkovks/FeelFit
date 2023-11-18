//
//  FFNewsSettingViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 10.10.2023.
//

import UIKit
import SnapKit

class Section {
    let title: String
    var isOpened: Bool = false
    
    init(title: String, isOpened: Bool = false) {
        self.title = title
        self.isOpened = isOpened
    }
}



class FFNewsSettingViewController: UIViewController, SetupViewController {


    private var rows = [[String]]()
    private var sections = [Section]()
    
    var viewModel: FFNewsSettingViewModel!
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(FFNewsSetupRequestTableViewCell.self, forCellReuseIdentifier: FFNewsSetupRequestTableViewCell.identifier)
        return table
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        sections = [
            Section(title: "Localization"),
            Section(title: "Request Type"),
            Section(title: "Sort Type")
        ]
        setupView()
        setupNavigationController()
        setupTableView()
        setupConstraints()
    }
    
    //MARK: - Setup methods
    func setupView() {
        viewModel = FFNewsSettingViewModel()
        rows = viewModel.setupRowModel()
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupNavigationController() {
        title = "Setup request"
    }
}

//MARK: - TableViewDelegate
extension FFNewsSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.tableView(tableView, didSelectRowAt: indexPath, sections: sections)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        viewModel.tableView(tableView, heightForRowAt: indexPath)
    }
}
//MARK: - tableView data source
extension FFNewsSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FFNewsSetupRequestTableViewCell.identifier, for: indexPath) as! FFNewsSetupRequestTableViewCell
        let valueStatus = viewModel?.valueSettings()[indexPath.section]
        let value = sections[indexPath.section].title
        if indexPath.row == 0 {
            for subview in cell.subviews {
                if subview is UIPickerView {
                    subview.removeFromSuperview()
                    cell.accessoryView = nil
                }
            }
            cell.configureText(title: value, statusTitle: valueStatus ?? "")
            cell.isCellOpened.toggle()
            return cell
        } else {
            cell.isCellOpened.toggle()
            cell.configureOpenCell()
            let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 200))
            pickerView.delegate = self
            pickerView.dataSource = self

            pickerView.tag = indexPath.section
            
            cell.addSubview(pickerView)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        if section.isOpened {
            return 2
        } else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
}
//MARK: - Picker delegate & datasource
extension FFNewsSettingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.pickerView(pickerView, numberOfRowsInComponent: component, rows: rows)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        viewModel.pickerView(pickerView, viewForRow: row, forComponent: component, reusing: view, rows: rows)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel?.didSelectRow(pickerView, didSelectRow: row, inComponent: component, rows: rows)
    }
    
    
}
//MARK: - Constraints setups
extension FFNewsSettingViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

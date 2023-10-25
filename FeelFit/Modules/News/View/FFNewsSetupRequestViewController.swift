//
//  FFNewsSetupRequestViewController.swift
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



class FFNewsSetupRequestViewController: UIViewController, SetupViewController {


    var rows = [[String]]()
    
    var viewModel: FFNewsSettingViewModel!
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(FFNewsSetupRequestTableViewCell.self, forCellReuseIdentifier: FFNewsSetupRequestTableViewCell.identifier)
        return table
    }()
    
    private var sections = [Section]()

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

extension FFNewsSetupRequestViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
            tableView.reloadSections([indexPath.section], with: .automatic)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        } else {
            return 200
        }
    }
}

extension FFNewsSetupRequestViewController: UITableViewDataSource {
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

extension FFNewsSetupRequestViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return rows[0].count
        } else if pickerView.tag == 1 {
            return rows[1].count
        } else {
            return rows[2].count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        label.contentMode = .scaleAspectFit
        label.font = .systemFont(ofSize: 20,weight: .semibold)
        label.numberOfLines = 1
        if pickerView.tag == 0 {
            label.text =  rows[0][row]
        } else if pickerView.tag == 1 {
            label.text =  rows[1][row]
        } else {
            label.text =  rows[2][row]
        }
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel?.didSelectRow(pickerView, didSelectRow: row, inComponent: component, rows: rows)
    }
    
    
}

extension FFNewsSetupRequestViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
//
//#Preview {
//    FFNewsSetupRequestViewController()
//}

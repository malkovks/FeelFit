//
//  FFCreateProgramViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 09.11.2023.
//

import UIKit




class FFCreateProgramViewController: UIViewController, SetupViewController {
    
    var viewModel: FFCreateProgramViewModel!
    
    var textData = [
        ["Name Of Workout"],
        ["Duration","Location","Type","Training Date"],
        ["Duration","Type"],
        ["Approaches","Repeats","Exercise"],
        ["Duration","Cool Down Type"]
    ]
    
    var titleHeaderViewString: [String] = [
        "",
        "Basic Settings"
        ,"Warm Up"
        ,"Exercise №1"
        ,"Hitch"
    ]
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupViewModel()
        setupTableView()
        
        setupNavigationController()
        setupConstraints()
    }
    
    func setupViewModel(){
        viewModel = FFCreateProgramViewModel(viewController: self)
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    func setupNavigationController() {
        title = "Create new plan"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setupTableView(){
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.register(FFCreateTableViewCell.self, forCellReuseIdentifier: FFCreateTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.bounces = false
        tableView.backgroundColor = FFResources.Colors.tabBarBackgroundColor
        tableView.sectionIndexColor = .orange
        tableView.tableFooterView = nil
    }
}

extension FFCreateProgramViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return textData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FFCreateTableViewCell.identifier, for: indexPath) as! FFCreateTableViewCell
        cell.configureTableViewCell(tableView: tableView, indexPath: indexPath, text: textData)
        
        
        return cell
    }
    
    //Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let numberOfSections = tableView.numberOfSections
        print(numberOfSections)
        let view = FFCreateHeaderView()
        let text = titleHeaderViewString[section]
        view.delegate = self
        view.configureHeaderView(section: section,numberOfSections: numberOfSections,text: text)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

extension FFCreateProgramViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.tableView(tableView, didSelectRowAt: indexPath)
    }
}

extension FFCreateProgramViewController: AddSectionProtocol {
    
    
    func addSection() {
        let index = textData.count
        
        titleHeaderViewString.insert("Exercise №\(index-3)", at: index-1)
        textData.insert(textData[2], at: index-1)
        tableView.insertSections(IndexSet(integer: index-1), with: .top)
        tableView.reloadData()
    }
    
    func removeSection() {
        let index = textData.count - 2
        textData.remove(at: index)
        titleHeaderViewString.remove(at: index)
        tableView.deleteSections(IndexSet(integer: index), with: .bottom)
        tableView.reloadData()
        
    }
    
    
}

extension FFCreateProgramViewController {
    private func setupConstraints(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

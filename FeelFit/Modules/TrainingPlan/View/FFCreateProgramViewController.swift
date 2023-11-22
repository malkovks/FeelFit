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
    
    var detailTextData = [[""],
                          ["Duration","Location","Type","Training"],
                          ["Not selected","Not selected"],
                          ["Not selected","Not selected","Not Selected"],
                          ["Not selected","Not selected"]
                        ]
    
    var titleHeaderViewString: [String] = [
        "",
        "Basic Settings"
        ,"Warm Up"
        ,"Exercise №1"
        ,"Hitch"
    ]
    
    private let closeFooterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.layer.cornerRadius = 14
        button.tintColor = FFResources.Colors.activeColor
        button.backgroundColor = .secondarySystemBackground
        return button
    }()
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupViewModel()
        setupTableView()
        
        setupNavigationController()
        setupConstraints()
    }
    
    @objc private func buttonTapped(){
        self.dismiss(animated: true)
    }
    
    func setupViewModel(){
        viewModel = FFCreateProgramViewModel(viewController: self)
    }
    
    func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = addNavigationBarButton(title: "Save", imageName: "", action: #selector(buttonTapped), menu: nil)
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
        closeFooterButton.addTarget(self, action: #selector(buttonTapped), for: .primaryActionTriggered)
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
        cell.configureTableViewCell(tableView: tableView, indexPath: indexPath, text: textData, actionLabel: detailTextData)
        return cell
    }
    
    //Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let numberOfSections = tableView.numberOfSections
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
        if section == tableView.numberOfSections - 1{
            return 55
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == tableView.numberOfSections - 1 {
            closeFooterButton.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 38)
            return closeFooterButton
        } else {
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        if section == tableView.numberOfSections - 1 {
            return 50
        } else {
            return 0
        }
    }
}

extension FFCreateProgramViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let text = textData[indexPath.section][indexPath.row]
        let vc = FFCellSelectionViewController(titleText: text)
        let navVC = FFNavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .formSheet
        navVC.sheetPresentationController?.detents = [.medium()]
        navVC.sheetPresentationController?.prefersGrabberVisible = true
        navVC.isNavigationBarHidden = false
        present(navVC, animated: true)
    }
}

extension FFCreateProgramViewController: AddSectionProtocol {
    
    
    func addSection() {
        let index = textData.count
        let indexDetailData = detailTextData.count
        detailTextData.insert(detailTextData[3], at: indexDetailData-1)
        titleHeaderViewString.insert("Exercise №\(index-3)", at: index-1)
        textData.insert(textData[3], at: index-1)
        tableView.insertSections(IndexSet(integer: index-1), with: .top)
        tableView.reloadData()
    }
    
    func removeSection() {
        let index = textData.count - 2
        let indexDetailData = detailTextData.count - 2
        textData.remove(at: index)
        detailTextData.remove(at: indexDetailData)
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

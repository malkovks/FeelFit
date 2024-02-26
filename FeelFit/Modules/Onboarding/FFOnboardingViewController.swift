//
//  FFOnboardingViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 26.02.2024.
//

import UIKit

class FFOnboardingViewController: UIViewController {
    
    var pageTitleLabel = UILabel()
    var pageSubtitle = UILabel()
    var pageImageView = UIImageView()
    
    init(imageName: String, pageTitle: String,pageSubtitle: String) {
        let config = UIImage.SymbolConfiguration(pointSize: 140, weight: .thin, scale: .large)
        self.pageImageView.image = UIImage(systemName: imageName)!.withConfiguration(config)
        self.pageTitleLabel.text = pageTitle
        self.pageSubtitle.text = pageSubtitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        setupView()
    }
    func setupView(){
        setupLabels()
        setupConstraints()
    }
    
    func setupLabels(){
        pageTitleLabel.font = UIFont.headerFont(size: 32)
        pageTitleLabel.textAlignment = .justified
        pageTitleLabel.contentMode = .center
        pageTitleLabel.numberOfLines = 1
        
        pageSubtitle.font = UIFont.textLabelFont(size: 16, weight: .thin, width: .condensed)
        pageSubtitle.numberOfLines = 0
        pageSubtitle.textColor = .detailText
        pageSubtitle.contentMode = .center
        pageSubtitle.textAlignment = .justified
        
        pageImageView.contentMode = .scaleAspectFit
        pageImageView.tintColor = FFResources.Colors.activeColor
    }
}

private extension FFOnboardingViewController {
    func setupConstraints(){
        let stackView = UIStackView(arrangedSubviews: [pageImageView,pageTitleLabel,pageSubtitle])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().dividedBy(1.5)
            make.height.equalToSuperview().multipliedBy(0.8)
        }
        
        pageImageView.snp.makeConstraints { make in
            make.height.equalToSuperview().multipliedBy(0.4)
        }
    }
}

#Preview {
    return FFOnboardingViewController(imageName: "trash.fill", pageTitle: "Trash title", pageSubtitle: "Use HealthKit’s clinical record support to read Fast Healthcare Interoperability Resources (FHIR) from the HealthKit store. Users can download their FHIR records from supported healthcare institutions. The system then updates the records in the background on a regular basis.")
}

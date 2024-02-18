//
//  FFPresentHealthFooterCollectionView.swift
//  FeelFit
//
//  Created by Константин Малков on 08.02.2024.
//

import UIKit

class FFPresentHealthFooterCollectionView: UICollectionReusableView {
    static let identifier = "FFPresentHealthFooterCollectionView"
    
    
    let segueFooterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.configuration = .filled()
        button.configuration?.cornerStyle = .medium
        button.configuration?.image = UIImage(systemName: "heart")?.withTintColor(.systemRed)
        button.configuration?.imagePlacement = .leading
        button.configuration?.imagePadding = 5
        button.configuration?.title = "Set up displayed data"
        button.configuration?.baseBackgroundColor = .systemBackground
        button.configuration?.baseForegroundColor = FFResources.Colors.textColor
        button.contentMode = .left
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFooterView()
        setupFooterConstraints()
    }
    
    private func setupFooterView(){
    }
    private func setupFooterConstraints(){
        self.addSubview(segueFooterButton)
        segueFooterButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




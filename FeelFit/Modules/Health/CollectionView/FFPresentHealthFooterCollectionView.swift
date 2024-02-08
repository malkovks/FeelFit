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
        button.backgroundColor = .systemBackground
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFooterView()
        setupFooterConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupFooterView(){
        backgroundColor = .systemBlue
    }
    private func setupFooterConstraints(){
        
    }
}



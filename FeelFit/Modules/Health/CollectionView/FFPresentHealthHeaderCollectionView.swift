//
//  FFPresentHealthCollectionReusableView.swift
//  FeelFit
//
//  Created by Константин Малков on 08.02.2024.
//

import UIKit

class FFPresentHealthHeaderCollectionView: UICollectionReusableView {
    static let identifier = "FFPresentHealthHeaderCollectionView"
    
    private let headerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 1
        label.font = UIFont.headerFont(size: 20)
        label.textAlignment = .left
        label.contentMode = .left
        label.textColor = FFResources.Colors.textColor
        return label
    }()
    
    let setupHeaderFavouritesButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Change", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .clear
        button.contentMode = .right
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    let setupPresentHealthControllerButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        button.tintColor = .systemBackground
        button.backgroundColor = .clear
        button.contentMode = .right
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHeaderView()
        setupHeaderConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHeaderView() {
        
        headerLabel.text = "Favourites"
        
    }
    
    private func setupHeaderConstraints(){
        let stackView = UIStackView(arrangedSubviews: [headerLabel,setupPresentHealthControllerButton,setupHeaderFavouritesButton])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.backgroundColor = .clear
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
}

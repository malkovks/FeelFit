//
//  FFWelcomeViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 23.03.2024.
//

import UIKit

class FFWelcomeViewController: UIViewController {
    
    let welcomeLabelText: String?
    
    init(welcomeLabelText: String?) {
        self.welcomeLabelText = welcomeLabelText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let welcomeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.textLabelFont(size: 32,for: .extraLargeTitle,weight: .semibold)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .main
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.view.window?.rootViewController?.dismiss(animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isBeingDismissed {
            UIView.transition(with: view, duration: 1, options: .transitionFlipFromBottom, animations: nil, completion: nil)
        }
    }
}

private extension FFWelcomeViewController {
    func setupView(){
        setupBlurEffect()
        setupConstraints()
        let text = welcomeLabelText ?? "User"
        welcomeLabel.text = "Welcome to Application, \(text)"
    }
    
    func setupBlurEffect(){
        let blurEffect = UIBlurEffect(style: .dark)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.frame = view.bounds
        view.addSubview(effectView)
    }
}

private extension FFWelcomeViewController {
    func setupConstraints(){
        view.addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
    }
}

//
//  TipKit+UIViewControllerExtension.swift
//  FeelFit
//
//  Created by Константин Малков on 02.04.2024.
//

import UIKit
import TipKit

extension FFHealthUserProfileViewController {
    func showInlineInfo(titleText title: String, messageText subtitle: String,popoverImage image: String){
        let tip = InformationDataTip(title: Text(title), message: Text(subtitle), image: Image(systemName: image))
        Task { @MainActor in
            for await shouldDisplay in tip.shouldDisplayUpdates {
                if shouldDisplay {
                    let tipView = TipUIView(tip,arrowEdge: .bottom)
                    tipView.backgroundColor = .secondarySystemGroupedBackground
                    tipView.cornerRadius = 12
                    view.addSubview(tipView)
                    
                    tipView.snp.makeConstraints { make in
                        make.center.equalToSuperview()
                        make.leading.trailing.equalToSuperview().inset(20)
                    }
                } else {
                    if let tipView = view.subviews.first(where: { $0 is TipUIView }){
                        tipView.removeFromSuperview()
                    }
                }
            }
        }
    }
}

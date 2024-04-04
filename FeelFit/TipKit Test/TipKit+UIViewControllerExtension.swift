//
//  TipKit+UIViewControllerExtension.swift
//  FeelFit
//
//  Created by Константин Малков on 02.04.2024.
//

import UIKit
import TipKit

extension UIViewController {
    
    /// Function for displaying tip inline information view for displaying some info
    /// - Parameters:
    ///   - title: title of inline view
    ///   - subtitle: subtitle of inline view
    ///   - image: left image of inline view
    ///   - arrowEdge: four types of arrow direction
    ///   - completion: optional completion for tipView if need to change constraints
    func showInlineInfo(titleText title: String,
                        messageText subtitle: String,
                        popoverImage image: String,
                        arrowEdge: Edge = .top,
                        completion: ((_ tipView: TipUIView) -> Void)? = nil) {
        
        let tip = InformationDataTip(title: Text(title), message: Text(subtitle), image: Image(systemName: image))
        Task { @MainActor in
            for await shouldDisplay in tip.shouldDisplayUpdates {
                if shouldDisplay {
                    let tipView = TipUIView(tip,arrowEdge: arrowEdge)
                    tipView.backgroundColor = .secondarySystemGroupedBackground
                    tipView.cornerRadius = 12
                    view.addSubview(tipView)
                    
                    tipView.snp.makeConstraints { make in
                        make.center.equalToSuperview()
                        make.leading.trailing.equalToSuperview().inset(20)
                    }
                    completion?(tipView)
                } else {
                    if let tipView = view.subviews.first(where: { $0 is TipUIView }){
                        tipView.removeFromSuperview()
                    }
                }
            }
        }
    }
}

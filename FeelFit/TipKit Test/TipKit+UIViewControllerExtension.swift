//
//  TipKit+UIViewControllerExtension.swift
//  FeelFit
//
//  Created by Константин Малков on 02.04.2024.
//

import UIKit
import TipKit

extension FFHealthUserProfileViewController {
    @objc func showPopoverInfo(){
        Task { @MainActor in
            for await shouldDisplay in FavoritesTip().shouldDisplayUpdates {
                if shouldDisplay {
                    let vc = TipUIPopoverViewController(FavoritesTip(), sourceItem: button)
                    present(vc, animated: true)
                }
            }
        }
    }
    
    @objc func showInlineInfo(){
        Task { @MainActor in
            for await shouldDisplay in FavoritesTip().shouldDisplayUpdates {
                if shouldDisplay {
                    let tipView = TipUIView(FavoritesTip(),arrowEdge: .bottom)
                    view.addSubview(tipView)
                }
            }
        }
    }
    
    @objc func showActionTipInfo(){
        Task { @MainActor in
            for await shouldDisplay in ActionTip(title:Text(verbatim: "Some text")).shouldDisplayUpdates {
                if shouldDisplay {
                    let tipView = TipUIView(ActionTip(title: Text(verbatim: "Some text")), arrowEdge: .top) { action in
                        if action.id == "reset-password"{
                            print("Reset password")
                        }
                        
                    }
                } else {
                    print("Displayed yet")
                }
            }
        }
    }
}

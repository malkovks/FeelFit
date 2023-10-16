//
//  Coordinator.swift
//  FeelFit
//
//  Created by Константин Малков on 12.10.2023.
//

import Foundation
import UIKit

//перечисление для выбора действия при нажатии на какой то обьект для перехода на другой контроллер
//
enum NewsEvent {
    case tableViewDidSelect
    case openFavourite
    case openNewsSettings
    case openURL
}

protocol Coordinator {
    var navigationController: FFNavigationController? { get set }
    var tabbarController: FFTabBarController? { get set }
    
    func start()
    func eventOccurredNewsModule(event: NewsEvent, model: Articles?)
    func detailVC(model: Articles)
}

protocol Coordinating {
    var coordinator: Coordinator? { get set }
}


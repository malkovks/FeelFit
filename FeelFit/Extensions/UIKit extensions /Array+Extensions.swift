//
//  Array+Extensions.swift
//  FeelFit
//
//  Created by Константин Малков on 04.10.2023.
//

import UIKit

public extension Array where Element: Hashable {
    func uniqueArray() -> [Element] {
        var seen = Set<Element>()
        return filter{ seen.insert($0).inserted }
    }
}

//
//  Sequence+Extension.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/08/31.
//

import Foundation

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

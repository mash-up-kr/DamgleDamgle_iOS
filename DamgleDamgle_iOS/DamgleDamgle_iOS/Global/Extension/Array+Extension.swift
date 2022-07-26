//
//  Array+Extension.swift
//  DamgleDamgle_iOS
//
//  Created by lina on 2022/07/16.
//

extension Array {
    subscript(safe index: Int) -> Element? {
        get {
            indices ~= index ? self[index] : nil
        }
        set(newValue) {
            if let newValue = newValue, indices.contains(index) {
                self[index] = newValue
            }
        }
    }
}

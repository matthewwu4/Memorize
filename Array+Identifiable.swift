//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by Matthew Wu on 6/22/20.
//  Copyright © 2020 Matthew Wu. All rights reserved.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIndex(matching: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == matching.id {
                return index
            }
        }
        return nil
    }
}

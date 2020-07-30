//
//  Array+Only.swift
//  Memorize
//
//  Created by Matthew Wu on 6/23/20.
//  Copyright © 2020 Matthew Wu. All rights reserved.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}

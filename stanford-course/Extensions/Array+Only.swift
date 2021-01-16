//
//  Array+Only.swift
//  stanford-course
//
//  Created by James Watling on 14/01/2021.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}

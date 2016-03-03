//
//  Array.swift
//  JumuNordost
//
//  Created by Martin Richter on 03/03/16.
//  Copyright © 2016 Martin Richter. All rights reserved.
//

import Foundation

extension Array {
    /// Returns all elements contained in the receiver, but not the other array.
    func difference<T: Equatable>(otherArray: [T]) -> [T] {
        var result = [T]()

        for e in self {
            if let element = e as? T {
                if !otherArray.contains(element) {
                    result.append(element)
                }
            }
        }
        
        return result
    }

    /// Returns all elements contained in both the receiver and the other array.
    func intersection<T: Equatable>(otherArray: [T]) -> [T] {
        var result = [T]()

        for e in self {
            if let element = e as? T {
                if otherArray.contains(element) {
                    result.append(element)
                }
            }
        }

        return result
    }
}

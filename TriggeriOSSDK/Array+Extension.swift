//
//  Array+Extension.swift
//  TriggeriOSSDK
//
//  Created by Adrian on 9/4/16.
//  Copyright © 2016 Trigger Finance, Inc. All rights reserved.
//

import Foundation

internal extension Array {
    
    subscript (safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
}
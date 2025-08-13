//
//  Item.swift
//  KeySpirte
//
//  Created by Lei Yang on 12/8/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

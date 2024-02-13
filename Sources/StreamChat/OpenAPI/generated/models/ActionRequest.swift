//
// Copyright © 2024 Stream.io Inc. All rights reserved.
//

import Foundation

public struct ActionRequest: Codable, Hashable {
    public var name: String? = nil
    public var style: String? = nil
    public var text: String? = nil
    public var type: String? = nil
    public var value: String? = nil

    public init(name: String? = nil, style: String? = nil, text: String? = nil, type: String? = nil, value: String? = nil) {
        self.name = name
        self.style = style
        self.text = text
        self.type = type
        self.value = value
    }
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case name
        case style
        case text
        case type
        case value
    }
}

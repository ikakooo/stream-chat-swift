//
// Copyright © 2024 Stream.io Inc. All rights reserved.
//

import Foundation

public struct ImageDataRequest: Codable, Hashable {
    public var frames: String? = nil
    public var height: String? = nil
    public var size: String? = nil
    public var url: String? = nil
    public var width: String? = nil

    public init(frames: String? = nil, height: String? = nil, size: String? = nil, url: String? = nil, width: String? = nil) {
        self.frames = frames
        self.height = height
        self.size = size
        self.url = url
        self.width = width
    }
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case frames
        case height
        case size
        case url
        case width
    }
}

//
// Copyright © 2024 Stream.io Inc. All rights reserved.
//

import Foundation

public struct StreamChatEventNotificationSettings: Codable, Hashable {
    public var enabled: Bool
    
    public var apns: StreamChatAPNS
    
    public init(enabled: Bool, apns: StreamChatAPNS) {
        self.enabled = enabled
        
        self.apns = apns
    }
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case enabled
        
        case apns
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(enabled, forKey: .enabled)
        
        try container.encode(apns, forKey: .apns)
    }
}

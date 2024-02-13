//
// Copyright © 2024 Stream.io Inc. All rights reserved.
//

import Foundation

public struct NotificationMutesUpdatedEvent: Codable, Hashable, Event {
    public var createdAt: Date
    public var type: String
    public var me: OwnUser

    public init(createdAt: Date, type: String, me: OwnUser) {
        self.createdAt = createdAt
        self.type = type
        self.me = me
    }
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case type
        case me
    }
}

extension NotificationMutesUpdatedEvent: EventContainsCreationDate {}

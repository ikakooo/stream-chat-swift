//
// Copyright © 2024 Stream.io Inc. All rights reserved.
//

import Foundation

public struct UserDeactivatedEvent: Codable, Hashable, Event {
    public var createdAt: Date
    public var type: String
    public var createdBy: UserObject
    public var user: UserObject? = nil

    public init(createdAt: Date, type: String, createdBy: UserObject, user: UserObject? = nil) {
        self.createdAt = createdAt
        self.type = type
        self.createdBy = createdBy
        self.user = user
    }
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt = "created_at"
        case type
        case createdBy = "created_by"
        case user
    }
}

extension UserDeactivatedEvent: EventContainsCreationDate {}
extension UserDeactivatedEvent: EventContainsUser {}

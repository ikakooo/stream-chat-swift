//
// Copyright © 2024 Stream.io Inc. All rights reserved.
//

import Foundation

public struct StreamChatQueryBannedUsersRequest: Codable, Hashable {
    public var filterConditions: [String: RawJSON]
    
    public var createdAtAfter: Date? = nil
    
    public var createdAtAfterOrEqual: Date? = nil
    
    public var createdAtBefore: Date? = nil
    
    public var createdAtBeforeOrEqual: Date? = nil
    
    public var excludeExpiredBans: Bool? = nil
    
    public var limit: Int? = nil
    
    public var offset: Int? = nil
    
    public var userId: String? = nil
    
    public var sort: [StreamChatSortParam?]? = nil
    
    public var user: StreamChatUserObject? = nil
    
    public init(filterConditions: [String: RawJSON], createdAtAfter: Date? = nil, createdAtAfterOrEqual: Date? = nil, createdAtBefore: Date? = nil, createdAtBeforeOrEqual: Date? = nil, excludeExpiredBans: Bool? = nil, limit: Int? = nil, offset: Int? = nil, userId: String? = nil, sort: [StreamChatSortParam?]? = nil, user: StreamChatUserObject? = nil) {
        self.filterConditions = filterConditions
        
        self.createdAtAfter = createdAtAfter
        
        self.createdAtAfterOrEqual = createdAtAfterOrEqual
        
        self.createdAtBefore = createdAtBefore
        
        self.createdAtBeforeOrEqual = createdAtBeforeOrEqual
        
        self.excludeExpiredBans = excludeExpiredBans
        
        self.limit = limit
        
        self.offset = offset
        
        self.userId = userId
        
        self.sort = sort
        
        self.user = user
    }
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case filterConditions = "filter_conditions"
        
        case createdAtAfter = "created_at_after"
        
        case createdAtAfterOrEqual = "created_at_after_or_equal"
        
        case createdAtBefore = "created_at_before"
        
        case createdAtBeforeOrEqual = "created_at_before_or_equal"
        
        case excludeExpiredBans = "exclude_expired_bans"
        
        case limit
        
        case offset
        
        case userId = "user_id"
        
        case sort
        
        case user
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(filterConditions, forKey: .filterConditions)
        
        try container.encode(createdAtAfter, forKey: .createdAtAfter)
        
        try container.encode(createdAtAfterOrEqual, forKey: .createdAtAfterOrEqual)
        
        try container.encode(createdAtBefore, forKey: .createdAtBefore)
        
        try container.encode(createdAtBeforeOrEqual, forKey: .createdAtBeforeOrEqual)
        
        try container.encode(excludeExpiredBans, forKey: .excludeExpiredBans)
        
        try container.encode(limit, forKey: .limit)
        
        try container.encode(offset, forKey: .offset)
        
        try container.encode(userId, forKey: .userId)
        
        try container.encode(sort, forKey: .sort)
        
        try container.encode(user, forKey: .user)
    }
}

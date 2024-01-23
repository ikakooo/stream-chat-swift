//
// Copyright © 2024 Stream.io Inc. All rights reserved.
//

import Foundation

public struct StreamChatMuteUserResponse: Codable, Hashable {
    public var duration: String
    
    public var mutes: [StreamChatUserMute?]? = nil
    
    public var nonExistingUsers: [String]? = nil
    
    public var mute: StreamChatUserMute? = nil
    
    public var ownUser: StreamChatOwnUser? = nil
    
    public init(duration: String, mutes: [StreamChatUserMute?]? = nil, nonExistingUsers: [String]? = nil, mute: StreamChatUserMute? = nil, ownUser: StreamChatOwnUser? = nil) {
        self.duration = duration
        
        self.mutes = mutes
        
        self.nonExistingUsers = nonExistingUsers
        
        self.mute = mute
        
        self.ownUser = ownUser
    }
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        
        case mutes
        
        case nonExistingUsers = "non_existing_users"
        
        case mute
        
        case ownUser = "own_user"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(duration, forKey: .duration)
        
        try container.encode(mutes, forKey: .mutes)
        
        try container.encode(nonExistingUsers, forKey: .nonExistingUsers)
        
        try container.encode(mute, forKey: .mute)
        
        try container.encode(ownUser, forKey: .ownUser)
    }
}

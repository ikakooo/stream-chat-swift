//
// Copyright © 2024 Stream.io Inc. All rights reserved.
//

import Foundation

public struct ReactionRequest: Codable, Hashable {
    public var type: String
    public var messageId: String? = nil
    public var score: Int? = nil
    public var userId: String? = nil
    public var custom: [String: RawJSON]? = nil
    public var user: UserObjectRequest? = nil

    public init(type: String, messageId: String? = nil, score: Int? = nil, userId: String? = nil, custom: [String: RawJSON]? = nil, user: UserObjectRequest? = nil) {
        self.type = type
        self.messageId = messageId
        self.score = score
        self.userId = userId
        self.custom = custom
        self.user = user
    }
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case type
        case messageId = "message_id"
        case score
        case userId = "user_id"
        case custom
        case user
    }
}

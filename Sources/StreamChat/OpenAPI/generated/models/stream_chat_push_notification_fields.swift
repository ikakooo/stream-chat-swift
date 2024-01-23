//
// Copyright © 2024 Stream.io Inc. All rights reserved.
//

import Foundation

public struct StreamChatPushNotificationFields: Codable, Hashable {
    public var offlineOnly: Bool
    
    public var version: String
    
    public var apn: StreamChatAPNConfigFields
    
    public var firebase: StreamChatFirebaseConfigFields
    
    public var huawei: StreamChatHuaweiConfigFields
    
    public var xiaomi: StreamChatXiaomiConfigFields
    
    public var providers: [StreamChatPushProvider?]? = nil
    
    public init(offlineOnly: Bool, version: String, apn: StreamChatAPNConfigFields, firebase: StreamChatFirebaseConfigFields, huawei: StreamChatHuaweiConfigFields, xiaomi: StreamChatXiaomiConfigFields, providers: [StreamChatPushProvider?]? = nil) {
        self.offlineOnly = offlineOnly
        
        self.version = version
        
        self.apn = apn
        
        self.firebase = firebase
        
        self.huawei = huawei
        
        self.xiaomi = xiaomi
        
        self.providers = providers
    }
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case offlineOnly = "offline_only"
        
        case version
        
        case apn
        
        case firebase
        
        case huawei
        
        case xiaomi
        
        case providers
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(offlineOnly, forKey: .offlineOnly)
        
        try container.encode(version, forKey: .version)
        
        try container.encode(apn, forKey: .apn)
        
        try container.encode(firebase, forKey: .firebase)
        
        try container.encode(huawei, forKey: .huawei)
        
        try container.encode(xiaomi, forKey: .xiaomi)
        
        try container.encode(providers, forKey: .providers)
    }
}

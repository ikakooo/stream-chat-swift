//
// Copyright © 2024 Stream.io Inc. All rights reserved.
//

import Foundation

public struct StreamChatSearchResponse: Codable, Hashable {
    public var duration: String
    
    public var results: [StreamChatSearchResult?]
    
    public var next: String? = nil
    
    public var previous: String? = nil
    
    public var resultsWarning: StreamChatSearchWarning? = nil
    
    public init(duration: String, results: [StreamChatSearchResult?], next: String? = nil, previous: String? = nil, resultsWarning: StreamChatSearchWarning? = nil) {
        self.duration = duration
        
        self.results = results
        
        self.next = next
        
        self.previous = previous
        
        self.resultsWarning = resultsWarning
    }
    
    public enum CodingKeys: String, CodingKey, CaseIterable {
        case duration
        
        case results
        
        case next
        
        case previous
        
        case resultsWarning = "results_warning"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(duration, forKey: .duration)
        
        try container.encode(results, forKey: .results)
        
        try container.encode(next, forKey: .next)
        
        try container.encode(previous, forKey: .previous)
        
        try container.encode(resultsWarning, forKey: .resultsWarning)
    }
}

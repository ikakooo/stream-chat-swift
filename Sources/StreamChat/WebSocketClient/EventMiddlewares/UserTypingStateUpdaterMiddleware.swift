//
// Copyright © 2024 Stream.io Inc. All rights reserved.
//

import CoreData

/// A middleware which updates `currentlyTypingUsers` for a specific channel based on received `TypingEvent`.
struct UserTypingStateUpdaterMiddleware: EventMiddleware {
    func handle(event: Event, session: DatabaseSession) -> Event? {
        switch event {
        case let event as TypingStartEvent:
            guard
                let cid = try? ChannelId(cid: event.cid),
                let channelDTO = session.channel(cid: cid),
                let userId = event.user?.id,
                let userDTO = session.user(id: userId)
            else { break }

            channelDTO.currentlyTypingUsers.insert(userDTO)
        case let event as TypingStopEvent:
            guard
                let cid = try? ChannelId(cid: event.cid),
                let channelDTO = session.channel(cid: cid),
                let userId = event.user?.id,
                let userDTO = session.user(id: userId)
            else { break }

            channelDTO.currentlyTypingUsers.remove(userDTO)
        case let event as TypingStopEvent:
            guard
                let cid = try? ChannelId(cid: event.cid),
                let channelDTO = session.channel(cid: cid),
                let userDTO = session.user(id: event.user?.id ?? "")
            else { break }

            channelDTO.currentlyTypingUsers.remove(userDTO)

        default:
            break
        }

        return event
    }
}

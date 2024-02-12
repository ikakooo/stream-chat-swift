//
// Copyright © 2024 Stream.io Inc. All rights reserved.
//

import CoreData

extension NSManagedObjectContext: DatabaseSession {}

protocol UserDatabaseSession {
    /// Saves the provided query to the DB. Return's the matching `UserListQueryDTO` if the save was successful. Throws an error
    /// if the save fails.
    @discardableResult
    func saveQuery(query: UserListQuery) throws -> UserListQueryDTO?

    /// Load user list query with the given hash.
    /// - Returns: The query hash.
    func userListQuery(filterHash: String) -> UserListQueryDTO?

    /// Fetches `UserDTO` with the given `id` from the DB. Returns `nil` if no `UserDTO` matching the `id` exists.
    func user(id: UserId) -> UserDTO?

    /// Removes the specified query from DB.
    func deleteQuery(_ query: UserListQuery)
}

protocol CurrentUserDatabaseSession {
    /// Updates the `CurrentUserDTO` with the provided unread.
    /// If there is no current user, the error will be thrown.
    func saveCurrentUserUnreadCount(count: UnreadCount) throws

    /// Saves the `currentDevice` for current user.
    func saveCurrentDevice(_ deviceId: String) throws

    /// Removes the device with the given id from DB.
    func deleteDevice(id: DeviceId)

    /// Returns `CurrentUserDTO` from the DB. Returns `nil` if no `CurrentUserDTO` exists.
    var currentUser: CurrentUserDTO? { get }
}

protocol MessageDatabaseSession {
    /// Creates a new `MessageDTO` object in the database. Throws an error if the message fails to be created.
    @discardableResult
    func createNewMessage(
        in cid: ChannelId,
        messageId: MessageId?,
        text: String,
        pinning: MessagePinning?,
        command: String?,
        arguments: String?,
        parentMessageId: MessageId?,
        attachments: [AnyAttachmentPayload],
        mentionedUserIds: [UserId],
        showReplyInChannel: Bool,
        isSilent: Bool,
        quotedMessageId: MessageId?,
        createdAt: Date?,
        skipPush: Bool,
        skipEnrichUrl: Bool,
        extraData: [String: RawJSON]
    ) throws -> MessageDTO
    
    @discardableResult
    func saveMessage(
        payload: Message,
        for cid: ChannelId?,
        syncOwnReactions: Bool,
        cache: PreWarmedCache?
    ) throws -> MessageDTO

    func addReaction(
        to messageId: MessageId,
        type: MessageReactionType,
        score: Int,
        enforceUnique: Bool,
        extraData: [String: RawJSON],
        localState: LocalReactionState?
    ) throws -> MessageReactionDTO

    func removeReaction(from messageId: MessageId, type: MessageReactionType, on version: String?) throws -> MessageReactionDTO?

    /// Pins the provided message
    /// - Parameters:
    ///   - message: The DTO to be pinned
    ///   - pinning: The pinning information, including the expiration.
    func pin(message: MessageDTO, pinning: MessagePinning) throws

    /// Unpins the provided message
    /// - Parameter message: The DTO to be unpinned
    func unpin(message: MessageDTO)

    /// Fetches `MessageDTO` with the given `id` from the DB. Returns `nil` if no `MessageDTO` matching the `id` exists.
    func message(id: MessageId) -> MessageDTO?

    /// Checks if a message exists without fetching the object
    func messageExists(id: MessageId) -> Bool

    /// Fetches preview message for channel  from the database.
    func preview(for cid: ChannelId) -> MessageDTO?

    /// Deletes the provided dto from a database
    /// - Parameter message: The DTO to be deleted
    func delete(message: MessageDTO)

    /// Fetches `MessageReactionDTO` for the given `messageId`, `userId`, and `type` from the DB.
    /// Returns `nil` if there is no matching `MessageReactionDTO`.
    func reaction(messageId: MessageId, userId: UserId, type: MessageReactionType) -> MessageReactionDTO?

    /// Deletes the provided dto from a database
    /// - Parameter reaction: The DTO to be deleted
    func delete(reaction: MessageReactionDTO)

    /// Changes the state to `.pendingSend` for all messages in `.sending` state. This method is expected to be used at the beginning of the session
    /// to avoid those from being stuck there in limbo.
    /// Messages can get stuck in `.sending` state if the network request to send them takes to much, and the app is backgrounded or killed.
    func rescueMessagesStuckInSending()
}

extension MessageDatabaseSession {
    /// Creates a new `MessageDTO` object in the database. Throws an error if the message fails to be created.
    @discardableResult
    func createNewMessage(
        in cid: ChannelId,
        messageId: MessageId?,
        text: String,
        pinning: MessagePinning?,
        quotedMessageId: MessageId?,
        isSilent: Bool = false,
        skipPush: Bool,
        skipEnrichUrl: Bool,
        attachments: [AnyAttachmentPayload] = [],
        mentionedUserIds: [UserId] = [],
        extraData: [String: RawJSON] = [:]
    ) throws -> MessageDTO {
        try createNewMessage(
            in: cid,
            messageId: messageId,
            text: text,
            pinning: pinning,
            command: nil,
            arguments: nil,
            parentMessageId: nil,
            attachments: attachments,
            mentionedUserIds: mentionedUserIds,
            showReplyInChannel: false,
            isSilent: isSilent,
            quotedMessageId: quotedMessageId,
            createdAt: nil,
            skipPush: skipPush,
            skipEnrichUrl: skipEnrichUrl,
            extraData: extraData
        )
    }
}

protocol MessageSearchDatabaseSession {
    func saveQuery(query: MessageSearchQuery) -> MessageSearchQueryDTO

    func deleteQuery(_ query: MessageSearchQuery)
}

protocol ChannelDatabaseSession {
    /// Loads channel list query with the given filter hash from the database.
    /// - Parameter filterHash: The filter hash.
    func channelListQuery(filterHash: String) -> ChannelListQueryDTO?

    /// Loads all channel list queries from the database.
    /// - Returns: The array of channel list queries.
    func loadAllChannelListQueries() -> [ChannelListQueryDTO]

    @discardableResult
    func saveQuery(query: ChannelListQuery) -> ChannelListQueryDTO

    /// Fetches `ChannelDTO` with the given `cid` from the database.
    func channel(cid: ChannelId) -> ChannelDTO?

    /// Removes channel list query from database.
    func delete(query: ChannelListQuery)

    /// Cleans a list of channels based on their id
    func cleanChannels(cids: Set<ChannelId>)

    /// Removes a list of channels based on their id
    func removeChannels(cids: Set<ChannelId>)
}

protocol ChannelReadDatabaseSession {
    /// Creates (if doesn't exist) and fetches  `ChannelReadDTO` with the given `cid` and `userId`
    /// from the DB.
    func loadOrCreateChannelRead(cid: ChannelId, userId: UserId) -> ChannelReadDTO?

    /// Fetches `ChannelReadDTO` with the given `cid` and `userId` from the DB.
    /// Returns `nil` if no `ChannelReadDTO` matching the `cid` and `userId`  exists.
    func loadChannelRead(cid: ChannelId, userId: UserId) -> ChannelReadDTO?

    /// Fetches `ChannelReadDTO`entities for the given `userId` from the DB.
    func loadChannelReads(for userId: UserId) -> [ChannelReadDTO]

    /// Sets the channel `cid` as read for `userId`
    func markChannelAsRead(cid: ChannelId, userId: UserId, at: Date)

    /// Sets the channel `cid` as unread for `userId` starting from the `messageId`
    /// Uses `lastReadAt` and `unreadMessagesCount` if passed, otherwise it calculates it.
    func markChannelAsUnread(
        for cid: ChannelId,
        userId: UserId,
        from messageId: MessageId,
        lastReadMessageId: MessageId?,
        lastReadAt: Date?,
        unreadMessagesCount: Int?
    )

    /// Removes the read object of the given user in the given channel if it exists.
    /// - Parameters:
    ///   - cid: The channel identifier which should be marked as unread.
    ///   - userId: The user identifier who's read should be removed.
    func markChannelAsUnread(cid: ChannelId, by userId: UserId)
}

protocol MemberDatabaseSession {
    /// Fetches `MemberDTO`entity for the given `userId` and `cid`.
    func member(userId: UserId, cid: ChannelId) -> MemberDTO?
}

protocol MemberListQueryDatabaseSession {
    /// Fetches `MemberListQueryDatabaseSession` entity for the given `filterHash`.
    func channelMemberListQuery(queryHash: String) -> ChannelMemberListQueryDTO?

    /// Creates a new `MemberListQueryDatabaseSession` object in the database based in the given `ChannelMemberListQuery`.
    @discardableResult
    func saveQuery(_ query: ChannelMemberListQuery) throws -> ChannelMemberListQueryDTO
}

protocol AttachmentDatabaseSession {
    /// Fetches `AttachmentDTO`entity for the given `id`.
    func attachment(id: AttachmentId) -> AttachmentDTO?

    /// Creates a new `AttachmentDTO` object in the database from the given model for the message
    /// with the given `messageId` in the channel with the given `cid`.
    @discardableResult
    func createNewAttachment(
        attachment: AnyAttachmentPayload,
        id: AttachmentId
    ) throws -> AttachmentDTO

    /// Deletes the provided dto from a database
    /// - Parameter attachment: The DTO to be deleted
    func delete(attachment: AttachmentDTO)
}

protocol QueuedRequestDatabaseSession {
    func deleteQueuedRequest(id: String)
}

protocol DatabaseSession: UserDatabaseSession,
    CurrentUserDatabaseSession,
    MessageDatabaseSession,
    MessageSearchDatabaseSession,
    ChannelReadDatabaseSession,
    ChannelDatabaseSession,
    MemberDatabaseSession,
    MemberListQueryDatabaseSession,
    AttachmentDatabaseSession,
    QueuedRequestDatabaseSession,
    ChannelDatabaseSessionV2 {}

extension DatabaseSession {
    // MARK: - Event
    
    func saveEvent(event: Event) throws {
        if let userEvent = event as? EventContainsUser, let user = userEvent.user {
            try saveUser(payload: user, query: nil, cache: nil)
        }
        
        if let channelEvent = event as? EventContainsChannel, let channel = channelEvent.channel {
            try saveChannel(payload: channel, query: nil, cache: nil)
        }
        
        if let messageEvent = event as? EventContainsMessage {
            try saveMessageIfNeeded(from: messageEvent)
        }
        
        if let currentUserEvent = event as? EventContainsCurrentUser, let currentUser = currentUserEvent.me {
            try saveCurrentUser(payload: currentUser)
        }
        
        if let unreadCountEvent = event as? EventContainsUnreadCount {
            try saveCurrentUserUnreadCount(count:
                UnreadCount(
                    channels: unreadCountEvent.unreadChannels,
                    messages: unreadCountEvent.totalUnreadCount
                )
            )
        }
        
        // handle reaction events for messages that already exist in the database and for this user
        // this is needed because WS events do not contain message.own_reactions
        if let userEvent = event as? EventContainsUser,
           let currentUser = self.currentUser,
           currentUser.user.id == userEvent.user?.id {
            if let newReaction = event as? ReactionNewEvent {
                let reaction = try saveReaction(payload: newReaction.reaction, cache: nil)
                if !reaction.message.ownReactions.contains(reaction.id) {
                    reaction.message.ownReactions.append(reaction.id)
                }
            } else if let updatedReaction = event as? ReactionUpdatedEvent {
                try saveReaction(payload: updatedReaction.reaction, cache: nil)
            } else if let deletedReaction = event as? ReactionDeletedEvent,
                      let messageId = deletedReaction.message?.id,
                      let userId = deletedReaction.user?.id {
                if let dto = reaction(
                    messageId: messageId,
                    userId: userId,
                    type: MessageReactionType(rawValue: deletedReaction.type)
                ) {
                    dto.message.ownReactions.removeAll(where: { $0 == dto.id })
                    delete(reaction: dto)
                }
            }
        }
        
        // TODO: Handle user unread count
        
        updateChannelPreview(from: event)
    }
    
    func saveMessageIfNeeded(from event: EventContainsMessage) throws {
        guard let messagePayload = event.message else {
            // Event does not contain message
            return
        }

        guard let cid = try? ChannelId(cid: event.cid) else {
            // Channel does not exist locally
            return
        }

        let messageExistsLocally = message(id: messagePayload.id) != nil
        let eventType = EventType(rawValue: event.type)
        let messageMustBeCreated = eventType.shouldCreateMessageInDatabase

        guard messageExistsLocally || messageMustBeCreated else {
            // Message does not exits locally and should not be saved
            return
        }

        let savedMessage = try saveMessage(
            payload: messagePayload,
            for: cid,
            syncOwnReactions: false,
            cache: nil
        )

        if eventType == .messageDeleted, let deletedEvent = event as? MessageDeletedEvent, deletedEvent.hardDelete {
            // We should in fact delete it from the DB, but right now this produces a crash
            // This should be fixed in this ticket: https://stream-io.atlassian.net/browse/CIS-1963
            savedMessage.isHardDeleted = true
            return
        }

        // When a message is updated, make sure to update
        // the messages quoting the edited message by triggering a DB Update.
        if eventType == .messageUpdated {
            savedMessage.quotedBy.forEach { message in
                message.updatedAt = savedMessage.updatedAt
            }
        }

        let isNewMessage = eventType == .messageNew || eventType == .notificationMessageNew
        let isThreadReply = savedMessage.parentMessageId != nil
        if isNewMessage && isThreadReply {
            savedMessage.showInsideThread = true
        }
    }
    
    func updateChannelPreview(from event: Event) {
        if let newMessage = event as? MessageNewEvent,
           let cid = try? ChannelId(cid: newMessage.cid),
           let channelDTO = channel(cid: cid) {
            let newPreview = preview(for: cid)
            let newPreviewCreatedAt = newPreview?.createdAt.bridgeDate ?? .distantFuture
            let currentPreviewCreatedAt = channelDTO.previewMessage?.createdAt.bridgeDate ?? .distantPast
            if newPreviewCreatedAt > currentPreviewCreatedAt {
                channelDTO.previewMessage = newPreview
            }
        }

        // TODO: handle other events
    }
}

private extension EventType {
    var shouldCreateMessageInDatabase: Bool {
        [.channelUpdated, .messageNew, .notificationMessageNew, .channelTruncated].contains(self)
    }
}

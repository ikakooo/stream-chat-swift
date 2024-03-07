//
// Copyright © 2024 Stream.io Inc. All rights reserved.
//

import Foundation

extension BidirectionalCollection {
    /// Merges sorted elements into a sorted collection.
    ///
    /// - Parameters:
    ///   - newElements: A collection for sorted elements to be inserted.
    ///   - areInIncreasingOrder: A predicate that returns true if its first argument should be ordered before its second argument; otherwise, false.
    ///   - dropsExisting: A predicate what returns true if its first argument should be dropped before its second argument is inserted to the resulting sorted collection.
    func uniquelyMerged(_ insertedSortedElements: [Element], areInIncreasingOrder: (Element, Element) -> Bool, dropsExisting: (Element, Element) -> Bool) -> [Element] {
        func insert(_ merged: inout [Element], newElement: Element) {
            if let last = merged.last, dropsExisting(last, newElement) {
                merged.removeLast()
            }
            merged.append(newElement)
        }

        var merged = [Element]()
        merged.reserveCapacity(count + insertedSortedElements.count)
        
        var currentElementIndex = startIndex
        var newElementIndex = insertedSortedElements.startIndex
        while currentElementIndex < endIndex, newElementIndex < insertedSortedElements.endIndex {
            if areInIncreasingOrder(self[currentElementIndex], insertedSortedElements[newElementIndex]) {
                insert(&merged, newElement: self[currentElementIndex])
                currentElementIndex = index(after: currentElementIndex)
            } else {
                insert(&merged, newElement: insertedSortedElements[newElementIndex])
                newElementIndex = insertedSortedElements.index(after: newElementIndex)
            }
        }
        while currentElementIndex < endIndex {
            insert(&merged, newElement: self[currentElementIndex])
            currentElementIndex = index(after: currentElementIndex)
        }
        while newElementIndex < insertedSortedElements.endIndex {
            insert(&merged, newElement: insertedSortedElements[newElementIndex])
            newElementIndex = insertedSortedElements.index(after: newElementIndex)
        }
        return merged
        
        /*
         extension BidirectionalCollection {
             /// Merges sorted elements into a sorted collection.
             ///
             /// - Parameters:
             ///   - newElements: A collection for sorted elements to be inserted.
             ///   - areInIncreasingOrder: A predicate that returns true if its first argument should be ordered before its second argument; otherwise, false.
             ///   - uniquingKeyPath: A keypath which defines the uniquness of the element.
             func uniquelyMerged<UniqueID: Hashable>(_ insertedSortedElements: [Element], areInIncreasingOrder: (Element, Element) -> Bool, uniquingKeyPath: KeyPath<Element, UniqueID>) -> [Element] {
                 let newIds = Set(insertedSortedElements.map({ $0[keyPath: uniquingKeyPath] }))
                 var merged = [Element]()
                 merged.reserveCapacity(count + insertedSortedElements.count)
                 
                 var currentElementIndex = startIndex
                 var newElementIndex = insertedSortedElements.startIndex
                 while currentElementIndex < endIndex, newElementIndex < insertedSortedElements.endIndex {
                     if newIds.contains(self[currentElementIndex][keyPath: uniquingKeyPath]) {
                         // Skip existing element if inserted element with the same identify is incoming
                         currentElementIndex = index(after: currentElementIndex)
                     }
                     else if areInIncreasingOrder(self[currentElementIndex], insertedSortedElements[newElementIndex]) {
                         merged.append(self[currentElementIndex])
                         currentElementIndex = index(after: currentElementIndex)
                     } else {
                         merged.append(insertedSortedElements[newElementIndex])
                         newElementIndex = insertedSortedElements.index(after: newElementIndex)
                     }
                 }
                 while currentElementIndex < endIndex {
                     if newIds.contains(self[currentElementIndex][keyPath: uniquingKeyPath]) {
                         merged.append(self[currentElementIndex])
                     }
                     currentElementIndex = index(after: currentElementIndex)
                 }
                 while newElementIndex < insertedSortedElements.endIndex {
                     merged.append(insertedSortedElements[newElementIndex])
                     newElementIndex = insertedSortedElements.index(after: newElementIndex)
                 }
                 return merged
             }
         }
         
         */
    }
}

extension BidirectionalCollection where Element == ChatMessage {
    func uniquelyMerged(_ insertedSortedElements: [Element]) -> [Element] {
        uniquelyMerged(insertedSortedElements, areInIncreasingOrder: { first, second in first.createdAt < second.createdAt }, dropsExisting: { first, second in first.id == second.id })
    }
    
    func uniquelyApplied(_ changes: [ListChange<Element>]) -> [Element] {
        var removedIds = Set<MessageId>()
        var newSortedElements = [Element]()
        newSortedElements.reserveCapacity(changes.count)
        
        for change in changes {
            if change.isRemove {
                removedIds.insert(change.item.id)
            } else {
                newSortedElements.append(change.item)
            }
        }
                
        newSortedElements = newSortedElements.sort(using: [.init(keyPath: \.createdAt, isAscending: true)])
        return uniquelyMerged(
            newSortedElements,
            areInIncreasingOrder: { $0.createdAt < $1.createdAt },
            dropsExisting: { existing, incoming in
                removedIds.contains(existing.id) || existing.id == incoming.id
            }
        )
    }
}

extension BidirectionalCollection where Element == ChatChannel {
    func uniquelyMerged(_ insertedSortedElements: [Element], sortValues: [SortValue<ChatChannel>]) -> [Element] {
        validateDuplicates(Array(self))
        validateDuplicates(insertedSortedElements)
        
        validateSorting(Array(self), sortValues: sortValues)
        validateSorting(insertedSortedElements, sortValues: sortValues)
        
        let result = uniquelyMerged(
            insertedSortedElements,
//            areInIncreasingOrder: { sortValues.areInIncreasingOrder($0, $1) },
            areInIncreasingOrder: { [$0, $1].sort(using: sortValues).first?.cid == $0.cid },
            dropsExisting: { existing, incoming in
                existing.cid == incoming.cid
            }
        )
        
        validateDuplicates(result)
        return result
    }
    
    func uniquelyApplied(_ changes: [ListChange<Element>], sortValues: [SortValue<ChatChannel>]) -> [Element] {
        validateDuplicates(Array(self))
        validateSorting(Array(self), sortValues: sortValues)
        
        var removedIds = Set<ChannelId>()
        var updatedElements = [Element]()
        updatedElements.reserveCapacity(changes.count)
        
        for change in changes {
            if change.isRemove {
                removedIds.insert(change.item.cid)
            } else {
                updatedElements.append(change.item)
            }
        }
        let insertedSortedElements = updatedElements.sort(using: sortValues)
        var result = uniquelyMerged(
            insertedSortedElements,
//            areInIncreasingOrder: { sortValues.areInIncreasingOrder($0, $1) },
            areInIncreasingOrder: { [$0, $1].sort(using: sortValues).first?.cid == $0.cid },
            dropsExisting: { existing, incoming in
                removedIds.contains(existing.cid) || existing.cid == incoming.cid
            }
        )
        
        validateSorting(insertedSortedElements, sortValues: sortValues)
        validateDuplicates(insertedSortedElements)
        validateDuplicates(result)
        return result
    }
}

func validateDuplicates(_ array: [ChatChannel]) {
    let count = Set(array.map(\.cid.rawValue)).count
    if count != array.count {
        assertionFailure("Duplicates")
    }
}

func validateSorting(_ array: [ChatChannel], sortValues: [SortValue<ChatChannel>]) {
    let sorted = array.sort(using: sortValues)
    let cids = array.map(\.cid.rawValue)
    let sortedCids = sorted.map(\.cid.rawValue)
    
    if cids != sortedCids {
        assertionFailure("Sorting")
    }
}

//
//  FeedingFacade.swift
//  Baby Tracker
//
//  Created by Jason Zurita on 12/9/16.
//  Copyright © 2016 Jason Zurita. All rights reserved.
//

import Foundation

protocol FeedingEvent {
    var feedingType:FeedingType { get }
    var side:FeedingSide { get }
    init(start:Date, end:Date?, side:FeedingSide)
    mutating func endEvent()
    func eventJson() throws -> [String:String]
}

class FeedingFacade {
    
    private let shouldPrintDebugString = true
    private var database = FirebaseFacade()
    private var feedingsInProgress:[FeedingEvent] = []
    
    let nursing = Nursing()
    
    func loadData(completionHandler:@escaping (Void) -> Void) {

        database.configureDatabase(requestType: .nursing, responseHandler: { jsonArray in
            for json in jsonArray {
                self.nursing.processNewNursing(json: json)
            }
            completionHandler()
        })
    }
    
    func timeSinceLastFeeding() -> TimeInterval {
        return nursing.timeSinceLastFeeding()
    }
    
    func lastFeedingSide() -> FeedingSide {
        return nursing.lastFeedingSide()
    }
    
    func feedingStarted(type:FeedingType, start:Date, side:FeedingSide) {
        switch type {
        case .nursing:
            let nursingEvent = NursingEvent(start: start, end: nil, side: side)
            feedingsInProgress.append(nursingEvent)
        case .pumping:
            break
        case .bottle:
            break
        }
    }
    
    func feedingEnded(type:FeedingType, side:FeedingSide) {
        let feedingEvents = feedingsInProgress.filter { $0.side == side && $0.feedingType == type }
        
        guard var event = feedingEvents.first, feedingEvents.count == 1 else {
            printDebugString(string: "Somehow there was either 0 or more than one feeding event to end of the same type and side...")
            return
        }
        
        event.endEvent()
        addFeedingEvent(event: event)
    }
    
    func addFeedingEvent(event:FeedingEvent) {
        
        try! database.uploadFeedingEvent(withData: event.eventJson(), requestType: event.feedingType)
        
        switch event.feedingType {
        case .nursing:
            nursing.nursings.append(event as! NursingEvent)
        case .bottle:
            break
        case .pumping:
            
            break
        }
    }
    
    private func printDebugString(string:String) {
        if shouldPrintDebugString {
            print(String(describing: "-- Debug -- \(type(of:self)): " + string))
        }
    }
}

@testable import Framework_BabyPatterns
import PlaygroundSupport
import UIKit

UIFont.registerFonts

struct MockEvent: Event {
    let endDate: Date
    let type: FeedingType
    let duration: TimeInterval
    let supplyAmount: SupplyAmount

    init(hours: TimeInterval,
         _ type: FeedingType,
         _ duration: TimeInterval,
         _ supplyAmount: SupplyAmount) {
        let date = Date(timeIntervalSinceNow: -hours * 60 * 60)
        endDate = date
        self.type = type
        self.duration = duration
        self.supplyAmount = supplyAmount
    }
}

let amount = SupplyAmount(value: 2551)

func avg(window: DateInterval) -> TimeInterval {
    return 365
}

struct FeedingSummary: FeedingSummaryProtocol {
    let timeSinceLastNursing: TimeInterval = 60
    let lastNursingSide: FeedingSide = .left
    let averageNursingDuration: (DateInterval) -> TimeInterval = avg
    let timeSinceLastPumping: TimeInterval = 120
    let lastPumpingSide: FeedingSide = .right
    let lastPumpedAmount: SupplyAmount = amount
    let timeSinceLastBottleFeeding: TimeInterval = 1000
    let remainingSupplyAmount: SupplyAmount = amount
    let desiredSupplyAmount: SupplyAmount = amount
}

let events = [
    MockEvent(hours: 0, .nursing, 5, amount),
    MockEvent(hours: 1, .nursing, 5, amount),
    MockEvent(hours: 1.5, .nursing, 5, amount),
    MockEvent(hours: 2, .nursing, 5, amount),
    MockEvent(hours: 3, .bottle, 5, amount),
    MockEvent(hours: 4, .bottle, 5, amount),
    MockEvent(hours: 6, .bottle, 5, amount),
    MockEvent(hours: 12, .bottle, 5, amount),
    MockEvent(hours: 24, .pumping, 5, amount),
    MockEvent(hours: 60, .bottle, 5, amount),
    MockEvent(hours: 7 * 24, .nursing, 5, amount),
]

let summary = FeedingSummary()

let vc = HistoryVc(events: events, summary: summary)

let parent = playgroundWrapper(child: vc,
                               device: .phone4inch,
                               orientation: .portrait,
                               contentSizeCategory: .accessibilityMedium)
PlaygroundPage.current.liveView = parent

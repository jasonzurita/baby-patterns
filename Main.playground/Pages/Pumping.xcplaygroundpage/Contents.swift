@testable import Framework_BabyPatterns
import PlaygroundSupport
import UIKit

struct Controller: PumpingController {
    func start(feeding type: FeedingType, side: FeedingSide) {
        print("start: feeding type - \(type), side - \(side)")
    }

    func end(feeding type: FeedingType, side: FeedingSide) {
        print("End: feeding type - \(type), side - \(side)")
    }

    func pause(feeeding type: FeedingType, side: FeedingSide) {
        print("Pause: feeding type - \(type), side - \(side)")
    }

    func resume(feeding type: FeedingType, side: FeedingSide) {
        print("Resume: feeding type - \(type), side - \(side)")
    }

    func pumpingAmountChosen(_ amount: Double) {
        print("Amount chosen: \(amount)")
    }
}

let feeding = Feeding(type: .nursing, side: .right, startDate: Date())
let c = Controller()
let vc = PumpingVC(controller: c)
vc.resume(feeding: feeding)

let parent = playgroundWrapper(child: vc,
                               device: .phone4inch,
                               orientation: .portrait,
                               contentSizeCategory: .accessibilityMedium)

PlaygroundPage.current.liveView = parent
import SwiftUI

/*
 TODO: - V1 Watch
 - Polish UI
 - Get pause to actually pause
 - Make sure a backgrounded/terminated main app
   behaves well from a UI standpoint when using the watch
 - Think about subscriptions or IAP for this
 - Load all feedings when starting up?
 - Make sure iPhone is available and logged in
 - What to do with bottle feeding?
 */

struct HomeView: View {
    @ObservedObject var store: Store<AppState, AppAction> = {
        let s = Store(initialValue: AppState(), reducer: appReducer)
        TimerPulse.shared.store = s
        TimerPulse.shared.start()
        return s
    }()

    @State private var isShowingSheet = false
    var body: some View {
        // TODO: think more about the layout of these two
        VStack {
            List(store.value.activeFeedings.reversed()) { feeding in
                HStack {
                    Spacer()
                    FeedingView(store: self.store, feeding: feeding)
                        .layoutPriority(1.0)
                    Spacer()
                }
            }

            // TODO: better style this
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 55))
                .rotationEffect(.init(degrees: 45))
                .offset(y: -10)
                .sheet(isPresented: $isShowingSheet) {
                    AddFeedingView(store: self.store, isShowingSheet: self.$isShowingSheet)
                }
                .gesture(TapGesture().onEnded {
                    self.isShowingSheet.toggle()
                })
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

// swiftlint:disable type_name
struct HomeView_Previews: PreviewProvider {
// swiftlint:enable type_name
    static var previews: some View {
        HomeView()
    }
}

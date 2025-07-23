import SwiftUI

struct MainView: View {
    @State private var focusMinutes: Int = 0
    var body: some View {
        VStack {
            Text("Today's Focus")
                .font(.headline)
            Text("\(focusMinutes) min")
                .font(.largeTitle)
                .bold()
        }
        .padding()
        .onAppear {
            focusMinutes = FocusDetectionEngine.shared.todayFocusMinutes()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

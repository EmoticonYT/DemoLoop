import SwiftUI

struct ContentView: View {
    @State private var showMenu = false
    
    var body: some View {
        ZStack {
            VideoPlayerView()
                .edgesIgnoringSafeArea(.all)
            
            MultiFingerGestureRecognizer {
                showMenu = true
            }
        }
        .sheet(isPresented: $showMenu) {
            StatusMenuView()
        }
    }
}

#Preview {
    ContentView()
}

import SwiftUI

#if canImport(UIKit)
import UIKit

struct MultiFingerGestureRecognizer: UIViewRepresentable {
    var onTrigger: () -> Void
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let gesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleGesture))
        gesture.numberOfTouchesRequired = 3
        gesture.minimumPressDuration = 1.0
        view.addGestureRecognizer(gesture)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onTrigger: onTrigger)
    }
    
    class Coordinator: NSObject {
        var onTrigger: () -> Void
        init(onTrigger: @escaping () -> Void) { self.onTrigger = onTrigger }
        
        @objc func handleGesture(_ gesture: UILongPressGestureRecognizer) {
            if gesture.state == .began {
                onTrigger()
            }
        }
    }
}
#else
struct MultiFingerGestureRecognizer: View {
    var onTrigger: () -> Void
    var body: some View {
        Color.clear
    }
}
#endif

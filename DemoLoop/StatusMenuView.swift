import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

struct StatusMenuView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showUnenrollConfirmation = false
    
    // Fallback device info for non-UIKit platforms
    var deviceName: String {
        #if canImport(UIKit)
        return UIDevice.current.model
        #else
        return "Mac"
        #endif
    }
    
    var osVersion: String {
        #if canImport(UIKit)
        return "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
        #else
        return "macOS"
        #endif
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("This Device")) {
                    LabeledContent("Device", value: deviceName)
                    LabeledContent("OS Version", value: osVersion)
                }
                
                Section(header: Text("This Store")) {
                    LabeledContent("Store ID", value: "107580")
                }
                
                Section {
                    Button("Unenroll", role: .destructive) {
                        showUnenrollConfirmation = true
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                
                Section {
                    Button("Run Network Check") {
                        // Action
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Status")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .confirmationDialog("Would you like to Unenroll this Device?", isPresented: $showUnenrollConfirmation, titleVisibility: .visible) {
                Button("Unenroll and Keep Demo Content", role: .none) {
                    fatalError("Unenrolled!")
                }
                Button("Unenroll and Erase Demo Content", role: .destructive) {
                    fatalError("Unenrolled!")
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This action cannot be undone.")
            }
        }
    }
}

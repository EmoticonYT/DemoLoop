import SwiftUI
import AVKit
#if canImport(UIKit)
import UIKit
#endif

struct VideoPlayerView: View {
    @State private var assetType: AssetType?
    
    enum AssetType {
        case video(URL)
#if canImport(UIKit)
        case image(UIImage)
#endif
    }
    
    var body: some View {
        Group {
            if let type = assetType {
                switch type {
                case .video(let url):
                    VideoPlayerWrapper(url: url)
#if canImport(UIKit)
                case .image(let image):
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
#endif
                }
            } else {
                Color.black.onAppear(perform: validateAssets)
            }
        }
    }
    
    func validateAssets() {
        let movURL = Bundle.main.url(forResource: "movie", withExtension: "mov")
        let mp4URL = Bundle.main.url(forResource: "movie", withExtension: "mp4")
        let pngURL = Bundle.main.url(forResource: "movie", withExtension: "png")
        let jpgURL = Bundle.main.url(forResource: "movie", withExtension: "jpg")
        let jpegURL = Bundle.main.url(forResource: "movie", withExtension: "jpeg")
        
        let assets = [movURL, mp4URL, pngURL, jpgURL, jpegURL].compactMap { $0 }
        
        if assets.count > 1 {
            fatalError("Multiple movie files found in bundle: \(assets). Please include exactly one.")
        } else if assets.isEmpty {
            fatalError("No movie file (mov, mp4, png, jpg, jpeg) found in bundle.")
        }
        
        let url = assets[0]
        let ext = url.pathExtension.lowercased()
#if canImport(UIKit)
        if ext == "png" || ext == "jpg" || ext == "jpeg" {
            if let image = UIImage(contentsOfFile: url.path) {
                assetType = .image(image)
            } else {
                fatalError("Could not load image at \(url.path)")
            }
        } else {
            assetType = .video(url)
        }
#else
        assetType = .video(url)
#endif
    }
}

#if canImport(UIKit)
struct VideoPlayerWrapper: UIViewControllerRepresentable {
    let url: URL
    
    class Coordinator {
        var player: AVQueuePlayer?
        var looper: AVPlayerLooper?
        
        init(url: URL) {
            let player = AVQueuePlayer()
            let playerItem = AVPlayerItem(url: url)
            self.looper = AVPlayerLooper(player: player, templateItem: playerItem)
            self.player = player
            player.play()
        }
        
        func restartPlayback() {
            player?.seek(to: .zero)
            player?.play()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(url: url)
    }
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        controller.player = context.coordinator.player
        
        // Restart playback when the scene becomes active
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { _ in
            context.coordinator.restartPlayback()
        }
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {}
}
#else
// Placeholder for macOS video player
struct VideoPlayerWrapper: View {
    let url: URL
    var body: some View {
        VideoPlayer(player: AVPlayer(url: url))
            .onAppear {
                // macOS AVPlayer handling
            }
    }
}
#endif

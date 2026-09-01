import SwiftUI
import AVFoundation

#if os(macOS)
import AppKit

/// Clean, hardware-accelerated video rendering surface with zero default OS controls.
public struct VideoSurfaceView: NSViewRepresentable {
    public let player: AVPlayer
    
    public init(player: AVPlayer) {
        self.player = player
    }
    
    public func makeNSView(context: Context) -> AVPlayerLayerView {
        let view = AVPlayerLayerView()
        view.playerLayer.player = player
        view.playerLayer.videoGravity = .resizeAspect
        return view
    }
    
    public func updateNSView(_ nsView: AVPlayerLayerView, context: Context) {
        nsView.playerLayer.player = player
    }
    
    public final class AVPlayerLayerView: NSView {
        public override init(frame frameRect: NSRect) {
            super.init(frame: frameRect)
            wantsLayer = true
            layer = AVPlayerLayer()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public var playerLayer: AVPlayerLayer {
            layer as! AVPlayerLayer
        }
        
        public override func layout() {
            super.layout()
            playerLayer.frame = bounds
        }
    }
}
#else
import UIKit

/// Clean, hardware-accelerated video rendering surface with zero default OS controls.
public struct VideoSurfaceView: UIViewRepresentable {
    public let player: AVPlayer
    
    public init(player: AVPlayer) {
        self.player = player
    }
    
    public func makeUIView(context: Context) -> AVPlayerLayerView {
        let view = AVPlayerLayerView()
        view.playerLayer.player = player
        view.playerLayer.videoGravity = .resizeAspect
        return view
    }
    
    public func updateUIView(_ uiView: AVPlayerLayerView, context: Context) {
        uiView.playerLayer.player = player
    }
    
    public final class AVPlayerLayerView: UIView {
        public override static var layerClass: AnyClass {
            AVPlayerLayer.self
        }
        
        public var playerLayer: AVPlayerLayer {
            layer as! AVPlayerLayer
        }
    }
}
#endif

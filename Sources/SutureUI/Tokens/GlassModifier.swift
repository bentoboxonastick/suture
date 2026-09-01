import SwiftUI

public struct SutureGlassCardModifier: ViewModifier {
    public var cornerRadius: CGFloat
    public var borderColor: Color
    
    public init(cornerRadius: CGFloat = 12, borderColor: Color = .sutureBorder.opacity(0.6)) {
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
    }
    
    public func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(borderColor, lineWidth: 1)
            )
    }
}

public struct SutureAmbientGlowModifier: ViewModifier {
    public var glowColor: Color
    public var radius: CGFloat
    public var opacity: Double
    
    public init(glowColor: Color = .sutureCrimson, radius: CGFloat = 40, opacity: Double = 0.35) {
        self.glowColor = glowColor
        self.radius = radius
        self.opacity = opacity
    }
    
    public func body(content: Content) -> some View {
        content
            .background(
                glowColor
                    .opacity(opacity)
                    .blur(radius: radius)
            )
    }
}

public extension View {
    func sutureGlassCard(cornerRadius: CGFloat = 12, borderColor: Color = .sutureBorder.opacity(0.6)) -> some View {
        modifier(SutureGlassCardModifier(cornerRadius: cornerRadius, borderColor: borderColor))
    }
    
    func sutureAmbientGlow(glowColor: Color = .sutureCrimson, radius: CGFloat = 40, opacity: Double = 0.35) -> some View {
        modifier(SutureAmbientGlowModifier(glowColor: glowColor, radius: radius, opacity: opacity))
    }
}

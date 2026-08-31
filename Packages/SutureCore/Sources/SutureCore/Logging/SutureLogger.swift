import Foundation
import os

/// Structured logging wrapper utilizing Apple's unified logging system.
public enum SutureLogger {
    private static let subsystem = "com.suture.app"
    
    public static let core = Logger(subsystem: subsystem, category: "Core")
    public static let storage = Logger(subsystem: subsystem, category: "Storage")
    public static let ui = Logger(subsystem: subsystem, category: "UI")
    public static let stremio = Logger(subsystem: subsystem, category: "Stremio")
    public static let iptv = Logger(subsystem: subsystem, category: "IPTV")
    public static let music = Logger(subsystem: subsystem, category: "Music")
    public static let tracking = Logger(subsystem: subsystem, category: "Tracking")
    public static let player = Logger(subsystem: subsystem, category: "Player")
}

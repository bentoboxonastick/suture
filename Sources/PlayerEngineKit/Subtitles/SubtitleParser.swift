import Foundation
import SutureCore

public struct SubtitleCue: Sendable, Identifiable {
    public let id: Int
    public let startTime: TimeInterval
    public let endTime: TimeInterval
    public let text: String
    
    public init(id: Int, startTime: TimeInterval, endTime: TimeInterval, text: String) {
        self.id = id
        self.startTime = startTime
        self.endTime = endTime
        self.text = text
    }
}

/// Parser for SRT (SubRip) and VTT (WebVTT) sidecar subtitle tracks.
public enum SubtitleParser {
    
    public static func parse(content: String, format: SubtitleFormat) -> [SubtitleCue] {
        switch format {
        case .srt:
            return parseSRT(content)
        case .vtt:
            return parseVTT(content)
        default:
            return parseSRT(content)
        }
    }
    
    private static func parseSRT(_ content: String) -> [SubtitleCue] {
        var cues: [SubtitleCue] = []
        let blocks = content.components(separatedBy: "\n\n")
        
        for (index, block) in blocks.enumerated() {
            let lines = block.components(separatedBy: .newlines).filter { !$0.isEmpty }
            guard lines.count >= 2 else { continue }
            
            // Find timing line (contains "-->")
            guard let timeLine = lines.first(where: { $0.contains("-->") }) else { continue }
            let times = timeLine.components(separatedBy: "-->")
            guard times.count == 2 else { continue }
            
            let start = parseTimestamp(times[0].trimmingCharacters(in: .whitespaces))
            let end = parseTimestamp(times[1].trimmingCharacters(in: .whitespaces))
            
            let textLines = lines.filter { $0 != timeLine && Int($0) == nil }
            let text = textLines.joined(separator: "\n")
            
            if !text.isEmpty {
                cues.append(SubtitleCue(id: index + 1, startTime: start, endTime: end, text: text))
            }
        }
        
        return cues
    }
    
    private static func parseVTT(_ content: String) -> [SubtitleCue] {
        var cues: [SubtitleCue] = []
        let cleaned = content.replacingOccurrences(of: "WEBVTT", with: "")
        let blocks = cleaned.components(separatedBy: "\n\n")
        
        for (index, block) in blocks.enumerated() {
            let lines = block.components(separatedBy: .newlines).filter { !$0.isEmpty }
            guard let timeLine = lines.first(where: { $0.contains("-->") }) else { continue }
            let times = timeLine.components(separatedBy: "-->")
            guard times.count == 2 else { continue }
            
            let start = parseTimestamp(times[0].trimmingCharacters(in: .whitespaces))
            let end = parseTimestamp(times[1].trimmingCharacters(in: .whitespaces))
            
            let textLines = lines.filter { $0 != timeLine && !timeLine.hasPrefix("NOTE") }
            let text = textLines.joined(separator: "\n")
            
            if !text.isEmpty {
                cues.append(SubtitleCue(id: index + 1, startTime: start, endTime: end, text: text))
            }
        }
        
        return cues
    }
    
    private static func parseTimestamp(_ raw: String) -> TimeInterval {
        // Formats: 00:01:23,456 or 00:01:23.456 or 01:23.456
        let sanitized = raw.replacingOccurrences(of: ",", with: ".")
        let parts = sanitized.components(separatedBy: ":")
        
        if parts.count == 3 {
            let hours = Double(parts[0]) ?? 0
            let minutes = Double(parts[1]) ?? 0
            let seconds = Double(parts[2]) ?? 0
            return (hours * 3600) + (minutes * 60) + seconds
        } else if parts.count == 2 {
            let minutes = Double(parts[0]) ?? 0
            let seconds = Double(parts[1]) ?? 0
            return (minutes * 60) + seconds
        }
        
        return 0
    }
}

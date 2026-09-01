import SwiftUI
import SutureCore

public struct EpisodeItem: Identifiable, Sendable {
    public let id: String
    public let episodeNumber: Int
    public let seasonNumber: Int
    public let title: String
    public let overview: String?
    public let duration: TimeInterval
    public let thumbnailURL: URL?
    public let watchProgress: Double?
    
    public init(
        id: String,
        episodeNumber: Int,
        seasonNumber: Int,
        title: String,
        overview: String? = nil,
        duration: TimeInterval = 2700,
        thumbnailURL: URL? = nil,
        watchProgress: Double? = nil
    ) {
        self.id = id
        self.episodeNumber = episodeNumber
        self.seasonNumber = seasonNumber
        self.title = title
        self.overview = overview
        self.duration = duration
        self.thumbnailURL = thumbnailURL
        self.watchProgress = watchProgress
    }
    
    public var formattedDuration: String {
        let minutes = Int(duration) / 60
        return "\(minutes)m"
    }
}

public struct SeasonEpisodePicker: View {
    public let seasons: [Int]
    public let episodesBySeason: [Int: [EpisodeItem]]
    public var onSelectEpisode: (EpisodeItem) -> Void
    
    @State private var selectedSeason: Int
    
    public init(
        seasons: [Int] = [1, 2],
        episodesBySeason: [Int: [EpisodeItem]] = [:],
        initialSeason: Int = 1,
        onSelectEpisode: @escaping (EpisodeItem) -> Void
    ) {
        self.seasons = seasons
        self.episodesBySeason = episodesBySeason
        _selectedSeason = State(initialValue: initialSeason)
        self.onSelectEpisode = onSelectEpisode
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Season Selector
            HStack {
                Text("Episodes")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.sutureTextPrimary)
                
                Spacer()
                
                Menu {
                    ForEach(seasons, id: \.self) { season in
                        Button("Season \(season)") {
                            selectedSeason = season
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Text("Season \(selectedSeason)")
                            .font(.system(size: 14, weight: .semibold))
                        Image(systemName: "chevron.down")
                            .font(.system(size: 11, weight: .bold))
                    }
                    .foregroundStyle(Color.sutureTextPrimary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.sutureElevated)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule().stroke(Color.sutureBorder.opacity(0.6), lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
            }
            
            // Episodes List
            let currentEpisodes = episodesBySeason[selectedSeason] ?? sampleEpisodes(for: selectedSeason)
            
            VStack(spacing: 12) {
                ForEach(currentEpisodes) { episode in
                    episodeRow(episode: episode)
                }
            }
        }
    }
    
    private func episodeRow(episode: EpisodeItem) -> some View {
        Button {
            onSelectEpisode(episode)
        } label: {
            HStack(alignment: .top, spacing: 14) {
                // Episode Number
                Text("\(episode.episodeNumber)")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.sutureTextTertiary)
                    .frame(width: 24)
                    .padding(.top, 18)
                
                // Thumbnail
                ZStack(alignment: .center) {
                    AsyncImage(url: episode.thumbnailURL ?? URL(string: "https://peach.blender.org/wp-content/uploads/bbb-splash.png")) { phase in
                        switch phase {
                        case .empty:
                            Color.sutureSurface
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure:
                            Color.sutureElevated
                        @unknown default:
                            Color.sutureSurface
                        }
                    }
                    .frame(width: 120, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.white.opacity(0.9))
                        .shadow(color: .black.opacity(0.6), radius: 4)
                }
                
                // Episode Info
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(episode.title)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(Color.sutureTextPrimary)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Text(episode.formattedDuration)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(Color.sutureTextSecondary)
                    }
                    
                    if let overview = episode.overview {
                        Text(overview)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(Color.sutureTextSecondary)
                            .lineLimit(2)
                    }
                }
            }
            .padding(10)
            .background(Color.sutureSurface)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .buttonStyle(.plain)
    }
    
    private func sampleEpisodes(for season: Int) -> [EpisodeItem] {
        [
            EpisodeItem(
                id: "ep_\(season)_1",
                episodeNumber: 1,
                seasonNumber: season,
                title: "Chapter 1: The Genesis",
                overview: "A lone explorer ventures into the digital frontier and discovers an uncharted nexus of media streams.",
                duration: 3120
            ),
            EpisodeItem(
                id: "ep_\(season)_2",
                episodeNumber: 2,
                seasonNumber: season,
                title: "Chapter 2: The Suture Protocol",
                overview: "Alliances are forged across disparate streaming worlds as the stitches begin to hold together.",
                duration: 2890
            ),
            EpisodeItem(
                id: "ep_\(season)_3",
                episodeNumber: 3,
                seasonNumber: season,
                title: "Chapter 3: The High-Res Awakening",
                overview: "A revelation in audiophile sound waves changes the trajectory of the living room hub forever.",
                duration: 3450
            )
        ]
    }
}

#Preview("Season Episode Picker") {
    ZStack {
        Color.suturePitch.ignoresSafeArea()
        ScrollView {
            SeasonEpisodePicker { _ in }
                .padding()
        }
    }
}

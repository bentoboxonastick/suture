import Foundation
import SutureCore

public enum MockData {
    
    // MARK: - Open-Source / Creative Commons Movies
    public static let tearsOfSteel = SutureMediaItem(
        id: "cc_tears_of_steel",
        type: .movie,
        title: "Tears of Steel",
        subtitle: "VFX Sci-Fi Showcase",
        overview: "In a dystopian future, a group of scientists and warriors in Amsterdam attempt to rescue humanity from robot domination using an experimental time rift.",
        releaseYear: 2012,
        rating: 8.2,
        duration: 734,
        posterURL: URL(string: "https://mango.blender.org/wp-content/uploads/2012/09/poster_tos_small.jpg"),
        backdropURL: URL(string: "https://mango.blender.org/wp-content/uploads/2012/09/01_render_bridge.jpg"),
        previewVideoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4"),
        imdbId: "tt2285752",
        genres: ["Sci-Fi", "Action", "Short"]
    )
    
    public static let bigBuckBunny = SutureMediaItem(
        id: "cc_big_buck_bunny",
        type: .movie,
        title: "Big Buck Bunny",
        subtitle: "Classic 3D Animation",
        overview: "A large, gentle rabbit is bullied by three mischievous forest critters until he devises a cunning and hilarious plan to fight back.",
        releaseYear: 2008,
        rating: 8.0,
        duration: 596,
        posterURL: URL(string: "https://peach.blender.org/wp-content/uploads/bbb-splash.png"),
        backdropURL: URL(string: "https://peach.blender.org/wp-content/uploads/poster_bunny_small.jpg"),
        previewVideoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"),
        imdbId: "tt1254207",
        genres: ["Animation", "Comedy", "Short"]
    )
    
    public static let sintel = SutureMediaItem(
        id: "cc_sintel",
        type: .movie,
        title: "Sintel",
        subtitle: "Fantasy Adventure",
        overview: "A lonely young woman searches the world for a baby dragon she befriended and nursed back to health after it is abducted by an adult dragon.",
        releaseYear: 2010,
        rating: 7.9,
        duration: 918,
        posterURL: URL(string: "https://durian.blender.org/wp-content/uploads/2010/09/poster_small.jpg"),
        backdropURL: URL(string: "https://durian.blender.org/wp-content/uploads/2010/08/sintel_winter.jpg"),
        previewVideoURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4"),
        imdbId: "tt1727587",
        genres: ["Animation", "Fantasy", "Drama"]
    )
    
    // MARK: - Open-Source TV Series & Episodes
    public static let blenderShortsSeries = SutureMediaItem(
        id: "cc_blender_anthology",
        type: .series,
        title: "Blender Open Cinema",
        subtitle: "Groundbreaking Open Source Cinema",
        overview: "An anthology series highlighting the finest open-source CGI animated short films created by the worldwide Blender Studio.",
        releaseYear: 2024,
        rating: 8.8,
        posterURL: URL(string: "https://peach.blender.org/wp-content/uploads/bbb-splash.png"),
        backdropURL: URL(string: "https://mango.blender.org/wp-content/uploads/2012/09/01_render_bridge.jpg"),
        genres: ["Animation", "Documentary", "Anthology"]
    )
    
    // MARK: - Live TV Channels
    public static let nasaTV = SutureMediaItem(
        id: "live_nasa_tv",
        type: .liveTV,
        title: "NASA TV HD",
        subtitle: "Live from Orbit",
        overview: "Live coverage of International Space Station missions, rocket launches, spacewalks, and deep space exploration broadcasts.",
        posterURL: URL(string: "https://i.imgur.com/8QxQyX0.png"),
        channelNumber: "101",
        currentProgramTitle: "ISS Live Earth View & Spacewalk Briefing",
        programStartTime: Date().addingTimeInterval(-1800),
        programEndTime: Date().addingTimeInterval(3600),
        genres: ["Science", "Space", "Live News"],
        isLive: true
    )
    
    public static let blenderLive = SutureMediaItem(
        id: "live_blender_stream",
        type: .liveTV,
        title: "Blender Foundation 24/7",
        subtitle: "CGI & Animation Showcase",
        overview: "Continuous high-definition live stream of open movie animations, conference keynotes, and rendering masterclasses.",
        posterURL: URL(string: "https://peach.blender.org/wp-content/uploads/poster_bunny_small.jpg"),
        channelNumber: "102",
        currentProgramTitle: "Next-Gen Geometry Nodes & VFX Render",
        programStartTime: Date().addingTimeInterval(-900),
        programEndTime: Date().addingTimeInterval(2700),
        genres: ["Art", "Technology", "Live"],
        isLive: true
    )
    
    // MARK: - Hi-Res / Lossless Music Tracks
    public static let solarFlareTrack = SutureMediaItem(
        id: "music_solar_flare",
        type: .musicTrack,
        title: "Solar Flare",
        subtitle: "Atmospheric Synthwave",
        overview: "A warm, analog synth soundscape featuring lush arpeggiators and spatial reverberation.",
        duration: 248,
        posterURL: URL(string: "https://peach.blender.org/wp-content/uploads/poster_bunny_small.jpg"),
        artistName: "Quantum Resonance",
        albumTitle: "Starlight Odyssey",
        trackNumber: 1,
        genres: ["Synthwave", "Electronic", "Ambient"]
    )
    
    public static let deepSpaceTrack = SutureMediaItem(
        id: "music_deep_space",
        type: .musicTrack,
        title: "Deep Space Echoes",
        subtitle: "Chill Downtempo",
        overview: "Deep sub-bass frequencies and crisp percussion engineered for high-resolution 24-bit/192kHz audio testing.",
        duration: 312,
        posterURL: URL(string: "https://mango.blender.org/wp-content/uploads/2012/09/poster_tos_small.jpg"),
        artistName: "Quantum Resonance",
        albumTitle: "Starlight Odyssey",
        trackNumber: 2,
        genres: ["Downtempo", "Hi-Res", "Audiophile"]
    )
    
    // MARK: - Sample Rails
    public static let trendingItems: [SutureMediaItem] = [
        tearsOfSteel,
        bigBuckBunny,
        sintel,
        blenderShortsSeries
    ]
    
    public static let liveChannels: [SutureMediaItem] = [
        nasaTV,
        blenderLive
    ]
    
    public static let musicTracks: [SutureMediaItem] = [
        solarFlareTrack,
        deepSpaceTrack
    ]
    
    // MARK: - Sample Streams
    public static let sampleStreams: [StreamSource] = [
        StreamSource(
            id: "stream_1",
            name: "Cloud Stream [RD+]\n4K Dolby Vision",
            title: "Tears.Of.Steel.2012.2160p.UHD.Remux.HEVC.DV.TrueHD.7.1.Atmos\n💾 14.2 GB ⚙️ Debrid Direct",
            streamURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4")!,
            quality: .uhd4k,
            dynamicRange: .dolbyVision,
            audioProfile: .dolbyAtmos,
            fileSizeInBytes: 15_246_000_000,
            seeders: 84,
            providerName: "Real-Debrid",
            isCachedDebrid: true
        ),
        StreamSource(
            id: "stream_2",
            name: "HTTP Fast [RD+]\n1080p HDR",
            title: "Tears.Of.Steel.2012.1080p.BluRay.x264.DTS-HD.MA.5.1\n💾 3.8 GB ⚙️ Debrid Direct",
            streamURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4")!,
            quality: .fhd1080p,
            dynamicRange: .hdr10,
            audioProfile: .dtsHD,
            fileSizeInBytes: 4_080_000_000,
            seeders: 42,
            providerName: "Real-Debrid",
            isCachedDebrid: true
        ),
        StreamSource(
            id: "stream_3",
            name: "Direct Open Source\n720p SDR",
            title: "Tears.Of.Steel.2012.720p.WEB-DL.AAC.2.0\n💾 850 MB ⚙️ Direct Web",
            streamURL: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4")!,
            quality: .hd720p,
            dynamicRange: .sdr,
            audioProfile: .stereo,
            fileSizeInBytes: 891_000_000,
            seeders: nil,
            providerName: "Direct HTTP",
            isCachedDebrid: false
        )
    ]
}

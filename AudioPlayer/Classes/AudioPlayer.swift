//
//  AudioPlayer.swift
//  AudioPlayer
//
//  Created by gizem on 24.07.2024.
//

import Foundation
import AVFoundation
import MediaPlayer

public class AudioPlayer: NSObject { //When creating a CocoaPods library, the visibility of the classes and methods needs to be 'public' so that they can be accessed by projects that import the library
    
    public static let shared = AudioPlayer()
    public var player: AVPlayer?
    private var playlist: [URL] = []
    private var currentIndex: Int = 0
    private var timeObserverToken: Any?
    private var currentURL: URL? // To keep track of the URL (currently playing)

    public var onTrackEnd: (() -> Void)?
    public var onTimeUpdate: ((Double, Double) -> Void)? //  current time and duration as 2 double values
    public var onTrackLoaded: ((UIImage?) -> Void)? // so that the audioplayer and vc relation not to be obligated in image assigning
    
    private override init() {
        super.init()
      
    }
    
    /*
     private func setupAudioSession() {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                if #available(iOS 10.0, *) {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, mode: AVAudioSessionModeDefault, options: [.mixWithOthers, .allowAirPlay])
                } else {

                }
                try audioSession.setActive(true)
            } catch {
                print("Failed to set up audio session: \(error)")
            }
        }
     */
 
    private func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback, mode: AVAudioSessionModeDefault, options: [.mixWithOthers, .allowAirPlay])
            print("Playback OK")
            try audioSession.setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
    }
    
       
    // track play management
    
    public func play(url: URL, imageURL: URL?) {
        if let currentItem = player?.currentItem, let asset = currentItem.asset as? AVURLAsset, asset.url == url { // if player is already playing a URL
            player?.play() // same URL; player is paused, then just resume playing
                   return // If yes, return without doing anything
               }

               currentURL = url // Update the currentURL
        player = AVPlayer(url: url)
        player?.play()
        addObserver()
        addTimeObserver()
        
        let placeholderImage = UIImage(named: "soundImage")
        onTrackLoaded?(placeholderImage)
        
        if let imageURL = imageURL {
            loadTrackImage(from: imageURL)
        }
    }
    
    private func loadTrackImage(from url: URL) {
           DispatchQueue.global().async {
               if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                   DispatchQueue.main.async {
                       self.onTrackLoaded?(image)
                   }
               } else {
                   DispatchQueue.main.async {
                       self.onTrackLoaded?(UIImage(named: "soundImage"))
                   }
               }
           }
       }
    
    public func playPlaylist(urls: [URL]) {
        playlist = urls
        currentIndex = 0
    }
    
    public func pause() {
        player?.pause()
    }
    
    public func stop() {
        player?.pause()
        player?.seek(to: kCMTimeZero)
        removeTimeObserver()
        player = nil
    }
    
    public func forward() {
        guard let currentTime = player?.currentTime() else { return }
        let newTime = CMTimeGetSeconds(currentTime) + 10
        let time = CMTime(seconds: newTime, preferredTimescale: 1)
        player?.seek(to: time)
    }
    
    public func backward() {
        guard let currentTime = player?.currentTime() else { return }
        let newTime = CMTimeGetSeconds(currentTime) - 10
        let time = CMTime(seconds: newTime, preferredTimescale: 1)
        player?.seek(to: time)
    }
    
    private func playCurrentTrack() {
        guard currentIndex < playlist.count else { return }
        play(url: playlist[currentIndex], imageURL: nil) //url?
    }
    
    public func playNextTrack() {
        stop()
        currentIndex += 1
        if currentIndex < playlist.count {
            playCurrentTrack()
        } else {
            currentIndex = playlist.count - 1 // last track
            stop() // Stop if no more tracks available
        }
    }
    
    public func playPreviousTrack() {
        stop()
        if currentIndex > 0 {
            currentIndex -= 1
            playCurrentTrack()
        }
    }
    
    // track state observer?
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handlePlayerItemDidPlayToEndTime), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
    }
    
    @objc private func handlePlayerItemDidPlayToEndTime(notification: Notification) {
        onTrackEnd?()
    }
    
    private func addTimeObserver() {
        guard let player = player else { return }
        
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            if let duration = player.currentItem?.duration {
                let currentTime = CMTimeGetSeconds(time)
                let totalDuration = CMTimeGetSeconds(duration)
                self.onTimeUpdate?(currentTime, totalDuration) // Provide current time and duration
            }
        }
    }
    
    private func removeTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
    }
    
    public func seek(to time: Double) { // for slider functionality
        let cmTime = CMTime(seconds: time, preferredTimescale: 1)
        player?.seek(to: cmTime)
    }
}

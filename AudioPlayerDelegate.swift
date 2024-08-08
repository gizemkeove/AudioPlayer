//
//  AudioPlayerDelegate.swift
//  AudioPlayer
//
//  Created by gizem on 28.07.2024.
//

import Foundation

public protocol AudioPlayerDelegate: AnyObject {
    func audioPlayerDidStartPlaying(_ audioPlayer: AudioPlayer)
    func audioPlayerDidPause(_ audioPlayer: AudioPlayer)
    func audioPlayerDidStop(_ audioPlayer: AudioPlayer)
}

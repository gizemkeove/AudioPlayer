//
//  ViewController.swift
//  AudioPlayer
//
//  Created by gizem sahin on 07/23/2024.
//  Copyright (c) 2024 gizem sahin. All rights reserved.
//

import UIKit
import AudioPlayer

class ViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var TrackSlider: UISlider!
    @IBOutlet weak var trackImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AudioPlayer.shared.onTrackEnd = { [weak self] in
            self?.handleTrackEnd()
        }
        
        AudioPlayer.shared.onTimeUpdate = { [weak self] currentTime, duration in
            DispatchQueue.main.async {
                      if duration > 0 { // duration is valid
                          let sliderValue = Float(currentTime / duration)
                          self?.TrackSlider.value = sliderValue
                          self?.updateTimeLabel(with: max(0, duration - currentTime)) // time is non-negative
                      } else {
                          self?.TrackSlider.value = 0
                          self?.updateTimeLabel(with: 0)
                      }
                  }
              }
        TrackSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
        AudioPlayer.shared.onTrackLoaded = { [weak self] trackImage in
                   DispatchQueue.main.async {
                       self?.trackImage.image = trackImage
                   }
               }
        let playlist = [
                   URL(string: "https://sesli-edergi.keove.com/birinci/tuncel-kurtiz-oysa-herkes-oldurur-sevdigini-siir-oscar-wilde.m3u8")!,
                   URL(string: "https://sesli-edergi.keove.com/ikinci/tut-yuregimden-ustam-tuncel-kurtiz.m3u8")!,
               ]
               AudioPlayer.shared.playPlaylist(urls: playlist)
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        let duration = AudioPlayer.shared.player?.currentItem?.duration.seconds ?? 1
        let selectedTime = Double(sender.value) * duration
        AudioPlayer.shared.seek(to: selectedTime) // seek in order to follow slider rearrangements
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        if let url = URL(string: "https://sesli-edergi.keove.com/birinci/tuncel-kurtiz-oysa-herkes-oldurur-sevdigini-siir-oscar-wilde.m3u8") {
            AudioPlayer.shared.play(url: url, imageURL: nil)
        }
    }
    
    @IBAction func pauseButtonTapped(_ sender: UIButton) {
        AudioPlayer.shared.pause()
    }
    
    /*  @IBAction func stopButtonTapped(_ sender: UIButton) {
     AudioPlayer.shared.stop()
     } */
    
    @IBAction func forwardButtonTapped(_ sender: UIButton) {
        AudioPlayer.shared.forward()
    }
    
    @IBAction func backwardButtonTapped(_ sender: UIButton) {
        AudioPlayer.shared.backward()
    }
    
    @IBAction func nextTrackButtonTapped(_ sender: UIButton) {
        AudioPlayer.shared.playNextTrack()
    }
    
    @IBAction func previousTrackButtonTapped(_ sender: UIButton) {
        AudioPlayer.shared.playPreviousTrack()
    }
    
    private func handleTrackEnd() {
        AudioPlayer.shared.playNextTrack()
    }
    
    private func updateTimeLabel(with time: Double) {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func loadTrackImage(from url: URL?) {
        guard let url = url else {
            trackImage.image = nil
            return
        }
        
        // Assuming the URL points to an image
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self?.trackImage.image = nil
                }
                return
            }
            
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self?.trackImage.image = image
            }
        }
        task.resume()
    }
}

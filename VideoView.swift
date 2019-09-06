//
//  VideoView.swift
//
//
//  Created by Sajal Gupta on 16/10/18.
//  Copyright © 2018 Sajal Gupta. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


class CustomVideoView  : UIView{
    
    var player : AVPlayer?
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    func configure(url: String , isLocal : Bool = false) {
        self.isHidden = true
        guard  let videoURL = isLocal ? URL.init(fileURLWithPath: url) : URL(string: url) else{return}
        player = AVPlayer(url:videoURL)
        let castedLayer = self.layer as? AVPlayerLayer
        castedLayer?.player = player
        castedLayer?.videoGravity = .resizeAspectFill
        player?.play()
        self.isHidden = false
        NotificationCenter.default.addObserver(self, selector: #selector(reachTheEndOfTheVideo(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
        
    }
    
   
    
    @objc func reachTheEndOfTheVideo(_ notification: Notification) {
        player?.pause()
        player?.seek(to: kCMTimeZero)
        player?.play()
    }
    func invalidate(){
        self.player?.pause()
        self.player = nil
    }
    func play() {
        if player?.timeControlStatus != AVPlayerTimeControlStatus.playing {
            player?.play()
        }
    }
}

class VideoView: UIView {
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    var isLoop: Bool = true
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(url: String , isLocal : Bool = false) {
        
        guard  let videoURL = isLocal ? URL.init(fileURLWithPath: url) : URL(string: url) else
        {
            return
            
        }
        
        player = AVPlayer(url:videoURL)
        player?.isMuted = true
        playerLayer = AVPlayerLayer(player: player)
        self.layoutIfNeeded()
        playerLayer?.frame = self.bounds
        playerLayer?.videoGravity = .resizeAspectFill
        if let playerLayer = self.playerLayer {
            layer.sublayers?.removeAll()
            layer.addSublayer(playerLayer)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reachTheEndOfTheVideo(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
    }
    
    func play() {
        if player?.timeControlStatus != AVPlayerTimeControlStatus.playing {
            player?.play()
        }
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        player?.pause()
        player?.seek(to: kCMTimeZero)
    }
    func invalidate(){
        self.player = nil
        self.playerLayer = nil
        layer.sublayers?.removeAll()
    }
    
    @objc func reachTheEndOfTheVideo(_ notification: Notification) {
        if isLoop {
            player?.pause()
            player?.seek(to: kCMTimeZero)
            player?.play()
        }
    }
}

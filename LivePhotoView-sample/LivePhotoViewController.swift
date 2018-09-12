//
//  LivePhotoViewController.swift
//  LivePhotoView-sample
//
//  Created by Shota on 2018/09/12.
//  Copyright © 2018年 Shota. All rights reserved.
//

import Foundation
import PhotosUI

class LivePhotoViewController: UIViewController {
    var livePhoto: PHLivePhoto? {
        set { (view as! PHLivePhotoView).livePhoto = newValue }
        get { return (view as! PHLivePhotoView).livePhoto }
    }
    
    override func loadView() {
        let livePhotoView = PHLivePhotoView()
        
        // 音声をミュートにするか
        livePhotoView.isMuted = false
        
        livePhotoView.delegate = self
        
        view = livePhotoView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (view as! PHLivePhotoView).startPlayback(with: .full) 
    }
}

extension LivePhotoViewController: PHLivePhotoViewDelegate {
    func livePhotoView(_ livePhotoView: PHLivePhotoView, willBeginPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
        print("再生開始")
    }
    
    func livePhotoView(_ livePhotoView: PHLivePhotoView, didEndPlaybackWith playbackStyle: PHLivePhotoViewPlaybackStyle) {
        print("再生終了")
    }
}

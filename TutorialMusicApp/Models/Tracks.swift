//
//  Track.swift
//  TutorialMusicApp
//
//  Created by 태로고침 on 2021/04/30.
//

import Foundation

class Tracks:NSObject{
    var headerTitle:String?
    var tracks:[TopTrack]?
}

class TopTrack:NSObject{
    
    var previewURL:String?
    var artWork:String?
    var trackName:String?
    var artistName:String?
}

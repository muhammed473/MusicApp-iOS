//
//  PlayListDetail.swift
//  MusicApp
//
//  Created by muhammed dursun on 11.06.2024.
//

import Foundation

struct PlayListDetail : Codable{
    
    let description : String
    let external_urls : [String:String]
    let id : String
    let images : [ApiImageModel]
    let name : String
    let tracks : PlayListTracksModel
}

struct PlayListTracksModel : Codable {
    
    let items : [PlayListItem]
}

struct PlayListItem : Codable {
    let track : TracksModel
}

//
//  TrackModel.swift
//  MusicApp
//
//  Created by muhammed dursun on 19.05.2024.
//

import Foundation

struct TracksModel : Codable {
    
    var album : Album?
    let artists : [ArtistModel]
    let available_markets : [String]
    let disc_number : Int?
    let duration_ms : Int?
     let explicit : Bool //
    let external_urls : [String : String]
    let id : String
    let name : String
    let popularity : Int?
    let preview_url : String?
}

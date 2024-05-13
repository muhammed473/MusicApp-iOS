//
//  FeaturedPlayListModel.swift
//  MusicApp
//
//  Created by muhammed dursun on 13.05.2024.
//

import Foundation

struct FeaturedPlayListModel : Codable {
    let playlists : PlayListResponse
}

struct PlayListResponse : Codable{
    let items : [PlayListModel]
}

struct PlayListModel :Codable{
    
    let description : String
    let external_urls : [String:String]
    let id : String
    let images : [ApiImageModel]
    let name : String
    let owner : OwnerModel
    let primary_color : String
    let snapshot_id : String
    
}



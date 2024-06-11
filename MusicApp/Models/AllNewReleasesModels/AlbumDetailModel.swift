//
//  AlbumDetailModel.swift
//  MusicApp
//
//  Created by muhammed dursun on 10.06.2024.
//

import Foundation

struct AlbumDetailModel : Codable {
    
    let album_type : String
    let artists : [ArtistModel]
    let available_markets : [String]
    let external_urls : [String:String]
    let id : String
    let images : [ApiImageModel]
    let label : String
    let name : String
    let tracks : AlbumDetailTracksModel
}

struct AlbumDetailTracksModel:Codable{
    
    let items : [TracksModel]
}





//
//  NewReleasesResponseModel.swift
//  MusicApp
//
//  Created by muhammed dursun on 12.05.2024.
//

import Foundation

struct NewReleasesModel : Codable {
    let albums : AlbumsResponse
}

struct AlbumsResponse:Codable{
    let items : [Album]
}

struct Album: Codable {
    
    let album_type : String
    let available_markets : [String]
    let id : String
    var images : [ApiImageModel]
    let name : String
    let release_date : String
    let total_tracks : Int
    let artists : [ArtistModel]
}



//
//  SearchResponseModel.swift
//  MusicApp
//
//  Created by muhammed dursun on 16.06.2024.
//

import Foundation

struct SearchResponseModel:Codable{
    let albums : SearchAlbumsModel
    let artists : SearchArtistsModel
    let playlists : SearchPlayListsModel
    let tracks : SearchTracksModel
}

struct SearchAlbumsModel : Codable{
    let items : [Album]
}
struct SearchArtistsModel : Codable{
    let items : [ArtistModel]
}
struct SearchPlayListsModel : Codable{
    let items : [PlayListModels]
}
struct SearchTracksModel : Codable{
    let items : [TracksModel]
}



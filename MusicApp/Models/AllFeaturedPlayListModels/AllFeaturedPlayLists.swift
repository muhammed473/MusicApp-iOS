//
//  FeaturedPlayListModel.swift
//  MusicApp
//
//  Created by muhammed dursun on 13.05.2024.
//

import Foundation


struct AllFeaturedPlayLists : Codable {
    let playlists : PlayListResponse
}

struct PlayListResponse : Codable{
    let items : [PlayListModels]
}

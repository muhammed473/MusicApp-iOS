//
//  LibraryAlbumModel.swift
//  MusicApp
//
//  Created by muhammed dursun on 4.07.2024.
//

import Foundation

struct LibraryAlbumModel : Codable{
    let items : [SavedAlbum]
}

struct SavedAlbum : Codable{
    let added_at : String
    let album : Album
}

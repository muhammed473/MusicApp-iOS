//
//  ArtistModel.swift
//  MusicApp
//
//  Created by muhammed dursun on 2.05.2024.
//

import Foundation

struct ArtistModel : Codable {
    
    let id : String
    let name : String
    let type : String
    let external_urls : [String:String]
}

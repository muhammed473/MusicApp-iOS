//
//  PlayListModel.swift
//  MusicApp
//
//  Created by muhammed dursun on 19.05.2024.
//

import Foundation

struct PlayListModels :Codable{
    
    let description : String
    let external_urls : [String:String]
    let id : String
    let images : [ApiImageModel]?
    let name : String
    let owner : OwnerModel
    let primary_color : String?
    let snapshot_id : String
}

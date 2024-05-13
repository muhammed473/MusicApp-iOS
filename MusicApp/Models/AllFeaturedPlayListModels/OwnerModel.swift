//
//  OwnerModel.swift
//  MusicApp
//
//  Created by muhammed dursun on 13.05.2024.
//

import Foundation

struct OwnerModel : Codable{
    
    let display_name : String
    let external_urls : [String:String]
    let id : String
}

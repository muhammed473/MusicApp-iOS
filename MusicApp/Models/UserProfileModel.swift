//
//  UserProfileModel.swift
//  MusicApp
//
//  Created by muhammed dursun on 2.05.2024.
//

import Foundation

struct UserProfileModel : Codable{
    
    let country: String
    let display_name:String
    let email : String
    let explicit_content : [String:Bool]
    let external_urls : [String:String]
    let id : String
    let product : String
}


    
    


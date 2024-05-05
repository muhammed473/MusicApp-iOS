//
//  AuthResponseModel.swift
//  MusicApp
//
//  Created by muhammed dursun on 4.05.2024.
//

import Foundation

struct AuthResponseModel:Codable{
    
    let access_token : String
    let expires_in : Int
    let refresh_token : String?
    let scope  : String
    let token_type : String
}

//
//  CategoryModel.swift
//  MusicApp
//
//  Created by muhammed dursun on 14.06.2024.
//

import Foundation

struct CategoryModel : Codable{
    let id : String?
    let name : String
    let icons : [ApiImageModel]
}

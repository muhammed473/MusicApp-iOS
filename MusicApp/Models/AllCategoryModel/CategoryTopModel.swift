//
//  CategoryTopModel.swift
//  MusicApp
//
//  Created by muhammed dursun on 14.06.2024.
//

import Foundation

struct CategoryTopModel : Codable {
    let categories : CategoriResponse
}

struct CategoriResponse : Codable {
    let items : [CategoryModel]
}



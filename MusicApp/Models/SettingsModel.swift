//
//  SettingsModel.swift
//  MusicApp
//
//  Created by muhammed dursun on 10.05.2024.
//

import Foundation

struct Section {
    
    let title : String
    let options : [Option]
}

struct Option {
    
    let title : String
    let handler : () -> Void
}

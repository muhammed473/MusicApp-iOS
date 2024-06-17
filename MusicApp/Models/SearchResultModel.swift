//
//  SearchResultModel.swift
//  MusicApp
//
//  Created by muhammed dursun on 17.06.2024.
//

import Foundation

enum SearchResultModel{
    case album(model:Album)
    case artist(model:ArtistModel)
    case playlist(model:PlayListModels)
    case track(model:TracksModel)
}

struct SearchSection{
    let title : String
    let searchResultModels : [SearchResultModel]
}

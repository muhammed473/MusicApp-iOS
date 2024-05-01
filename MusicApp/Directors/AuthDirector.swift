//
//  AuthDirector.swift
//  MusicApp
//
//  Created by muhammed dursun on 2.05.2024.
//

import Foundation

final class AuthDirector {

    static let shared = AuthDirector()
    private init() { }

    var isLogIn : Bool {
        return false
    }

    private var accessToken: String?{
        return nil
    }

    private var refreshToken: String?{
        return nil
    }

    private var lastDateUsedToken: Date?{
        return nil
    }

    private var shouldRefreshToken: Bool{
        return false
    }

}

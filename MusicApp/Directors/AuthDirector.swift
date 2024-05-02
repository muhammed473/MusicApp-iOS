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
    
    struct Constants {
        static let clientId = "d056806013064ef18ec95ae4db0ca1a4"
        static let clientSecret = "27d67a874af94a20aa1ed2b2fa1ad7ae"
    }
    public var signInURL : URL? {
        let scope = "user-read-private"
        let base = "https://accounts.spotify.com/authorize"
        //let redirect_uri = "https://iosacademy.io".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        // let redirect_uri = "https://iosacademy.io"
        let redirect_uri = "https://localhost:3000"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientId)&scope=\(scope)&redirect_uri=\(redirect_uri)&show_dialog=TRUE"
        
        return URL(string:string)
    }
    
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
    
    public func exhangeCodeForToken(code:String,completion:@escaping((Bool)->Void)){
        // Api call to get token
    }
    
    public func refreshAccessToken(){
        
    }
    
    private func cacheToken(){
        
    }
    
    
}

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
    private var refreshingToken = false
    
    struct Constants {
        static let clientId = "d056806013064ef18ec95ae4db0ca1a4"
        static let clientSecret = "27d67a874af94a20aa1ed2b2fa1ad7ae"
        static let tokenApiUrl = "https://accounts.spotify.com/api/token"
        //  let redirect_uri = "https://developerIos.com"
        static let redirect_uri = "https://localhost:3000"
        static let scope = "user-read-private playlist-modify-public playlist-read-private playlist-modify-private user-follow-read user-library-modify user-library-read user-read-email"
    }
    
    public var signInURL : URL? {
    
        let base = "https://accounts.spotify.com/authorize"
        let string = "\(base)?response_type=code&client_id=\(Constants.clientId)&scope=\(Constants.scope)&redirect_uri=\(Constants.redirect_uri)&show_dialog=TRUE"
        return URL(string:string)
    }
    
    var isLoggedIn : Bool {
        return accessToken != nil
    }
    
    private var accessToken: String?{
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String?{
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var lastDateUsedToken: Date?{ // 1 Hour
        return  UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var isTokenRefreshRequired: Bool{
        guard let lastDateUsedToken = lastDateUsedToken else {return false}
        let currentDate = Date()
        let sixMinutes : TimeInterval = 360 // 6 minutes
        return currentDate.addingTimeInterval(sixMinutes) >= lastDateUsedToken
    }
    
    public func exhangeCodeForToken(code:String,completion:@escaping((Bool)->Void)){
        // Api call to get token
        guard let url = URL(string:Constants.tokenApiUrl) else {return}
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constants.redirect_uri)
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        let basicToken = Constants.clientId+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard  let base64String = data?.base64EncodedString() else {
            print("PRİNT: Failure to get base64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data,error == nil else {
                completion(false)
                return
            }
            do{
                // let jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                // print("PRİNT: SUCCES \(jsonData)")
                let result = try JSONDecoder().decode(AuthResponseModel.self, from: data)
                self?.saveCacheToken(result : result)
                completion(true)
            }catch{
                print(error.localizedDescription)
                completion(false)
            }
            
        }
        task.resume()
        
    }
    
    private var allRefreshTokens = [((String)->Void)]()
    
    // MARK: - Valid Token
    
    public func validToken(completion: @escaping (String) ->Void) {
        
        guard !refreshingToken else {
            // Append Completion..
            allRefreshTokens.append(completion)
            return
        }
        if isTokenRefreshRequired {
            refreshIfNeeded { [weak self] succes in
                if let token = self?.accessToken,succes{
                    completion(token)
                }
            }
        }else if let token = accessToken{
            completion(token)
        }
    }
    
    public func refreshIfNeeded(completion:@escaping (Bool) -> Void){
        
        guard !refreshingToken else {return}
        guard isTokenRefreshRequired else {
            completion(false)
            return
        }
        guard let refreshToken = self.refreshToken else {
            return
        }
        // Refresh Token..
        guard let url = URL(string:Constants.tokenApiUrl) else {return}
        refreshingToken = true
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        let basicToken = Constants.clientId+":"+Constants.clientSecret
        let data = basicToken.data(using: .utf8)
        guard  let base64String = data?.base64EncodedString() else {
            print("PRİNT: Failure to get base64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            self?.refreshingToken = false
            guard let data = data,error == nil else {
                completion(false)
                return
            }
            do{
                let result = try JSONDecoder().decode(AuthResponseModel.self, from: data)
                print("PRİNT: Succesfully Refreshed")
                self?.allRefreshTokens.forEach{ $0(result.access_token) }
                self?.allRefreshTokens.removeAll()
                self?.saveCacheToken(result : result)
                completion(true)
            }catch{
                print(error.localizedDescription)
                completion(false)
            }
        }
        task.resume()
    }
    
    private func saveCacheToken(result:AuthResponseModel){
        
        UserDefaults.standard.setValue(result.access_token, forKey: "access_token")
        if let refresh_token = result.refresh_token {
            UserDefaults.standard.setValue(refresh_token, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expires_in)), forKey: "expirationDate")
    }
    
}

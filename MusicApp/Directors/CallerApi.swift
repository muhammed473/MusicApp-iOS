//
//  CallerApi.swift
//  MusicApp
//
//  Created by muhammed dursun on 2.05.2024.
//

import Foundation

final class CallerApi {
    
    // MARK: - Enums
    
    enum HttpMethod:String {
        case GET
        case POST
    }
    
    enum ApiError: Error {
        case failedGetData
    }
    
    // MARK: - Constant
    
    struct Constants {
        static let baseApiUrl = "https://api.spotify.com/v1"
    }
    
    // MARK: - Properties
    
    static let shared = CallerApi()
    private init() {}
    
    // MARK: - Assistants
    
    public func getUserProfile(completion: @escaping(Result<UserProfileModel,Error>) -> Void){
        
        createRequest(url: URL(string: Constants.baseApiUrl + "/me"), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else{
                    completion(.failure(ApiError.failedGetData))
                    return
                }
                do{
                    let result =  try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                    print(result)
                }catch{
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
    
    public func createRequest(url: URL?,type: HttpMethod, completion: @escaping (URLRequest) -> Void) {
       
        AuthDirector.shared.validToken { token in
            guard let apiUrl = url else {return}
            var request = URLRequest(url:apiUrl)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
    
        }
    }
    
}

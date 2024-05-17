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
                    // let userProfileModelValues = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                    // print("PRİNT: Result : \(userProfileModelValues)")
                    let userProfileModelValues = try JSONDecoder().decode(UserProfileModel.self, from: data)
                    completion(.success(userProfileModelValues))
                }catch{
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
                
            }
            task.resume()
        }
    }
   
    public func getNewReleasesPlaylists(completion: @escaping((Result<NewReleasesModel,Error>)) -> Void ) {
        
        createRequest(url: URL(string:Constants.baseApiUrl + "/browse/new-releases?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else{
                    completion(.failure(ApiError.failedGetData))
                    return
                }
                do{
                  /*  let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                    print("PRİNT: Result : \(json)") */
                    let result = try JSONDecoder().decode(NewReleasesModel.self, from: data)
                    completion(.success(result))
                }catch{
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
        
    }
    
    public func getFeaturedPlaylists(completion : @escaping((Result<FeaturedPlayListModel,Error>)) -> Void){
            
            createRequest(url: URL(string: Constants.baseApiUrl + "/browse/featured-playlists?limit=2"), type: .GET) { request in
                let task = URLSession.shared.dataTask(with: request) { data, _ , error in
                    guard let data = data, error == nil else {
                        completion(.failure(ApiError.failedGetData))
                        return
                    }
                    do{
                        /* let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                        print("PRİNT : \(json)") */
                        let result = try JSONDecoder().decode(FeaturedPlayListModel.self, from: data)
                        completion(.success(result))
                    }
                    catch{
                        print(error.localizedDescription)
                        completion(.failure(error))
                    }
                }
                task.resume()
            }
            
        }
    
    public func getRecommendations(genres : Set<String>, completion : @escaping((Result<RecommendationsGenresModel,Error>)) -> Void){
        let seeds = genres.joined(separator: ",")
        createRequest(url: URL(string: Constants.baseApiUrl + "/recommendations?seed_genres=\(seeds)"),type: .GET) { request in
            print(request.url?.absoluteString)
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(ApiError.failedGetData))
                    return
                }
                do{
                    let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                    print("PRİNT : \(json)")
                    
                }catch{
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
        
    }
    
    public func getRecommendationsGenres(completion : @escaping((Result<RecommendationsGenresModel,Error>)) -> Void) {
        
        createRequest(url: URL(string: Constants.baseApiUrl + "/recommendations/available-genre-seeds"), type: .GET){ request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                
                guard let data = data, error == nil else {
                    completion(.failure(ApiError.failedGetData))
                    return
                }
                do{
                    /* let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print("PRİNT: \(json)") */
                    let result = try JSONDecoder().decode(RecommendationsGenresModel.self, from: data)
                    completion(.success(result))
                }catch{
                    print(error.localizedDescription)
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



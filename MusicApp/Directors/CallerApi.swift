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
    
    // MARK: - Profile Call
    
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
   
    // MARK: - Main For Api Calls
    
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
    
    public func getFeaturedPlaylists(completion : @escaping((Result<AllFeaturedPlayLists,Error>)) -> Void){
            
            createRequest(url: URL(string: Constants.baseApiUrl + "/browse/featured-playlists?limit=6"), type: .GET) { request in
                let task = URLSession.shared.dataTask(with: request) { data, _ , error in
                    guard let data = data, error == nil else {
                        completion(.failure(ApiError.failedGetData))
                        return
                    }
                    do{
                        /* let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                        print("PRİNT : \(json)") */
                        let result = try JSONDecoder().decode(AllFeaturedPlayLists.self, from: data)
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
    
    public func getRecommendations(genres : Set<String>, completion : @escaping((Result<RecommendationsModel,Error>)) -> Void){
        let seeds = genres.joined(separator: ",")
        createRequest(url: URL(string: Constants.baseApiUrl + "/recommendations?limit=42&seed_genres=\(seeds)"),type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(ApiError.failedGetData))
                    return
                }
                do{
                    /* let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                    print("PRİNT : Recommendations =  \(json)") */
                    let result = try JSONDecoder().decode(RecommendationsModel.self, from: data)
                   // print("PRİNT: \(result) ")
                    completion(.success(result))
                    
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
    
    
    // MARK: - New Releases Album Detail
    
    public func getAlbumDetails(album:Album,completion: @escaping (Result<AlbumDetailModel,Error>) -> Void ){
        
        createRequest(url: URL(string: Constants.baseApiUrl + "/albums/" + album.id), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(ApiError.failedGetData))
                    return
                }
                do{
                    /*let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                    print("PRİNT: Album Detail infos : \(json)") */
                    let result = try JSONDecoder().decode(AlbumDetailModel.self,from: data)
                  //  print("PRİNT : Album Detail Result :\(result)")
                    completion(.success(result))
                }catch{
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Featured PlayList Detail
    
    public func getFeaturedPlayListDetails(playLists : PlayListModels,completion: @escaping (Result<PlayListDetail,Error>) -> Void ){
        
        createRequest(url: URL(string: Constants.baseApiUrl + "/playlists/" + playLists.id), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(ApiError.failedGetData))
                    return
                }
                do{
                    /*let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                    print("PRİNT: PlayList Detail infos : \(json)") */
                   let result  = try JSONDecoder().decode(PlayListDetail.self, from: data)
                  //  print("PRİNT: Results of placing playlists in the detail model : \(result)")
                    completion(.success(result))
                    
                }catch{
                    print(error)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Categories
    
    public func getCategories(completion : @escaping(Result<[CategoryModel],Error>) -> Void){
        
        createRequest(url: URL(string: Constants.baseApiUrl + "/browse/categories?limit=20"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else{
                    completion(.failure(ApiError.failedGetData))
                    return
                }
                do{
                    /*let json =  try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                    print("PRİNT: CATEGORİ : \(json)")*/
                    
                    let result = try JSONDecoder().decode(CategoryTopModel.self, from: data)
                  //  print("Modeled version of the categories we get from the API : \(result.categories.items)")
                    completion(.success(result.categories.items))
                }
                catch{
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getCategoryPlayList(categoryModel:CategoryModel, completion : @escaping(Result<[PlayListModels],Error>) -> Void){
        
        /*createRequest(url: URL(string: Constants.baseApiUrl + "/browse/categories/\(categoryModel.id)/playlists?limit=2"), type: .GET) { request in */
        createRequest(url: URL(string: Constants.baseApiUrl + "/browse/categories/" + categoryModel.id! + "/playlists?limit=50"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(ApiError.failedGetData))
                    return
                }
                do{
                    /*let json = try JSONSerialization.jsonObject(with: data,options: .allowFragments)
                    print("PRİNT: PLAYLİST OF THE CLİCKED CATEGORY : \(json)") */
                    let result = try JSONDecoder().decode(AllFeaturedPlayLists.self,from: data)
                    let playlists = result.playlists.items
                   // print(result)
                    completion(.success(playlists))
                }catch{
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    
    // MARK: - Request & Token
    
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



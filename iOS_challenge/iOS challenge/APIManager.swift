//
//  APIManeger.swift
//  iOS challenge
//
//  Created by Denis Prša on 7. 10. 16.
//  Copyright © 2016 Denis Prša. All rights reserved.
//

import Foundation
import AFNetworking

class APIManager {
    public static let instance = APIManager()
    private let key = "19588ca1c18b866178b6d78d85915b45"
    
    // MARK: - Get data
    
    private func getResponse(url: String, response: @escaping (Any?) -> Void ) {
        let manager = AFHTTPSessionManager()
        
        manager.get(url + "?api_key=" + key,
                    parameters: nil,
                    progress: nil,
                    success: { (task, respons) in
                        response(respons)
            }
        ){ (dataTask, error) in
            response(error)
        }
    }
    
    private func postData(url: String, parameters: Any?, response: @escaping (Any?) -> Void) {
        let manager = AFHTTPSessionManager()
        manager.post(url,
                    parameters: parameters,
                    progress: nil,
                    success: { (task, respons) in
                        response(respons)
            }
        ){ (dataTask, error) in
            response(error)
        }

        
    }
    
    // MARK: - Public Methods for retrieving data
    
    public func getMovie(id: String, response: @escaping (Any?) -> Void) {
        getResponse(url: "https://api.themoviedb.org/3/movie/\(id)"){ dataResponse in
            
            print(dataResponse)
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let data = JSON(dataResponse).dictionaryValue
            
            var genres:[Genres]? = []
            if let genresList = data["genres"] {
                for (_, subJson)  in genresList {
                    if let name = subJson["name"].string, let id = subJson["id"].int {
                        
                        genres?.append(Genres(
                            id: id,
                            name: name
                        ))
                    }
                }
            }
            
            let dataForMovie = MovieData(
                title: data["original_title"]?.string,
                runtime: data["runtime"]?.intValue,
                voteAverage: data["vote_average"]?.double,
                voteCount: data["vote_count"]?.intValue,
                overview: data["overview"]?.string,
                realeseDate: dateFormatter.date(from: (data["release_date"]?.string)!) as NSDate?,
                revenue: data["revenue"]?.double,
                generes: genres,
                cast: nil,
                tagline: data["tagline"]?.string,
                poster: data["poster_path"]?.string,
                url: data["homepage"]?.string
                
            )
            print(dataForMovie)
            response(dataForMovie)
        }
    }
    
    public func getActors(id: String, response: @escaping (Any?) -> Void) {
        getResponse(url: "https://api.themoviedb.org/3/movie/\(id)/credits"){ dataResponse in
            let data = JSON(dataResponse).dictionaryValue
            var arrayOfActors: [Actor] = []
            if let list = data["cast"] {
                for (_, subJson)  in list {
                    let data = Actor(
                        name: subJson["name"].string,
                        picture: subJson["profile_path"].string,
                        roleName: subJson["character"].string
                    )
                    arrayOfActors.append(data)
                }
            }
            response(arrayOfActors)
        }
    }
    
    public func getVideos(id: String, response: @escaping (Any?) -> Void) {
        getResponse(url: "https://api.themoviedb.org/3/movie/\(id)/videos"){ dataResponse in
            
            let data = JSON(dataResponse).dictionaryValue
            var videos: [MovieVideo] = []
            if let list = data["results"] {
                for (_, subJson)  in list {
                    let data = MovieVideo(
                        id: subJson["id"].string,
                        key: subJson["key"].string,
                        type: subJson["type"].string,
                        site: subJson["site"].string
                    )
                    videos.append(data)
                }
            }
            response(videos)
        }
    }
    
    public func getGuestSession( response: @escaping (Any?) -> Void) {
        getResponse(url: "https://api.themoviedb.org/3/authentication/guest_session/new"){ dataResponse in
            let data = JSON(dataResponse).dictionaryValue
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
            var sessionData = GuestSession(
                success: nil,
                guestSessionID: nil,
                expiresAT: nil
            )
            
            if let date = data["expires_at"]?.string{
                sessionData = GuestSession(
                    success: data["success"]?.bool,
                    guestSessionID: data["guest_session_id"]?.string,
                    expiresAT: dateFormatter.date(from: date)
                )
            }
            
            response(sessionData)
        }
    }
    
    // MARK: - Public Methods for posting data
    
    public func setRating(id: String, value: Int, guestSession: String, response: @escaping (Any?) -> Void) {
        let data = ["value" :  value]
        postData(
            url: "https://api.themoviedb.org/3/movie/\(id)/rating?guest_session_id=\(guestSession)&api_key=\(key)",
            parameters: data, response: { responseData in
                response(responseData)
        })
    }
}

//
//  TMBDClient.swift
//  MoviesNow
//
//  Created by Gunasai Garapati on 2/5/19.
//  Copyright © 2019 Gunasai Garapati. All rights reserved.
//

import Foundation
import UIKit

class TMDBClient {
    static let API_KEY = "e5f3fede40969a78041a6da3098e3ca7"
    
    struct Auth {
        static var accountId = 0
        static var reqestToken = ""
        static var sessionId = ""
    }
    
    enum EndPoints {
        static let base = "https://api.themoviedb.org/3"
        static let apiKeyParam = "?api_key=\(TMDBClient.API_KEY)"
        
        case getWatchList
        case getRequestToken
        case login
        case createSessionId
        case webAuth
        case account
        case gravatar(String)
        case nowPlaying
        case posterPath(String)
        case logout
        case search(String)
        case markWatchlist
        case markFavorite
        case getWatchlist
        case getFavorites
        
        
        var stringValue: String {
            switch self {
                case .getWatchList:
                    return
                        EndPoints.base + "/account/\(Auth.accountId)/watchlist/movies" +
                        EndPoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
                
                case .getRequestToken:
                    return
                        EndPoints.base + "/authentication/token/new" +
                        EndPoints.apiKeyParam
                
                case .login:
                    return
                        EndPoints.base + "/authentication/token/validate_with_login" +
                        EndPoints.apiKeyParam
                
                case .createSessionId:
                    return
                        EndPoints.base + "/authentication/session/new" +
                        EndPoints.apiKeyParam
                
                case .webAuth:
                    return "https://www.themoviedb.org/authenticate/" +
                        Auth.reqestToken +
                        "?redirect_to=moviesnow:authenticate"
                
                case .account:
                    return
                        EndPoints.base + "/account" +
                        EndPoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
                
                case .gravatar(let hash):
                    return "https://secure.gravatar.com/avatar/\(hash).jpg?s=64"
                
                case .nowPlaying:
                    return
                        EndPoints.base + "/movie/now_playing" +
                        EndPoints.apiKeyParam + "&language=en-US" +
                        "&page=1"
                
                case .posterPath(let poster):
                    return "https://image.tmdb.org/t/p/w342/\(poster)"
                
                
                case .logout:
                    return
                        EndPoints.base + "/authentication/session" +
                        EndPoints.apiKeyParam
                
                case .search(let query):
                    return EndPoints.base + "/search/movie" + EndPoints.apiKeyParam + "&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""))"
                
                case .markWatchlist:
                    return EndPoints.base + "/account/\(Auth.accountId)/watchlist" + EndPoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
                
                case .markFavorite:
                    return EndPoints.base + "/account/\(Auth.accountId)/favorite" + EndPoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
                
            case .getWatchlist: return EndPoints.base + "/account/\(Auth.accountId)/watchlist/movies" + EndPoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
                
                case .getFavorites:
                    return EndPoints.base + "/account/\(Auth.accountId)/favorite/movies" + EndPoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            }
                
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completionHandler: @escaping (ResponseType?, Error?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(TMDBResponse.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completionHandler(nil, error)
                    }
                }
               
            }
        }
        task.resume()
        
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, response: ResponseType.Type, body: RequestType, completionHandler: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(TMDBResponse.self, from: data)
                    DispatchQueue.main.async {
                        completionHandler(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completionHandler(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func getRequestToken(completionHandler: @escaping (Bool, Error?) -> Void) {
        
        taskForGETRequest(url: EndPoints.getRequestToken.url, response: RequestTokenResponse.self) { (response, error) in
            if let response = response {
                UserDefaults.standard.set(response.requestToken, forKey: "requestToken")
                Auth.reqestToken = response.requestToken
                completionHandler(true, nil)
            } else {
                completionHandler(false, error)
            }
        }
    }
    
    class func login(username: String, password: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        let body = LoginRequest(username: username, password: password, requestToken: Auth.reqestToken)
        taskForPOSTRequest(url: EndPoints.login.url, response: RequestTokenResponse.self, body: body) { (response, error) in
            if let response = response {
                UserDefaults.standard.set(response.requestToken, forKey: "requestToken")
                Auth.reqestToken = response.requestToken
                completionHandler(true, nil)
            } else {
                completionHandler(false, nil)
            }
        }
    }
    
    class func createSessionId(completionHandler: @escaping (Bool, Error?) -> Void) {
        let body = PostSession(requestToken: Auth.reqestToken)
        taskForPOSTRequest(url: EndPoints.createSessionId.url, response: SessionResponse.self, body: body) { (response, error) in
            if let response = response {
                UserDefaults.standard.set(response.sessionId, forKey: "sessionId")
                Auth.sessionId = response.sessionId
                completionHandler(true, nil)
            }
        }
    }
    
    
    class func getAccountDetails(completionHandler: @escaping (AccountDetailsRequest?, Error?) -> Void) {
        
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            Auth.reqestToken = UserDefaults.standard.value(forKey: "requestToken") as! String
            Auth.sessionId = UserDefaults.standard.value(forKey: "sessionId") as! String
        }
        
        taskForGETRequest(url: EndPoints.account.url, response: AccountDetailsRequest.self) { (response, error) in
            if let response = response {
                completionHandler(response, nil)
            } else {
                completionHandler(nil, error)
            }
        }
        
    }
    
    class func getMoviesNowPlaying(completionHandler: @escaping ([Movie], Error?) -> Void) {
        
        taskForGETRequest(url: EndPoints.nowPlaying.url, response: MovieResults.self) { (response, error) in
            if let response = response {
                completionHandler(response.results, nil)
            } else {
                completionHandler([], error)
            }
        }
        
    }
    
    class func getPoster(poster: String, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: EndPoints.posterPath(poster).url) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            let poster = UIImage(data: data)
            completionHandler(poster, nil)
        }
        task.resume()
    }
    
    class func getGravatar(hash: String, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: EndPoints.gravatar(hash).url) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            let gravatar = UIImage(data: data)
            completionHandler(gravatar, nil)
        }
        task.resume()
    }
    
    class func search(query: String, completionHandler: @escaping ([Movie], Error?) -> Void) {
        taskForGETRequest(url: EndPoints.search(query).url, response: MovieResults.self) { (response, error) in
            if let response = response {
                completionHandler(response.results, nil)
            } else {
                completionHandler([], error)
            }
        }
    }
    
    class func markWatchlist(movieID: Int, watchlist: Bool, completion: @escaping (Bool, Error?) -> Void) {
        let body = MarkWatchlist(mediaType: "movie", mediaId: movieID, watchlist: watchlist)
        taskForPOSTRequest(url: EndPoints.markWatchlist.url, response: TMDBResponse.self, body: body) { (response, error) in
            if let response = response {
                completion(response.statusCode == 1 || response.statusCode == 12 || response.statusCode == 13, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func markFavorite(movieId: Int, favorite: Bool, completion: @escaping (Bool, Error?) -> Void) {
        let body = MarkFavorite(mediaType: "movie", mediaId: movieId, favorite: favorite)
        taskForPOSTRequest(url: EndPoints.markFavorite.url, response: TMDBResponse.self, body: body) { response, error in
            if let response = response {
                completion(response.statusCode == 1 || response.statusCode == 12 || response.statusCode == 13, nil)
            } else {
                completion(false, nil)
            }
        }
    }
    
    class func getWatchlist(completion: @escaping ([Movie], Error?) -> Void) {
        taskForGETRequest(url: EndPoints.getWatchlist.url, response: MovieResults.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func getFavorites(completion: @escaping ([Movie], Error?) -> Void) {
        taskForGETRequest(url: EndPoints.getFavorites.url, response: MovieResults.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: EndPoints.logout.url)
        request.httpMethod = "DELETE"
        let body = LogoutRequest(sessionId: Auth.sessionId)
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            UserDefaults.standard.removeObject(forKey: "requestToken")
            UserDefaults.standard.removeObject(forKey: "sessionId")
            Auth.reqestToken = ""
            Auth.sessionId = ""
            completion()
        }
        task.resume()
    }
    
}

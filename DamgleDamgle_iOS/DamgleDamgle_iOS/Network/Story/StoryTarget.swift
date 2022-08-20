//
//  StoryTarget.swift
//  DamgleDamgle_iOS
//
//  Created by 최혜린 on 2022/07/30.
//

import Alamofire
import Foundation

enum StoryTarget {
    case postStory(_ request: PostStoryRequest)
    case getMyStory(size: Int?, storyID: String?)
    case getStoryFeed(_ request: GetStoryFeedRequest)
    case getStoryDetail(id: String)
    case postReaction(storyID: String, type: String)
    case deleteReaction(storyID: String)
    case postReport(storyID: String)
}

extension StoryTarget: URLRequestConvertible {
    var baseURL: URL {
        URL(string: "https://api-dev.damgle.com")!
    }
    
    var method: HTTPMethod {
        switch self {
        case .postStory(_), .postReaction(_, _), .postReport(_):
            return .post
        case .getMyStory(_, _), .getStoryFeed(_), .getStoryDetail(_):
            return .get
        case .deleteReaction(_):
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .postStory(_):
            return "/v1/story"
        case .getMyStory(_, _):
            return "/v1/story/me"
        case .getStoryFeed(_):
            return "/v1/story/feed"
        case .getStoryDetail(let id):
            return "/v1/story/\(id)"
        case .postReaction(let storyID, _), .deleteReaction(storyID: let storyID):
            return "/v1/story/react/\(storyID)"
        case .postReport(let storyID):
            return "/v1/story/report/\(storyID)"
        }
    }
    
    var header: HTTPHeaders {
        [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(UserManager.shared.currentAccessToken)"
        ]
    }
    
    var parameters: Parameters? {
        switch self {
        case .postStory(let request):
            return [
                "x": request.lng,
                "y": request.lat,
                "content": request.content
            ]
        case let .getMyStory(size, storyID):
            return [
                "size": size,
                "storyID": storyID
            ]
        case .getStoryFeed(let request):
            return [
                "top": request.top,
                "bottom": request.bottom,
                "left": request.left,
                "right": request.right,
                "size": request.size,
                "startFromStoryID": request.startFromStoryId
            ]
        case .getStoryDetail(_), .deleteReaction(_), .postReport(_):
            return nil
        case .postReaction(_, let type):
            return [
                "type": type
            ]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.headers = header
        
        var encoding: ParameterEncoding
        switch self {
        case .postStory(_), .postReaction(_, _), .postReport(_), .deleteReaction(_):
            encoding = JSONEncoding.default
        case .getMyStory(_, _), .getStoryFeed(_):
            encoding = URLEncoding.queryString
        case .getStoryDetail(_):
            encoding = URLEncoding.default
        }
        
        return try encoding.encode(urlRequest, with: parameters)
    }
}

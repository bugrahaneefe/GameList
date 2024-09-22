//
//  APIConstants.swift
//  CommonKit
//
//  Created by Buğrahan Efe on 20.09.2024.
//

public enum APIConstants {
    public static let BaseUrl = "https://api.rawg.io/api/games"
    public static let Key = "1e4eab1decbe45b0bbb89cf123e30b17"
    
    public enum Queries {
        public static let Key = "key"
        public static let PageSize = "page_size"
        public static let Search = "search"
        public static let Page = "page"
        public static let ParentPlatforms = "parent_platforms"
    }
}

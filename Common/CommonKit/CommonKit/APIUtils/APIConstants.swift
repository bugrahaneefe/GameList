//
//  APIConstants.swift
//  CommonKit
//
//  Created by Buğrahan Efe on 20.09.2024.
//

public enum APIConstants {
    public static let BaseUrl = "https://api.rawg.io/api/games/"
    public static let Key = "3fde07e2662c4bde9425cd8d2b901d1b"
    
    public enum Queries {
        public static let Key = "key"
        public static let PageSize = "page_size"
        public static let Search = "search"
        public static let Page = "page"
        public static let ParentPlatforms = "parent_platforms"
    }
}

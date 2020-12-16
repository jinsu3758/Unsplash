//
//  PhotoList.swift
//  UnSplash
//
//  Created by 박진수 on 2020/12/14.
//

import Foundation

struct PhotoListRequest: Encodable {
    let page: Int
    let perPage: Int
    
    private enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
    }
}

struct PhotoListResponse: Decodable {
    let id: String
    let urls: PhotoURLs
    
    private enum CodingKeys: String, CodingKey {
        case id
        case urls
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.urls = try container.decode(PhotoURLs.self, forKey: .urls)
    }
}

extension PhotoListResponse {
    func toDomain() -> Photo {
        return Photo(id: id, urlString: urls.small)
    }
}

struct PhotoURLs: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}




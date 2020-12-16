//
//  PhotoSearchQueryDTO.swift
//  UnSplash
//
//  Created by 박진수 on 2020/12/16.
//

import Foundation

struct PhotoListSearchQueryRequest: Encodable {
    let query: String
    let page: Int
    let perPage: Int
    
    private enum CodingKeys: String, CodingKey {
        case query
        case page
        case perPage = "per_page"
    }
}

struct PhotoListSearchResponse: Decodable {
    let total: Int
    let totalPage: Int
    let results: [SearchResult]
    
    private enum CodingKeys: String, CodingKey {
        case total
        case totalPage = "total_pages"
        case results
    }
    
}

struct SearchResult: Decodable {
    let id: String
    let urls: PhotoURLs
}

extension SearchResult {
    func toDomain() -> Photo {
        return Photo(id: id, urlString: urls.small)
    }
}

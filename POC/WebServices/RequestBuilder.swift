//
//  RequestBuilder.swift
//  POC
//
//  Created by Amit Kumar Battan on 25/03/17.
//  Copyright © 2017 Amit Kumar Battan. All rights reserved.
//

import Foundation

class RequestBuilder {
    
    let baseUrl = "https://api-v2.olx.com"
    let pageSize:Int = 10
    
    func requestOlxItems(searchString:String, offSet:Int) -> URLRequest {
        let urlString:String = "\(baseUrl)/items?location=www.olx.com.ar&searchTerm=\(searchString)&pageSize=\(pageSize)&offset=\(offSet)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }

    func requestNextPageForOlxItems(query:String) -> URLRequest? {
        if let urlString:String = "\(baseUrl)\(query)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url:URL = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            return request
        }
        return nil
    }

}

//
//  WebServiceManager.swift
//  POC
//
//  Created by Amit Kumar Battan on 25/03/17.
//  Copyright © 2017 Amit Kumar Battan. All rights reserved.
//

import Foundation

class WebServiceManager {
    let session: URLSession

    static let shared:WebServiceManager = {
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        return WebServiceManager(configuration: URLSessionConfiguration.default)
    }()
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
    }
    
    @discardableResult func fetch(URLRequest: URLRequest, completionHandler: @escaping (Any?, Error?) -> Void) -> URLSessionTask {
        let task = self.session.dataTask(with: URLRequest) { (data, response, sError) in
            
            var json: Any? = nil
            var error:Error? = sError
            
            if let responseData = data {
                do {
                    json = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                } catch let error1 as NSError {
                    error = error1
                    
                } catch {
                    
                }
            }
            DispatchQueue.main.async {
                completionHandler(json, error)
            }
        }
        task.resume()
        return task
    }
}

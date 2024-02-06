//
//  APIHelper.swift
//  LazyLoadingColection
//
//  Created by Karan V on 05/02/24.
//

import Foundation
class APIHelper {
    class var sharedInstance: APIHelper {
        
        struct Singleton {
            static let instance = APIHelper()
        }
        return Singleton.instance
    }

    
    public func getAPI(apiURL:String, delegate: @escaping([String: AnyObject]) -> ()) {
        let Url = String(format: apiURL)
        guard let serviceUrl = URL(string: Url) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "GET"
        request.timeoutInterval = 20
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in

            if error != nil || data == nil {
                print("Client error!")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid HTTP response")
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                print("HTTP response status code: \(httpResponse.statusCode)")
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
//                print("The Response is : ",json)
                DispatchQueue.main.async {
                    delegate(json as! [String: AnyObject])
                }
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }

        task.resume()

    }

}

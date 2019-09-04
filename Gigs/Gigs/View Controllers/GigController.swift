//
//  GigController.swift
//  Gigs
//
//  Created by William Chen on 9/4/19.
//  Copyright © 2019 William Chen. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case encodingError
    case responseError
    case otherError
    case noData
    case noDecode
}

class GigController{
    var bearer: Bearer?
    
    let baseURL = URL(string: "https://lambdagigs.vapor.cloud/api")!
    
    func signUp(with user: User, completion: @escaping (NetworkError?) -> Void) {
        let signUpUrl = baseURL
            .appendingPathComponent("users")
            .appendingPathComponent("signup")
        
        // https://lambdagigs.vapor.cloud/api/users/signup
        var request = URLRequest(url:signUpUrl)
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        
        do {
            // Convert the User object into JSON data.
            let userData = try encoder.encode(user)
            
            // Attach the user JSON to the URLRequest
            request.httpBody = userData
        } catch {
            NSLog("Error encoding user: \(error)")
            completion(.encodingError)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(.responseError)
                return
            }
            
            if let error = error {
                NSLog("Error creating user on server: \(error)")
                completion(.otherError)
                return
            }
            completion(nil)
            }.resume()
        
    }
        func login(with user: User, completion: @escaping (NetworkError?) -> Void) {
            
            // Set up the URL
            
            let loginURL = baseURL
                .appendingPathComponent("users")
                .appendingPathComponent("login")
            
            // Set up a request
            
            var request = URLRequest(url: loginURL)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let encoder = JSONEncoder()
            
            do {
                request.httpBody = try encoder.encode(user)
            } catch {
                NSLog("Error encoding user object: \(error)")
                completion(.encodingError)
                return
            }
            
            // Perform the request
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                // Handle errors
                
                if let response = response as? HTTPURLResponse,
                    response.statusCode != 200 {
                    completion(.responseError)
                    return
                }
                
                if let error = error {
                    NSLog("Error logging in: \(error)")
                    completion(.otherError)
                    return
                }
                
                // (optionally) handle the data returned
                
                guard let data = data else {
                    completion(.noData)
                    return
                }
                
                do {
                    let bearer = try JSONDecoder().decode(Bearer.self, from: data)
                    self.bearer = bearer
                } catch {
                    completion(.noDecode)
                    return
                }
                completion(nil)
                }.resume()
        }
        
}



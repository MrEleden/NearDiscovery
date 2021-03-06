//
//  GooglePlacesSearchService.swift
//  NearDiscovery
//
//  Created by Christophe DURAND on 03/01/2019.
//  Copyright © 2019 Christophe DURAND. All rights reserved.
//

import Foundation
import CoreLocation

class GooglePlacesSearchService {
    //MARK: - Properties
    var task: URLSessionDataTask?
    private var googlePlacesSearchSession: URLSession
    
    //MARK: - Initializers
    init(googlePlacesSearchSession: URLSession = URLSession(configuration: .default)) {
        self.googlePlacesSearchSession = googlePlacesSearchSession
    }
    
    //MARK: - Methods
    //Helper's methods URL
    func googlePlacesSearchURL(location: CLLocation, keyword: String) -> String {
        let baseURL = Constants.GooglePlacesSearchURL.baseURL
        let locationURL = Constants.GooglePlacesSearchURL.locationURL + String(location.coordinate.latitude) + "," + String(location.coordinate.longitude)
        let rankbyURL = Constants.GooglePlacesSearchURL.rankByURL
        let keywordURL = Constants.GooglePlacesSearchURL.keywordURL + keyword
        let keyURL = Constants.GoogleApiKey.apiKeyURL + Constants.GoogleApiKey.apiKey
        
        return baseURL + locationURL + rankbyURL + keywordURL + keyURL
    }
    
    func googlePlacesPhotosURL(photoreference: String) -> String {
        let baseURL = Constants.GooglePlacesPhotosURL.baseURL
        let maxwidthURL = Constants.GooglePlacesPhotosURL.maxwidthURL
        let photoreferenceURL = Constants.GooglePlacesPhotosURL.photoreferenceURL + photoreference
        let keyURL = Constants.GoogleApiKey.apiKeyURL + Constants.GoogleApiKey.apiKey
        
        return baseURL + maxwidthURL + photoreferenceURL + keyURL
    }
    
    //API method
    func getGooglePlacesSearchData(keyword: String, location: CLLocation, callback: @escaping (Bool, GooglePlacesSearchResponse) -> Void) {
        guard let url = URL(string: googlePlacesSearchURL(location: location, keyword: keyword)) else { return }
        task?.cancel()
        task = googlePlacesSearchSession.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, GooglePlacesSearchResponse(results: []))
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, GooglePlacesSearchResponse(results: []))
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(GooglePlacesSearchResponse.self, from: data) else {
                    callback(false, GooglePlacesSearchResponse(results: []))
                    return
                }
                callback(true, responseJSON)
            }
        }
        task?.resume()
    }
}

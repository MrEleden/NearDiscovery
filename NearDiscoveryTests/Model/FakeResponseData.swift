//
//  FakeResponseData.swift
//  NearDiscoveryTests
//
//  Created by Christophe DURAND on 19/12/2018.
//  Copyright © 2018 Christophe DURAND. All rights reserved.
//

import Foundation

class FakeResponseData {
    
    static let incorrectData = "error".data(using: .utf8)!
    
    static let responseOK = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 200, httpVersion: nil, headerFields: [:])!
    
    static let responseKO = HTTPURLResponse(
        url: URL(string: "https://openclassrooms.com")!,
        statusCode: 500, httpVersion: nil, headerFields: [:])!
    
    class AllTypeOfError: Error {}
    static let error = AllTypeOfError()
}

class FakeGooglePlacesSearchResponseData: FakeResponseData {
    static var googlePlacesSearchCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "GooglePlacesSearchService", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
}

class FakeGooglePlacesDetailsResponseData: FakeResponseData {
    static var googlePlacesDetailsCorrectData: Data? {
        let bundle = Bundle(for: FakeResponseData.self)
        let url = bundle.url(forResource: "GooglePlacesDetailsService", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
}

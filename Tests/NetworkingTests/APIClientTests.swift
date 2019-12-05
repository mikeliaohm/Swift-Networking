//
//  File.swift
//  
//
//  Created by Mike Liao on 2019/11/30.
//

import XCTest
@testable import Networking

class APIClientTests: XCTestCase {

    
    func testInitAPIClient() {
        
        let url = URL(string: "https://www.amiiboapi.com/api/amiibo/")!
        let fullURL = URL(string: "/", relativeTo: url)
        
        XCTAssertNotNil(fullURL)
    }
    
    func testDecodeAPI() {
        
        struct AmiiboFigure: Codable {
            
            let amiiboSeries: String
            let character: String
            let gameSeries: String
            let head: String
            let image: String
            let name: String
            let release: Release
            let tail: String
            let type: String
        }
        
        struct Release: Codable {
            let au: String?
            let eu: String?
            let jp: String?
            let na: String?
        }

        
        struct AmiiboAPIRequest: GetAPIRequest {
            typealias Response = AmiiboAPIResponse
            var resourceName = "/"
        }
        
        struct AmiiboAPIResponse: Decodable {
            let amiibo: [AmiiboFigure]
        }
        
        let apiClient = APIClient(domain: "https://www.amiiboapi.com/api/amiibo/")
        let newExpectation = expectation(description: "apiexpectation")
        
        apiClient.get(apiRequest: AmiiboAPIRequest()) {
            result in
            
            XCTAssertNil(result)
            newExpectation.fulfill()
        }

        waitForExpectations(timeout: 3.0) { error in
            
            XCTAssertNil(error)
        }
        
    }
}

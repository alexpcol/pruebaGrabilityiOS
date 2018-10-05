//
//  testRappiTests.swift
//  testRappiTests
//
//  Created by chila on 10/5/18.
//  Copyright © 2018 chila. All rights reserved.
//

import XCTest
@testable import testRappi

class testRappiTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testImageDownload() {
        let imageURL = "https://m.media-amazon.com/images/M/MV5BZjdkOTU3MDktN2IxOS00OGEyLWFmMjktY2FiMmZkNWIyODZiXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_SY1000_SX675_AL_.jpg"
        let expected = expectation(description: "Image from url loaded")
        let customImage = CustomImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 300 ))
        
        customImage.getImage(withURL: imageURL) {
            if !customImage.shouldShowDefault{
                expected.fulfill()
            }else{
                XCTFail()
            }
        }
        
        waitForExpectations(timeout: 6.0, handler: nil)
    }

}

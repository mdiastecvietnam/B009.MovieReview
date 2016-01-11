//
//  ApplicationControllerTests.swift
//  MovieReviewApp
//
//  Created by Nguyen Duc Hiep on 7/1/15.
//  Copyright (c) 2015 Nguyen Hanh. All rights reserved.
//

import XCTest

class ApplicationControllerTests: XCTestCase
{
    var appView: MApplicationView!
    var appController: ApplicationController!
    
    override func setUp()
    {
        super.setUp()
        appController = ApplicationController()
        appView = MApplicationView()
        appController.view = appView
    }
    
    override func tearDown()
    {
        appView = nil
        appController = nil
        super.tearDown()
    }

    func test_applicationDidFinishLaunch()
    {
        appView.excute() {
            self.appController.applicationDidFinishLaunch()
            self.appView.setFlagForKey("applicationDidFinishLaunch")
        }
        appView.waitForFlag("applicationDidFinishLaunch")
        
        XCTAssertNotNil(appController.listMovieController)
        XCTAssertNotNil(appView.listMovieView)
        XCTAssertTrue(appController.view === appView)
        XCTAssertTrue(appController.listMovieController.view === appView.listMovieView)
    }
}

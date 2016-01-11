//
//  ListMovieControllerTests.swift
//  MovieReview
//
//  Created by Nguyen Duc Hiep on 7/6/15.
//  Copyright (c) 2015 Nguyen Hanh. All rights reserved.
//

import XCTest

class ListMovieControllerTests: XCTestCase
{
    var server: MServer!
    var appView: MApplicationView!
    var appController: ApplicationController!
    weak var listMovieController: ListMovieController!
    weak var listMovieView: MListMovieView!
    
    override func setUp()
    {
        super.setUp()
        
        server = MServer()
        
        appController = ApplicationController(server: server)
        appView = MApplicationView()
        appController.view = appView
        
        appView.excute() {
            self.appController.applicationDidFinishLaunch()
            self.appView.setFlagForKey("applicationDidFinishLaunch")
        }
        appView.waitForFlag("applicationDidFinishLaunch")
        
        listMovieController = appController.listMovieController
        listMovieView = appView.listMovieView
    }
    
    override func tearDown()
    {
        appView = nil
        appController = nil
        super.tearDown()
    }
    
    func test_viewDidLoad_noMovies()
    {
        appView.excute() {
            self.listMovieController.viewDidLoad()
            self.listMovieView.setFlagForKey("viewDidLoad")
        }
        
        appView.waitForFlag("viewDidLoad", holder: listMovieView)
        appView.waitForHandler({ () -> Bool in
            self.listMovieView.searching == 0
        })
        
        XCTAssertEqual(0, listMovieView.listMovieItemViews.count)
    }
    
    func test_viewDidLoad_4Movies()
    {
        var searchText : String = ""
        server.generate(4, searchText: "")
        appView.excute() {
            self.listMovieController.viewDidLoad()
            self.listMovieView.setFlagForKey("viewDidLoad")
        }
        
        appView.waitForFlag("viewDidLoad", holder: listMovieView)
        appView.waitForHandler({
            return self.listMovieView.searching == 0
        })

        
        XCTAssertEqual(4, listMovieView.listMovieItemViews.count)
        
        for (var i = 0; i < 4; i++) {
            appView.excute() { [i] in
                self.listMovieController.rowViewWillAppear(i)
                self.listMovieView.setFlagForKey("itemViewWillAppear_\(i)")
            }
        }
        
        for (var i = 0; i < 4; i++) {
            appView.waitForFlag("itemViewWillAppear_\(i)", holder: listMovieView)
        }
        
        for (var i = 0; i < 4; i++) {
            XCTAssertEqual("title_\(searchText)_\(i)", listMovieView.listMovieItemViews[i]._title);
        }
    }
    
    func test_LostConnection()
    {
//        server.generate(4, searchText: "")
//        server.error = NSError(domain: "", code: 1, userInfo: nil)
//        server.errorData = NSErrorPointer()
//        server.errorData!.debugDescription = "lost connection"
//        server.errorData!.memory = server.error
        
        
        appView.excute({
            self.listMovieController.viewDidLoad()
            self.listMovieView.setFlagForKey("viewDidLoad")
        })
        appView.waitForFlag("viewDidLoad", holder: listMovieView)
        appView.waitForHandler({
        () -> Bool in
            return self.listMovieView.searching == 0
        })
        
        XCTAssertEqual(0, listMovieView.listMovieItemViews.count)
        XCTAssertEqual("Connection Error!", listMovieView.alertType);
//        XCTAssertEqual("Please check your connection", listMovieView.alertMsg);
    }
    func test_Search_NotMatch()
    {
        var searchText = "ABC"
        server.generate(0, searchText: searchText)
        appView.excute({
            self.listMovieView.searchText = searchText
            self.listMovieController.viewDidLoad()
            self.listMovieView.setFlagForKey("viewDidLoad")
        })
        appView.waitForFlag("viewDidLoad", holder: listMovieView)
        appView.waitForHandler({
            () -> Bool in
            return self.listMovieView.searching == 0
        })
        
        XCTAssertEqual(0, listMovieView.listMovieItemViews.count)
        XCTAssertEqual("", listMovieView.alertType);
        
    }
    func test_Search_Match()
    {
        var searchText = "ABC"
        var matchNum = 2
        server.generate(matchNum, searchText: searchText)
        appView.excute({
            self.listMovieView.searchText = searchText
            self.listMovieController.viewDidLoad()
            self.listMovieView.setFlagForKey("viewDidLoad")
        })
        appView.waitForFlag("viewDidLoad", holder: listMovieView)
        appView.waitForHandler({
            () -> Bool in
            return self.listMovieView.searching == 0
        })
        
        XCTAssertEqual(matchNum, listMovieView.listMovieItemViews.count)
        XCTAssertEqual("", listMovieView.alertType);
        
        for (var i = 0; i < matchNum; i++) {
            var index = i
            appView.excute() {
                self.listMovieController.rowViewWillAppear(index)
                self.listMovieView.setFlagForKey("itemViewWillAppear_\(index)")
            }
        }
        
        for (var i = 0; i < matchNum; i++) {
            appView.waitForFlag("itemViewWillAppear_\(i)", holder: listMovieView)
        }
        
        for (var i = 0; i < matchNum; i++) {
            XCTAssertEqual("title_\(searchText)_\(i)", listMovieView.listMovieItemViews[i]._title)
        }
        
    }
    
    func test_Search_Timout()
    {
        var searchText = ""
        var matchNum = 4
        server.generate(matchNum, searchText: searchText)
        appView.excute({
            self.listMovieView.searchText = searchText
            self.listMovieController.viewDidLoad()
            self.listMovieView.setFlagForKey("viewDidLoad")
        })
        appView.waitForFlag("viewDidLoad", holder: listMovieView)
        appView.waitForHandler({
            () -> Bool in
            return self.listMovieView.searching == 0
        })
        
        XCTAssertEqual(matchNum, listMovieView.listMovieItemViews.count)
        XCTAssertEqual("", listMovieView.alertType);
        
        for (var i = 0; i < matchNum; i++) {
            var index = i
            appView.excute() {
                self.listMovieController.rowViewWillAppear(index)
                self.listMovieView.setFlagForKey("itemViewWillAppear_\(index)")
            }
        }
        
        for (var i = 0; i < matchNum; i++) {
            appView.waitForFlag("itemViewWillAppear_\(i)", holder: listMovieView)
        }
        
        for (var i = 0; i < matchNum; i++) {
            XCTAssertEqual("title_\(searchText)_\(i)", listMovieView.listMovieItemViews[i]._title)
        }
        
        server.error = NSError()
        
        appView.excute({
            self.listMovieView.searchText = "abc"
            self.listMovieController.textDidFinishEditing()
            self.listMovieView.setFlagForKey("textDidFinishEditing")
        })
        appView.waitForFlag("textDidFinishEditing", holder: listMovieView)
        appView.waitForHandler({
            () -> Bool in
            return self.listMovieView.searching == 0
        })
        
        XCTAssertEqual(0, listMovieView.listMovieItemViews.count)
        XCTAssertEqual("Connection Error!", listMovieView.alertType);
//        XCTAssertEqual("Please check your connection", listMovieView.alertMsg);
        
    }
    
    func test_clickOnItem_test()
    {
        
        var searchText = ""
        var matchNum = 4
        server.generate(matchNum, searchText: searchText)
        appView.excute({
            self.listMovieView.searchText = searchText
            self.listMovieController.viewDidLoad()
            self.listMovieView.setFlagForKey("viewDidLoad")
        })
        appView.waitForFlag("viewDidLoad", holder: listMovieView)
        appView.waitForHandler({
            () -> Bool in
            return self.listMovieView.searching == 0
        })
        
        XCTAssertEqual(matchNum, listMovieView.listMovieItemViews.count)
        XCTAssertEqual("", listMovieView.alertType);
        
        for (var i = 0; i < matchNum; i++) {
            var index = i
            appView.excute() {
                self.listMovieController.rowViewWillAppear(index)
                self.listMovieView.setFlagForKey("itemViewWillAppear_\(index)")
            }
        }
        
        for (var i = 0; i < matchNum; i++) {
            appView.waitForFlag("itemViewWillAppear_\(i)", holder: listMovieView)
        }
        
        for (var i = 0; i < matchNum; i++) {
            XCTAssertEqual("title_\(searchText)_\(i)", listMovieView.listMovieItemViews[i]._title)
        }
        
        var sellectedItem : Int = 1
        appView.excute({
            self.listMovieController.rowViewDidSelected(sellectedItem)
            self.listMovieView.setFlagForKey("SellectItem")
        })
        appView.waitForFlag("SellectItem", holder:listMovieView)
        
        XCTAssertNotNil(listMovieController.detailMovieController )
        XCTAssertNotNil(listMovieView.detailMovieView )
        XCTAssertTrue(listMovieController.detailMovieController!.view === listMovieView.detailMovieView )
        XCTAssertTrue(listMovieController.detailMovieController?.movie.id == sellectedItem)
        
    }

}

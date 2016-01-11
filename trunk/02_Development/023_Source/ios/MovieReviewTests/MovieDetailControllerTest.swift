//
//  MovieDetailControllerTest.swift
//  MovieReview
//
//  Created by Nguyen Hanh on 7/14/15.
//  Copyright (c) 2015 MDI ASTEC VN CO., LTD. All rights reserved.
//


import XCTest

class MovieDetailControllerTest: XCTestCase
{
    var server: MServer!
    var appView: MApplicationView!
    var appController: ApplicationController!
    weak var listMovieController: ListMovieController!
    weak var listMovieView: MListMovieView!
    weak var movieDetailController : MovieDetailController!
    weak var movieDetailView : MDetailMovieView!
    var item : Int = 1
    
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
        
        
        var matchNum = 4
        server.generate(matchNum, searchText: "")
        appView.excute({
            self.listMovieController.viewDidLoad()
            self.listMovieView.setFlagForKey("viewDidLoad")
        })
        appView.waitForFlag("viewDidLoad", holder: listMovieView)
        appView.waitForHandler({
            () -> Bool in
            return self.listMovieView.searching == 0
        })
        
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
        var item = self.item
        
        appView.excute({
            self.listMovieController.rowViewDidSelected(item)
            self.listMovieView.setFlagForKey("SellectItem")
        })
        appView.waitForFlag("SellectItem", holder:listMovieView)
        
        movieDetailController = listMovieController.detailMovieController
        movieDetailView = listMovieView.detailMovieView
    }
    
    override func tearDown()
    {
        appView = nil
        appController = nil
        super.tearDown()
    }
    
    func test_LoadingSuccess()
    {
        var itemNum   =  item - 1
        var search = ""
        
//        server.generate(item, searchText: search)
        appView.excute() {
            self.movieDetailController.viewDidLoad()
            self.appView.setFlagForKey("DetailMovieViewDidLoad")
        }
        appView.waitForFlag("DetailMovieViewDidLoad")
        
        appView.waitForHandler({
            return self.movieDetailView.loadingState == false
        })
        XCTAssertEqual(movieDetailView.detail, "description_\(item)")
        XCTAssertEqual(movieDetailView.listCommentItemView.count, item )
        XCTAssertEqual(movieDetailView.trailer  , "trailer_\(item)")
        
        XCTAssertEqual(movieDetailView.movieTitle   , "title_\(search)_\(item)")
        if( movieDetailView.averageRate != nil ||  listMovieView.listMovieItemViews[item]._rate != nil )
        {
            XCTAssertEqual(movieDetailView.averageRate!      , listMovieView.listMovieItemViews[item]._rate! )
        }
        XCTAssertEqual(movieDetailView.alertTitle, "")
    }
    
    func test_LoadingNetWorkError_reloadOK()
    {
        var commentNum   =  4
//        server.generate(commentNum, searchText: "abc")
        server.reset()
        appView.excute() {
            self.movieDetailController.viewDidLoad()
            self.appView.setFlagForKey("DetailMovieViewDidLoad")
        }
        appView.waitForFlag("DetailMovieViewDidLoad")
        
        appView.waitForHandler({
            return self.movieDetailView.loadingState == false
        })
//        XCTAssertEqual(movieDetailView.detail, "description_\(item)")
//        XCTAssertEqual(movieDetailView.listCommentItemView.count, commentNum )
//        XCTAssertEqual(movieDetailView.trailer  , "trailer_\(item)")
        XCTAssertEqual(movieDetailView.movieTitle   , "title__\(item)")
        if( movieDetailView.averageRate != nil ||  listMovieView.listMovieItemViews[item]._rate != nil )
        {
            XCTAssertEqual(movieDetailView.averageRate!      , listMovieView.listMovieItemViews[item]._rate! )
        }
        XCTAssertEqual(movieDetailView.alertTitle, "Connection Error!")
        server.generate(4, searchText: "")
        appView.excute({
            
            self.movieDetailController.alertOption(0)
            self.movieDetailView.alertTitle = ""
            self.movieDetailView.alertMsg = ""
            
            self.appView.setFlagForKey("alertOption1")
        })
        
        appView.waitForFlag("alertOption1")
        appView.waitForHandler({
            return self.movieDetailView.loadingState == false
        })
        
        
        XCTAssertEqual(movieDetailView.detail, "description_\(item)")
        XCTAssertEqual(movieDetailView.listCommentItemView.count, item )
        XCTAssertEqual(movieDetailView.trailer  , "trailer_\(item)")
        
        XCTAssertEqual(movieDetailView.movieTitle   , "title__\(item)")
        
        if( movieDetailView.averageRate != nil ||  listMovieView.listMovieItemViews[item]._rate != nil )
        {
            XCTAssertEqual(movieDetailView.averageRate!      , listMovieView.listMovieItemViews[item]._rate! )
        }
        XCTAssertEqual(movieDetailView.alertTitle, "")

    }
    
    func test_LoadingNetWorkError_reload_error()
    {
        var commentNum   =  4
        //        server.generate(commentNum, searchText: "abc")
        server.reset()
        appView.excute() {
            self.movieDetailController.viewDidLoad()
            self.appView.setFlagForKey("DetailMovieViewDidLoad")
        }
        appView.waitForFlag("DetailMovieViewDidLoad")
        
        appView.waitForHandler({
            return self.movieDetailView.loadingState == false
        })
        //        XCTAssertEqual(movieDetailView.detail, "description_\(item)")
        //        XCTAssertEqual(movieDetailView.listCommentItemView.count, commentNum )
        //        XCTAssertEqual(movieDetailView.trailer  , "trailer_\(item)")
        XCTAssertEqual(movieDetailView.movieTitle   , "title__\(item)")
        if( movieDetailView.averageRate != nil ||  listMovieView.listMovieItemViews[item]._rate != nil )
        {
            XCTAssertEqual(movieDetailView.averageRate!      , listMovieView.listMovieItemViews[item]._rate! )
        }
        XCTAssertEqual(movieDetailView.alertTitle, "Connection Error!")
//        server.generate(4, searchText: "")
        appView.excute({
            
            self.movieDetailController.alertOption(0)
            self.movieDetailView.alertTitle = ""
            self.movieDetailView.alertMsg = ""
            
            self.appView.setFlagForKey("alertOption1")
        })
        
        appView.waitForFlag("alertOption1")
        appView.waitForHandler({
            return self.movieDetailView.loadingState == false
        })
        
        
        XCTAssertEqual(movieDetailView.alertTitle, "Connection Error!")
    }
    
    
    func test_LoadingNetWorkError_back()
    {
        var commentNum   =  4
        //        server.generate(commentNum, searchText: "abc")
        server.reset()
        appView.excute() {
            self.movieDetailController.viewDidLoad()
            self.appView.setFlagForKey("DetailMovieViewDidLoad")
        }
        appView.waitForFlag("DetailMovieViewDidLoad")
        
        appView.waitForHandler({
            return self.movieDetailView.loadingState == false
        })
        //        XCTAssertEqual(movieDetailView.detail, "description_\(item)")
        //        XCTAssertEqual(movieDetailView.listCommentItemView.count, commentNum )
        //        XCTAssertEqual(movieDetailView.trailer  , "trailer_\(item)")
        XCTAssertEqual(movieDetailView.movieTitle   , "title__\(item)")
        if( movieDetailView.averageRate != nil ||  listMovieView.listMovieItemViews[item]._rate != nil )
        {
            XCTAssertEqual(movieDetailView.averageRate!      , listMovieView.listMovieItemViews[item]._rate! )
        }
        XCTAssertEqual(movieDetailView.alertTitle, "Connection Error!")
        //        server.generate(4, searchText: "")
        appView.excute({
            
            self.movieDetailController.alertOption(1)
            self.movieDetailView.alertTitle = ""
            self.movieDetailView.alertMsg = ""
            
            self.appView.setFlagForKey("alertOption1")
        })
        
        
        appView.waitForFlag("alertOption1")
       
        XCTAssertNil(movieDetailView)
        
    }

    
    func test_Setting_Comment()
    {
        var commentNum   =  item + 1
        var search = ""
        
        //        server.generate(item, searchText: search)
        appView.excute() {
            self.movieDetailController.viewDidLoad()
            self.appView.setFlagForKey("DetailMovieViewDidLoad")
        }
        appView.waitForFlag("DetailMovieViewDidLoad")
        
        appView.waitForHandler({
            return self.movieDetailView.loadingState == false
        })
        XCTAssertEqual(movieDetailView.detail, "description_\(item)")
        XCTAssertEqual(movieDetailView.listCommentItemView.count, item )
        XCTAssertEqual(movieDetailView.trailer  , "trailer_\(item)")
        
        XCTAssertEqual(movieDetailView.movieTitle   , "title_\(search)_\(item)")
        
        appView.excute() {

            for (var i = 0 ; i < self.item; i++ )
            {
                self.movieDetailController.loadRowComment(i)
            }
            self.appView.setFlagForKey("loadRowCommentList")
        }
        appView.waitForFlag("loadRowCommentList")
        
        if( movieDetailView.averageRate != nil ||  listMovieView.listMovieItemViews[item]._rate != nil )
        {
            XCTAssertEqual(movieDetailView.averageRate!      , listMovieView.listMovieItemViews[item]._rate! )
        }
        XCTAssertEqual(movieDetailView.alertTitle, "")
        
        server.submitComment(item, user: "user", comment: "comment", rate: 4, timeout: 1)
        
        appView.excute({
        
            self.movieDetailView.inputComment = "comment"
            self.movieDetailView.inputUser = "user"
            self.movieDetailView.inputRate = 4
            self.movieDetailController.submitComment()
            self.appView.setFlagForKey("setComment")
        })
        
        appView.waitForFlag("setComment")
        appView.waitForHandler({
            return self.movieDetailView.loadingState == false
        })
        XCTAssertEqual(self.movieDetailView.listCommentItemView.count , commentNum)
        XCTAssertEqual(movieDetailView.alertTitle, "")
        
    }
    
    
    func test_Setting_Comment_error_reload()
    {
        var commentNum   =  item + 1
        var search = ""
        
        //        server.generate(item, searchText: search)
        appView.excute() {
            self.movieDetailController.viewDidLoad()
            self.appView.setFlagForKey("DetailMovieViewDidLoad")
        }
        appView.waitForFlag("DetailMovieViewDidLoad")
        
        appView.waitForHandler({
            return self.movieDetailView.loadingState == false
        })
        XCTAssertEqual(movieDetailView.detail, "description_\(item)")
        XCTAssertEqual(movieDetailView.listCommentItemView.count, item )
        XCTAssertEqual(movieDetailView.trailer  , "trailer_\(item)")
        
        XCTAssertEqual(movieDetailView.movieTitle   , "title_\(search)_\(item)")
        
        appView.excute() {
            
            for (var i = 0 ; i < self.item; i++ )
            {
                self.movieDetailController.loadRowComment(i)
            }
            self.appView.setFlagForKey("loadRowCommentList")
        }
        appView.waitForFlag("loadRowCommentList")
        
        if( movieDetailView.averageRate != nil ||  listMovieView.listMovieItemViews[item]._rate != nil )
        {
            XCTAssertEqual(movieDetailView.averageRate!      , listMovieView.listMovieItemViews[item]._rate! )
        }
        XCTAssertEqual(movieDetailView.alertTitle, "")
        
        server.submitComment(item, user: "user1", comment: "comment", rate: 4, timeout: 1)
        
        appView.excute({
            
            self.movieDetailView.inputComment = "comment"
            self.movieDetailView.inputUser = "user"
            self.movieDetailView.inputRate = 4
            self.movieDetailController.submitComment()
            self.appView.setFlagForKey("setComment")
        })
        
        appView.waitForFlag("setComment")
        appView.waitForHandler({
            return self.movieDetailView.loadingState == false
        })
        XCTAssertEqual(self.movieDetailView.listCommentItemView.count , item)
        XCTAssertEqual(movieDetailView.alertTitle, "Connection Error!")
//        XCTAssertEqual("Please check your connection", movieDetailView.alertMsg);
        appView.excute({
        
            self.movieDetailController.alertOption(0)
            self.movieDetailView.alertTitle = ""
            self.movieDetailView.alertMsg = ""

            self.appView.setFlagForKey("alertOption1")
        })
        
        appView.waitForFlag("alertOption1")
        appView.waitForHandler({
            return self.movieDetailView.loadingState == false
        })
        
        
        XCTAssertEqual(movieDetailView.detail, "description_\(item)")
        XCTAssertEqual(movieDetailView.listCommentItemView.count, item )
        XCTAssertEqual(movieDetailView.trailer  , "trailer_\(item)")
        
        XCTAssertEqual(movieDetailView.movieTitle   , "title_\(search)_\(item)")
        
        if( movieDetailView.averageRate != nil ||  listMovieView.listMovieItemViews[item]._rate != nil )
        {
            XCTAssertEqual(movieDetailView.averageRate!      , listMovieView.listMovieItemViews[item]._rate! )
        }
        XCTAssertEqual(movieDetailView.alertTitle, "")
        
        
    }
    
    func test_Setting_Comment_error_Back()
    {
        var commentNum   =  item + 1
        var search = ""
        
        //        server.generate(item, searchText: search)
        appView.excute() {
            self.movieDetailController.viewDidLoad()
            self.appView.setFlagForKey("DetailMovieViewDidLoad")
        }
        appView.waitForFlag("DetailMovieViewDidLoad")
        
        appView.waitForHandler({
            return self.movieDetailView.loadingState == false
        })
        XCTAssertEqual(movieDetailView.detail, "description_\(item)")
        XCTAssertEqual(movieDetailView.listCommentItemView.count, item )
        XCTAssertEqual(movieDetailView.trailer  , "trailer_\(item)")
        
        XCTAssertEqual(movieDetailView.movieTitle   , "title_\(search)_\(item)")
        
        appView.excute() {
            
            for (var i = 0 ; i < self.item; i++ )
            {
                self.movieDetailController.loadRowComment(i)
            }
            self.appView.setFlagForKey("loadRowCommentList")
        }
        appView.waitForFlag("loadRowCommentList")
        
        if( movieDetailView.averageRate != nil ||  listMovieView.listMovieItemViews[item]._rate != nil )
        {
            XCTAssertEqual(movieDetailView.averageRate!      , listMovieView.listMovieItemViews[item]._rate! )
        }
        XCTAssertEqual(movieDetailView.alertTitle, "")
        
        server.submitComment(item, user: "user1", comment: "comment", rate: 4, timeout: 1)
        
        appView.excute({
            
            self.movieDetailView.inputComment = "comment"
            self.movieDetailView.inputUser = "user"
            self.movieDetailView.inputRate = 4
            self.movieDetailController.submitComment()
            self.appView.setFlagForKey("setComment")
        })
        
        appView.waitForFlag("setComment")
        appView.waitForHandler({
            return self.movieDetailView.loadingState == false
        })
        XCTAssertEqual(self.movieDetailView.listCommentItemView.count , item)
        XCTAssertEqual(movieDetailView.alertTitle, "Connection Error!")
//        XCTAssertEqual("Please check your connection", movieDetailView.alertMsg);
        appView.excute({
            
            self.movieDetailController.alertOption(1)
            self.movieDetailView.alertTitle = ""
            self.movieDetailView.alertMsg = ""
            
            self.appView.setFlagForKey("alertOption1")
        })
        appView.waitForFlag("alertOption1")
        
        XCTAssertNil(self.movieDetailView )
//        XCTAssertNil(self.movieDetailController )
        
        
    }

    
}

//
//  ApplicationController.swift
//  MySwift
//
//  Created by Nguyen Hanh on 6/3/15.
//  Copyright (c) 2015 Nguyen Hanh. All rights reserved.
//

protocol ApplicationViewProtocol: NFSingleView {
    func showListMovieView(controller: ListMovieController)
}

class ApplicationController: NFApplicationController
{
    var server: DataBaseParse?
    
    override convenience init() {
        var server = NFServer.sharedServer()
        server.timeOutInterval = 5.0
        self.init(server: server)
    }
    
    init(server: NFServerProtocol!)
    {
        self.server = DataBaseParse(server: server)
        super.init()
    }
    
    var listMovieController: ListMovieController!
    override func applicationDidFinishLaunch() {
        listMovieController = ListMovieController(appController: self )
        applicationView.showListMovieView(listMovieController)
        super.applicationDidFinishLaunch()
    }
    
    var applicationView: ApplicationViewProtocol! { return view as! ApplicationViewProtocol!}
}

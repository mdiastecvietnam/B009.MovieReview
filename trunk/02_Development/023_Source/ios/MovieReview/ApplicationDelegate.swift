//
//  ApplicationDelegate.swift
//  MySwift
//
//  Created by Nguyen Hanh on 6/3/15.
//  Copyright (c) 2015 Nguyen Hanh. All rights reserved.
//

class ApplicationDelegate: NFTApplicationDelegate, ApplicationViewProtocol {
    func showListMovieView(controller: ListMovieController) {
        var listMovieView = ListMovieViewController(controller: controller)
        var navigator = UINavigationController(rootViewController: listMovieView)
//        window.backgroundColor = UIColor(red: 74, green: 160, blue: 190, alpha: 1)
        window.rootViewController = navigator
    }
    
    override init()
    {
        super.init()
        applicationController = ApplicationController()
    }
}



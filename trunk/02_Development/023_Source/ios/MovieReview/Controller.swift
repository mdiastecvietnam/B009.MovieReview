//
//  MovieSingleController.swift
//  MovieReview
//
//  Created by Nguyen Hanh on 7/8/15.
//  Copyright (c) 2015 MDI ASTEC VN CO., LTD. All rights reserved.
//

import Foundation

class Controller : NFSingleController
{
    weak var applicationController : ApplicationController!
    init(appController : ApplicationController) {
        applicationController = appController
        super.init()
    }
}

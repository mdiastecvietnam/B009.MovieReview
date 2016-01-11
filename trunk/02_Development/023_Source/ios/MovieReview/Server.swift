//
//  Server.swift
//  MovieReview
//
//  Created by Nguyen Hanh on 4/10/15.
//  Copyright (c) 2015 Nguyen Hanh. All rights reserved.
//

import Foundation

protocol Server
{
    func listMovie(searchTex: String, handler: ([Dictionary<String, AnyObject>], err : NSError?) -> Int);
    
    func getMovieDetail(movieId: Int, handler: (Dictionary<String, AnyObject>?, NSError?) -> Void)
    func readImage(URLString: String, handler: (NSData?) -> ());
    func readMovie(id: Int, handler: (Dictionary<String, AnyObject>?) -> ());
}

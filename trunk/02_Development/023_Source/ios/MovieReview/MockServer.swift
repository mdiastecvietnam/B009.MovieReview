//
//  MockServer.swift
//  MovieReview
//
//  Created by Nguyen Hanh on 4/10/15.
//  Copyright (c) 2015 Nguyen Hanh. All rights reserved.
//

import Foundation

class MockServer: NSObject, Server
{
    var serverQueue : NSOperationQueue
    
    var movieList : [Dictionary<String, AnyObject>]
    
    override init()
    {
        serverQueue = NSOperationQueue()
        
        let path = NSBundle.mainBundle().pathForResource("moviesList", ofType: "plist")
        let untypedArray: [AnyObject]? = NSArray(contentsOfFile: path!) as? [AnyObject]
        movieList = (untypedArray as! [Dictionary<String, AnyObject>]?)!
        
    }
    
//    var movieList : [Dictionary<String, AnyObject>] = [["id": 1, "title": "Cánh đồng hoang", "trialer" : "http://jplayer.org/video/m4v/Big_Buck_Bunny_Trailer.m4v", "Descrip" : "đạo diễn Hồng Sến ", "url" : "http://vytv.vn/upload/CanhDongHoang.jpg"], ["id": 2, "title": "Mui co chay", "trialer" : "http://vytv.vn/upload/CanhDongHoang.jpg", "Descrip" : "  đạo diễn Nguyên Hữu Mười ", "url" : "http://www.studentkgu.vn/file/pic/gallery/7972_view.jpg"], ["id": 3, "title": "cuon theo chieu gio", "trialer" : "https://youtu.be/rtZ0noEqkto", "Descrip" : "chuyen ve nang marggret", "url" : "http://upload.wikimedia.org/wikipedia/vi/thumb/6/6b/Gone_with_the_Wind_cover.jpg/200px-Gone_with_the_Wind_cover.jpg"]]
    
    func mainSearchProc (searchTex: String, handler: ([Dictionary<String, AnyObject>]) -> Int, queue: NSOperationQueue?)
    {
        var resultBuilder = [Dictionary<String, AnyObject>]()
        
        if (searchTex.isEmpty)
        {
            for movie in movieList
            {
                resultBuilder.append(movie)
            }
            
            queue?.addOperationWithBlock({ () -> Void in
                handler(resultBuilder)
            })
        }
        else
        {
            for movie in movieList
            {
                var title = movie["title"] as! String
                var range = title.rangeOfString(searchTex, options: NSStringCompareOptions.CaseInsensitiveSearch)
                if (range != nil)
                {
                    resultBuilder.append(movie)
                }
            }
            

            queue?.addOperationWithBlock({ () -> Void in
                handler(resultBuilder)
            })
        }
        
    }
    
    func listMovie(searchTex: String, handler: ([Dictionary<String, AnyObject>], err : NSError?) -> Int)
    {
        
//        var resultBuilder = [Dictionary<String, AnyObject>]()
//        if (searchTex.isEmpty)
//        {
//            for movie in movieList
//            {
//                resultBuilder.append(movie)
//            }
//            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                handler(resultBuilder)
//            })
//        }
//        else
//        {
//            for movie in movieList
//            {
//                var title = movie["title"] as! String
//                var range = title.rangeOfString(searchTex, options: NSStringCompareOptions.CaseInsensitiveSearch)
//                if (range != nil)
//                {
//                    resultBuilder.append(movie)
//                }
//            }
//            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                handler(resultBuilder)
//            })
//        }
        weak var callerQueue = NSOperationQueue.currentQueue()
        serverQueue.addOperationWithBlock ({ () -> Void in
            self.mainSearchProc(searchTex, handler: handler, queue: callerQueue)
        })
        
    }
    
    func downloadImage( url : NSString, sectionIndex : Int, handler : (AnyObject) -> (), queue : NSOperationQueue)
    {
        
        var imageUrl = NSURL(fileURLWithPath: url as String)
        var imageData = NSData(contentsOfURL: imageUrl!)
        var image = UIImage(data:imageData!)
        queue.addOperationWithBlock({ () -> Void in
            handler(image!)
        })
        
    }
    
    func readImage(URLString: String, handler: (NSData?) -> ())
    {
        weak var callerQueue = NSOperationQueue.currentQueue()
        serverQueue.addOperationWithBlock ({ () -> Void in
            var URL = NSURL(string: URLString)
            
            var data: NSData?
            if (URL == nil)
            {
                data = nil
            }
            else
            {
                data = NSData(contentsOfURL: URL!)
            }
            callerQueue?.addOperationWithBlock({ () -> Void in
                handler(data)
            })
        })
    }
    
//    func readImage(URLString: NSString, sectionIndex : Int, handler: (Int, AnyObject) -> ())
//    {
//        weak var callerQueue = NSOperationQueue.currentQueue()
//        serverQueue.addOperationWithBlock ({ () -> Void in
//            
//            self.downloadImage(URLString, sectionIndex, handler: handler, queue: callerQueue )
//        })
//        
//    }
    
    
    func readMovie(id: Int, handler: (Dictionary<String, AnyObject>?) -> ())
    {
        handler(nil)
    }
}

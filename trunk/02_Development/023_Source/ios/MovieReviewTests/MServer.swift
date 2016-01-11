//
//  MServer.swift
//  MovieReview
//
//  Created by Nguyen Duc Hiep on 7/8/15.
//  Copyright (c) 2015 MDI ASTEC VN CO., LTD. All rights reserved.
//

import UIKit

class MServer: NFMServer2
{
    var path: Paths = Paths()
    var movies = [[String:AnyObject]]()
    var error : NSError?
    var errorData : NSErrorPointer?
    
    func generate(movieCount: Int, searchText: String)
    {
        reset()
        for (var i = 0; i < movieCount; i++) {
            var title = "title_\(searchText )_\(i )"
            var poster = "poster_\(i)"
            var trailer = "trailer_\(i)"
            var commentList = [[String:AnyObject]]()
            for(var j = 0; j < i; j++ )
            {
                var id : Int = j
                var username: String = "user_\(j)"
                var comment: String = "comment_\(j)"
                var rate :Int = random()%5
                var commentItem : [String:AnyObject] = ["id":"\(j)","username":username,"comment":comment,"rate":rate]
                commentList.append(commentItem)
            }
    
            var description = "description_\(i)"
            var averageOfRate = 0.9 * Double(i % 5)
            var movieItem = ["id":"\(i )","title":title,"poster":poster,"trialer":trailer,"commentlist":commentList,"averageOfRate":averageOfRate ,"description":description]
    
            
            var json = ["status":"ok", "data":movieItem]
            
            var data = NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.allZeros, error: nil)
                       
            
            addRequest(path.getMovieDetail, method: "POST", paras: ["API_KEY":path.api_key, "movie_id":"\(i)"], error: error, data: data, delay: 1, count: UInt.max)
    
            movies.append(movieItem as! [String : AnyObject])
            
//            addRequest(poster, method: nil, paras: nil, error: nil, data: poster.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false), delay: 1, count: .max)
        }
        
        var json = ["status":"ok", "data":movies]
        
        var data = NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.allZeros, error: nil)
        addRequest(path.getMovieList, method: "POST", paras: ["API_KEY":path.api_key, "key_search": searchText], error: nil, data: data, delay: 1, count: .max)
    }
    
    func submitComment(movieId: Int, user:String, comment: String, rate: Int, timeout: NSTimeInterval)
    {
        
        var commentId = movieId+1
//        reset()
        var response = ["id": commentId,"movie_id":movieId,"username":user,"content":comment,"rate":rate,"create_time":"2015-07-14 09:09:37"]
        
        var json = ["status":"ok", "data":response]
        var data = NSJSONSerialization.dataWithJSONObject(json, options: NSJSONWritingOptions.allZeros, error: nil)
        
        var parameter = ["API_KEY":path.api_key,  "movie_id": "\(movieId)" , "user_name": user, "comment" : comment, "rate": "\(rate)"]
        
        addRequest(path.setComment, method: "POST", paras: parameter, error: nil, data: data, delay: timeout, count: UInt.max)
    }
    
}
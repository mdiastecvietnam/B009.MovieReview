
//
//  DatabaseServer.swift
//  MovieReview
//
//  Created by Nguyen Hanh on 7/8/15.
//  Copyright (c) 2015 MDI ASTEC VN CO., LTD. All rights reserved.
//

import Foundation


class DataBaseParse
{
    weak var realServer : NFServerProtocol? /*= NFServer.sharedServer()*/
    
    init( server : NFServerProtocol )
    {
        realServer = server
        
    }
    var path: Paths = Paths()
    
    
    func listMovie(searchTex: String, handler: ([Dictionary<String, AnyObject>]?, String?) -> Void)
    {
        var parameter = ["API_KEY":path.api_key, "key_search":searchTex]
        request(path.getMovieList, method: "POST", paras: parameter) { (dataResp, error) -> Void in
            
            if ( error == nil)
            {
                var listMovie : [Dictionary<String, AnyObject>]? = dataResp as? [Dictionary<String, AnyObject>]
                
                handler(listMovie, error)
                
            }
            else {
                handler(nil, error)
            }
            
        }
        
    }
    
    func getMovieDetail(movieId: Int, handler: (Dictionary<String, AnyObject>?, String?) -> Void)
    {
        var parameter = ["API_KEY":path.api_key,  "movie_id": "\(movieId)"]
        request(path.getMovieDetail, method: "POST", paras: parameter) { (dataResp, error) -> Void in
            
            if ( error == nil)
            {
                var movieDetail : Dictionary<String, AnyObject> = dataResp as! Dictionary<String, AnyObject>
                
                handler(movieDetail, error)
                
            }
            else {
                handler(nil, error)
            }
            
        }
        
    }
    
    func setComment( movieId: Int, user: String, comment: String, rate: Int, handler : ( Dictionary<String, AnyObject>?, String?) -> Void)
    {
        var parameter = ["API_KEY":path.api_key,  "movie_id": "\(movieId)" , "user_name": user, "comment" : comment, "rate": "\(rate)"]
        request(path.setComment, method: "POST",paras: parameter){ (dataResp, error) -> Void in
            
            if ( error == nil)
            {
                var movieDetail : Dictionary<String, AnyObject> = dataResp as! Dictionary<String, AnyObject>
                
                handler(movieDetail, error)
                
            }
            else {
                handler(nil, error)
            }
        }
        
    }
    
    func readImage(URLString: String, handler: (NSData?) -> ())
    {
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
        handler(data)
    }

    
    func readMovie(id: Int, handler: (Dictionary<String, AnyObject>?) -> ())
    {
    
    }
    
    
    
    func request( operation: String, method: String, paras:[NSObject : AnyObject]!, completionHandler: (dataResp:AnyObject?, error: String?) -> Void)
    {
        realServer?.request(operation, method: method, paras: paras , completion: { (error, data) -> Void in
            if (error == nil) {
                var parsedError: NSError? = nil
                var resp = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsedError) as! Dictionary<String,AnyObject>!
                if( parsedError == nil )
                {
                    var status : String? = resp["status"] as? String
                    if (status != nil && status == "false"  )
                    {
                        var errorMessage : String? = resp["message"] as? String
                        completionHandler(dataResp: nil, error: errorMessage)
                    }
                    else
                    {
                        var dataResp : AnyObject? = resp["data"]
                        completionHandler(dataResp: dataResp, error: nil)
                    }
                    
                }
                else
                {
                    completionHandler(dataResp: nil, error: "Data Response Error")
                }
            }
            else {
                completionHandler(dataResp: nil, error: "Connection Error!")
            }
        })
    }
    
    
}

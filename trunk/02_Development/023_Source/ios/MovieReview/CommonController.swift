//
//  CommonController.swift
//  MovieReview
//
//  Created by Nguyen Hanh on 7/8/15.
//  Copyright (c) 2015 MDI ASTEC VN CO., LTD. All rights reserved.
//

import Foundation


class Paths
{
    var getMovieList = "http://services.mdi-astec.vn/movie.review/movies/getMovieList"
    var getMovieDetail = "http://services.mdi-astec.vn/movie.review/movies/getdetailMovie"
    var setComment = "http://services.mdi-astec.vn/movie.review/comment/setComment"
    var api_key = "d6930fe47f769069087df98c4ae86a42"
    
}
class CommonController : NFSingleController
{
    weak var applicationController : ApplicationController!
    init(appController : ApplicationController) {
        applicationController = appController
        super.init()
    }
    
}


class CommentDataItem
{
    var user : String = ""
    var comment : String = ""
    var rate: Double = 0
}
class MovieListDataItem
{
    var id : Int = 0
    var title: String = ""
    var poster: String = ""
    var data: NSData?
    var averageRate: Double? = nil
}
class MovieDetailData
{
    var id : Int = 0
    var title: String = ""
    var trailer: String = ""
    var detail: String = ""
    var averageRate: Double? = nil
    var commentList : [CommentDataItem] = [CommentDataItem]()
}

class CommentRespDataItem
{
    var comment: CommentDataItem = CommentDataItem()
    var averageRate : Double? = nil
}

func ParserDatataMovieItem( data: Dictionary<String, AnyObject>) -> MovieListDataItem
{
    var movieListItem : MovieListDataItem = MovieListDataItem()
    var temp : AnyObject?
    
    temp = data["id"]
    if(temp != nil)
    {
        movieListItem.id = (temp as! String).toInt()!
    }

    temp = data["title"]
    if(temp != nil)
    {
        movieListItem.title = temp as! String
    }
    
    temp = data["poster"]
    if(temp != nil)
    {
        movieListItem.poster = temp as! String
    }
    
    temp = data["averageOfRate"]
    if(temp != nil)
    {
        var strTemp : NSString? = temp as? NSString
        if(strTemp != nil )
        {
            movieListItem.averageRate = strTemp!.doubleValue
        }
    }
    return movieListItem
}

func ParserCommentData( data: Dictionary<String, AnyObject>) -> CommentDataItem
{
    var comment = CommentDataItem()
    var temp : AnyObject?
    
    temp = data["username"]
    if(temp != nil)
    {
        comment.user = temp as! String
    }
    
    temp = data["comment"]
    if(temp != nil)
    {
        comment.comment = temp as! String
    }
    
    temp = data["rate"]
    if(temp != nil)
    {
        var strTemp : NSString? = temp as? NSString
        if(strTemp != nil )
        {
            comment.rate = strTemp!.doubleValue
        }
    }
    return comment
}

func ParserDatataMovieDetail( data: Dictionary<String, AnyObject>) -> MovieDetailData
{
    var movieDetail : MovieDetailData = MovieDetailData()
    var temp : AnyObject?
        
    temp = data["id"]
    if(temp != nil)
    {
        movieDetail.id = (temp as! String).toInt()!
    }

    temp = data["title"]
    if(temp != nil)
    {
        movieDetail.title = temp as! String
    }
    
    temp = data["trialer"]
    if(temp != nil)
    {
        movieDetail.trailer = temp as! String
    }
    
    temp = data["description"]
    if(temp != nil)
    {
        movieDetail.detail = temp as! String
    }
    
    temp = data["averageOfRate"]
    if(temp != nil)
    {
        var strTemp : NSString? = temp as? NSString
        if(strTemp != nil )
        {
            movieDetail.averageRate = strTemp!.doubleValue
        }
    }
    
    temp = data["commentlist"]
    
    if(temp != nil)
    {
        var commentList: [Dictionary<String, AnyObject>] = temp as! [Dictionary<String, AnyObject>]
        for ( var i : Int = 0 ; i < commentList.count ; i++ )
        {
            var commentItem : CommentDataItem = ParserCommentData(commentList[i])
            movieDetail.commentList.append(commentItem)
        }
    }
    return movieDetail
}

func ParserSetCommentRespData( data: Dictionary<String, AnyObject>) -> CommentRespDataItem
{
    var comment = CommentRespDataItem()
    var temp : AnyObject?
    
    temp = data["username"]
    if(temp != nil)
    {
        comment.comment.user = temp as! String
    }
    
    temp = data["comment"]
    if(temp != nil)
    {
        comment.comment.comment = temp as! String
    }
    
    temp = data["rate"]
    if(temp != nil)
    {
        var strTemp : NSString? = temp as? NSString
        if(strTemp != nil )
        {
            comment.comment.rate = strTemp!.doubleValue
        }
    }
    
    temp = data["averageRate"]
    if(temp != nil)
    {
        var strTemp : NSString? = temp as? NSString
        if(strTemp != nil )
        {
            comment.averageRate = strTemp!.doubleValue
        }
    }

    
    return comment
}


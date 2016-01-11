//
//  MovieDetailController.swift
//  MovieReview
//
//  Created by Nguyen Hanh on 7/7/15.
//  Copyright (c) 2015 MDI ASTEC VN CO., LTD. All rights reserved.
//


protocol MovieDetailViewProtocol: NFSingleView {
    
    func setMovieName(title: String)
    func SetMoviewView(url : String)
    func SetRateVal( val: Double? )
    func setDetailMovieInfo(detail:String)
    func getUser() -> String
    func getComment() -> String
    func getRate() -> Int
    func loadingCommentItem(index : Int) -> CommentTableViewCellProtocol!
    func setNumberOfComment( val:Int)
    func  SetProcessState(val : Bool)    
    
    func ShowAlert( title: String, message: String , retry: Bool)
    
    func ViewFinishLoading()
    
    func reloadData()
    func close()
}

protocol CommentTableViewCellProtocol: NFView {
    func setRate( val : Double)
    func setUsername( val: String )
    func setCmmt( val: String )
}


class MovieDetailController: CommonController {
    var movie : MovieDetailData = MovieDetailData()
    
    
    var detailMovieView: MovieDetailViewProtocol! { return view as! MovieDetailViewProtocol! }
    
    init( appController: ApplicationController, movieItem: MovieListDataItem) {
        self.movie.title = movieItem.title
        self.movie.averageRate = movieItem.averageRate
        self.movie.id = movieItem.id
        
        super.init(appController: appController)
    }
    func viewDidLoad()
    {
        
        detailMovieView?.setMovieName(self.movie.title)
        
        detailMovieView?.SetRateVal(self.movie.averageRate)
        
        
        detailMovieView?.SetProcessState(true)
        
        applicationController.server?.getMovieDetail(movie.id, handler:
            { [weak self] (data, error) -> Void in
                if let strongSelf = self
                {
                    if (error == nil)
                    {
                        strongSelf.movie = ParserDatataMovieDetail(data!)
                        strongSelf.detailMovieView?.SetProcessState(false)
                        strongSelf.LoadDabaBaseFinish()
                    }
                    else
                    {
                        /* show alert */
                        strongSelf.detailMovieView?.SetProcessState(false)
                        strongSelf.detailMovieView?.ShowAlert(error!, message: "Please check your connection or contact to administrator", retry: true)
                    }
                }
            })
    }
    
    private func LoadDabaBaseFinish ()
    {
        detailMovieView?.SetMoviewView(movie.trailer)
        
        detailMovieView?.setDetailMovieInfo( movie.detail )
        var numberOfComment = getNumOfComment()
        NSLog("number of comment: %d", numberOfComment)
        detailMovieView?.setNumberOfComment(numberOfComment)
        detailMovieView?.SetRateVal(movie.averageRate)
        detailMovieView?.reloadData()
    }
    
    func loadRowComment( index : Int )
    {
        var commentlist : [CommentDataItem] = movie.commentList
        var cmt : CommentTableViewCellProtocol? = detailMovieView?.loadingCommentItem( index )
        var numOfComment = commentlist.count
        if( index < numOfComment)
        {
            cmt?.setRate(commentlist[numOfComment - index - 1].rate)
            cmt?.setUsername(commentlist[numOfComment - index - 1].user)
            cmt?.setCmmt(commentlist[numOfComment - index - 1].comment)
        }
    }
    
    private func getNumOfComment() -> Int
    {
        return movie.commentList.count
    }
    
    private func getRating() -> Double
    {
        var rate : Double = Double(0);
        
        var cmtCount : Int = 0;
        
        
        var commentlist : [CommentDataItem]? = movie.commentList
        if(commentlist != nil )
        {
        
            cmtCount = commentlist!.count
        
            if( cmtCount != 0)
            {
                for item in commentlist!
                {
                    var itemRate = item.rate
                    rate = rate + Double(itemRate)
                }
            
                rate = rate/Double(cmtCount)
            }
            
        }
        
        return rate
        
    }
    func alertOption( option: Int ) -> Void
    {
        if(option == 0)
        {
            self.viewDidLoad()
        }
        else
        {
            detailMovieView?.close()
//            applicationController.listMovieController.detailMovieController = nil
        }
    }
    
    func submitComment()
    {
        let spaceSet = NSCharacterSet.whitespaceCharacterSet()
        
        var user : String = detailMovieView!.getUser().stringByTrimmingCharactersInSet(spaceSet)
        var comment : String = detailMovieView!.getComment().stringByTrimmingCharactersInSet(spaceSet)
        var rate = detailMovieView!.getRate()
        detailMovieView?.SetProcessState(true)
        
        if ((count(user) > 255))
        {
            self.detailMovieView?.ShowAlert("The length of username is more than 255 characters ", message: "", retry: false)
        }
        else if( (count(user) > 0) && ((count(comment) > 0) || rate != 0))
        {
            applicationController.server?.setComment(movie.id, user: user, comment: comment, rate: rate, handler:
                { [weak self] (data, error) -> Void in
                    if(self != nil)
                    {
                        if (error == nil)
                        {
                            var commentItem = ParserSetCommentRespData(data!)
                            self!.movie.commentList.append(commentItem.comment)
                            self!.movie.averageRate = commentItem.averageRate
                            self!.LoadDabaBaseFinish()
                        }
                        else
                        {
                            /* show alert */
                            self!.detailMovieView?.ShowAlert(error!, message: "Please check your connection or contact to administrator", retry: true)
                        }
                        self!.detailMovieView?.SetProcessState(false)
                    }
            })

        }
        else if( count(user) == 0)
        {
            self.detailMovieView?.ShowAlert("Please input your name ", message: "", retry: false)
        }
        else
        {
            self.detailMovieView?.ShowAlert("Please input comment or rate ", message: "", retry : false)
        }
        
    }
    
}
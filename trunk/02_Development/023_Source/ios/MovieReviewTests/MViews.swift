//
//  MViews.swift
//  MovieReviewApp
//
//  Created by Nguyen Duc Hiep on 7/1/15.
//  Copyright (c) 2015 Nguyen Hanh. All rights reserved.
//

import Foundation

class MApplicationView: NFMApplicationView, ApplicationViewProtocol
{
    var listMovieView: MListMovieView!
    
    func showListMovieView(controller: ListMovieController)
    {
        listMovieView = MListMovieView()
        controller.view = listMovieView
    }
}

class MListMovieView: NFMSingleView, ListMovieViewProtocol
{
    var searchText = ""
    var searching: Boolean = 0
    weak var parrents : MApplicationView!
    
    func setItemCount(count: Int)
    {
        if(count >= 0) {
            listMovieItemViews.removeAll(keepCapacity: true)
            for (var i = 0; i < count; i++) {
                listMovieItemViews.append(MListMovieItemView())
            }
        }
        else
        {
            listMovieItemViews.removeAll(keepCapacity: false)
        }
    }

    var listMovieItemViews = [MListMovieItemView]()
    func getItemView(index: Int) -> ListMovieItemViewProtocol?
    {
        return listMovieItemViews[index]
    }
    
    var detailMovieView: MDetailMovieView!
    func showDetailView(movie: MovieDetailController)
    {
        detailMovieView = MDetailMovieView()
        detailMovieView.parrents = self
        movie.view = detailMovieView
    }
   
    var alertType = ""
    var alertMsg = ""
    
    func ShowAlert( title: String, message: String )
    {
        alertType = title
        alertMsg = message
    }
    
}

class MListMovieItemView: NFMView, ListMovieItemViewProtocol
{
    var _title: String = ""
    var _rate: Double?
    var _poster: NSData!
    
    func setTitle(title: String) {
        _title = title
    }
    
    func setRate(val:Double?) {
        _rate = val
    }
    
    func setPoster(data: NSData!) {
        _poster = data
    }
}

class MDetailMovieView: NFMSingleView, MovieDetailViewProtocol, NFAlertableView
{
    var alertView: NFMAlertableView! = nil
    func alertWithTitle(title: String!, message: String!, selections: [AnyObject]!, completionHandler handler: ((Int) -> Void)!)
    {
        alertView = NFMAlertableView()
    }
    
    var trailer : String = ""
    var averageRate : Double?
    
    var detail : String = ""
    
    var inputRate: Int = 0
    var inputUser : String = ""
    var inputComment : String = ""
    
    
    var listCommentItemView = [MCommentItem]()
    var loadingState : Bool = false
    
    var alertTitle : String = ""
    var alertMsg : String = ""
    var movieTitle : String = ""
    
    weak var parrents : MListMovieView!
    
    func SetMoviewView(url : String)
    {
        trailer = url
    }
    
    func SetRateVal( val: Double? )
    {
        averageRate = val
    }
    
    func setDetailMovieInfo(detail:String)
    {
        self.detail = detail
    }
    
    
    func getUser() -> String
    {
        return inputUser
    }
    func getComment() -> String
    {
        return inputComment
    }
    func getRate() -> Int
    {
        return inputRate
    }
    
    func loadingCommentItem(index : Int) -> CommentTableViewCellProtocol!
    {
        return listCommentItemView[index]
    }
    
    func setNumberOfComment( val:Int)
    {
        
        if(val >= 0) {
            listCommentItemView.removeAll(keepCapacity: true)
            for (var i = 0; i < val; i++) {
                listCommentItemView.append(MCommentItem())
            }
        }
        else
        {
            listCommentItemView.removeAll(keepCapacity: false)
        }
        
    }
    
    func  SetProcessState(val : Bool)
    {
        loadingState = val
    }
   
    
    
    func ShowAlert( title: String, message: String, retry: Bool )
    {
        alertTitle = title
        alertMsg = message
    }
    
    func ViewFinishLoading()
    {
    }
    
    func reloadData()
    {
    
    }
    
    func setMovieName(title: String)
    {
        self.movieTitle = title
    }
    
    func backToListView()
    {
        
    }
    
    var title: NSString!
    var message : NSString!
    var selections : NSArray!
    
    func setSelection ( selection : NSString ) -> Void
    {
        if( selection == "Back")
        {
            
        }
        else if (selection == "Reload" )
        {
            
        }
    }
    func close()
    {
        parrents.detailMovieView = nil
    }
}

class MCommentItem : NFMView, CommentTableViewCellProtocol
{
    var rating: Double = 0
    var user: String = ""
    var comment : String = ""
    func setRate( val : Double)
    {
        rating = val
    }
    func setUsername( val: String )
    {
        user = val
    }
    func setCmmt( val: String )
    {
        comment = val
    }

}

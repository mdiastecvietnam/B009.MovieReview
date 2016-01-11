//
//  ListMovieController.swift
//  MovieReviewApp
//
//  Created by Nguyen Hanh on 6/29/15.
//  Copyright (c) 2015 Nguyen Hanh. All rights reserved.
//

import UIKit

protocol ListMovieViewProtocol : NFSingleView
{
    var searchText : String{ get }
    var searching: Boolean { get set }
    func setItemCount(count: Int)
    func showDetailView( movie : MovieDetailController)
    func getItemView(index: Int) -> ListMovieItemViewProtocol?
    func ShowAlert( title: String, message: String )
}

protocol ListMovieItemViewProtocol
{
    func setTitle(title: String)
    func setRate(val:Double?)
    func setPoster(data: NSData!)
}

class ListMovieController: CommonController {
    
    
    var listMovieData : [MovieListDataItem] = [MovieListDataItem]()
//    var ServerData = DataBaseParse(server: NFServer.sharedServer())
    
    var detailMovieController : MovieDetailController?
    
    var listMovieView: ListMovieViewProtocol! { return view as! ListMovieViewProtocol! }
    
    
    func viewDidLoad()
    {
       SearchMovie()
    }
    
    func textDidFinishEditing(){
        SearchMovie()
    }
    
    func saveMemory()
    {
        for (var i = 0; i < listMovieData.count; i++) {
            if (listMovieView.getItemView(i) == nil) {
                listMovieData[i].data = nil
            }
        }
    }
    
    func rowViewWillAppear(index: NSInteger)
    {
        if let rowView = listMovieView.getItemView( index ) {
            var count : Int = listMovieData.count
            if(count > index)
            {
                var movieItem : MovieListDataItem = listMovieData[index]
                if ( movieItem.data == nil )
                {
                    var URL = NSURL(string: movieItem.poster)
                    if (URL == nil)
                    {
                        movieItem.data = nil
                    }
                    else
                    {
                        applicationController.server?.realServer?.request(movieItem.poster, method: nil, paras: nil, completion: { [weak self, movieId = movieItem.id] (error, data) -> Void in
                            if let strongSelf = self {
                                var index = NSNotFound
                                for (var i = 0; i < strongSelf.listMovieData.count; i++) {
                                    if (strongSelf.listMovieData[i].id == movieId) {
                                        index = i
                                        break
                                    }
                                }
                                
                                if (error == nil && index != NSNotFound) {
                                    strongSelf.listMovieData[index].data = data
                                    strongSelf.listMovieView.getItemView(index)?.setPoster(data)
                                }
                            }
                        })
                    }
                }
                
                rowView.setTitle( movieItem.title )
                rowView.setRate(movieItem.averageRate)
                rowView.setPoster( movieItem.data)
            }
        }
    }
    
    func rowViewDidSelected(index: NSInteger) {
        if(index < listMovieData.count)
        {
            var sellectItem : MovieListDataItem = listMovieData[index]
//        var sellectId : Int = sellectItem["id"] as! Int
            detailMovieController = MovieDetailController(appController: self.applicationController, movieItem: sellectItem)
            listMovieView.showDetailView(detailMovieController!)
        }
    }

    
    /* server */
    func SearchMovie()
    {
        self.applicationController.server!.listMovie(listMovieView.searchText, handler: {
            [weak self] (data, error) -> Void in
            if( self != nil)
            {
                self!.reivewListProcess(data , err: error)
            }
        })
        listMovieView.searching = 1 /* searching */
    }
    
    func reivewListProcess(listMovie : [Dictionary<String, AnyObject>]?, err : String?)
    {
        if true// (self != nil )
        {
            if(err == nil)
            {
                
                var count : Int = 0
                if (listMovie != nil)
                {
                    count = listMovie!.count
                }
                listMovieData.removeAll(keepCapacity: false)
                for( var i : Int = 0; i < count ; i++)
                {
                    var item = ParserDatataMovieItem(listMovie![i])
                    listMovieData.append(item)
                }
                listMovieView.setItemCount(count)
                
            }
            else
            {
                listMovieView.setItemCount(-1)                
                listMovieData.removeAll(keepCapacity: false)
                listMovieView.setItemCount(0)
                var msg : String = ""
                if (err != "No results")
                {
                    msg = "Please check your connection or contact to administrator!"
                }
                listMovieView.ShowAlert(err!, message: msg)
            }
            listMovieView.searching = 0 /* release */
        }
    }


}

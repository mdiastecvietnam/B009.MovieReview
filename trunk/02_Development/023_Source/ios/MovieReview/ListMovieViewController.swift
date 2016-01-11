//
//  ListMovieViewController.swift
//  MovieReview
//
//  Created by Nguyen Hanh on 7/9/15.
//  Copyright (c) 2015 MDI ASTEC VN CO., LTD. All rights reserved.
//

import UIKit

class ListMovieViewController: NFTViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, ListMovieViewProtocol, NFAlertableView{
    
    @IBOutlet var movieList: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    
    var tableViewCellWillAppear: ListMovieTableViewCell!
    var procState : Boolean = 0
    //    var timer : NFTimer
    //
    //    required init(coder aDecoder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    var listMovieController: ListMovieController! { return controller as! ListMovieController! }
    
    /* ListMoviewProtocol */
    var searchText : String{
        get{
            return searchBar.text
        }
    }
    var noOfMovieList : Int = 0
    
    func setItemCount(count: Int)
    {
        self.noOfMovieList = count
    }
    
    func getItemView(index: Int) -> ListMovieItemViewProtocol?
    {
        return movieList.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as? ListMovieTableViewCell
    }
    
    func showDetailView(controler: MovieDetailController)
    {
        var detailMovieView = MovieDetailViewController(controller: controler)
        self.pushViewController(detailMovieView, animated: true)
    }
    
    
    var searching: Boolean {
        get{
            return procState
        }
        set(val){
            procState = val
            if(procState == 0)
            {
                movieList.reloadData()
                refresh.endRefreshing()
            }
            else
            {
                refresh.beginRefreshing()
            }
        }
    }
    func ShowAlert( title: String, message: String )
    {
        alertWithTitle(title, message: message , selections: ["OK"], completionHandler: nil)
    }
    var refresh : UIRefreshControl!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        view.addConstraint(NSLayoutConstraint(item: topLayoutGuide, attribute: .Bottom, relatedBy: .Equal, toItem: searchBar, attribute: .Top, multiplier: 1, constant: 0))
        refresh = UIRefreshControl()
        refresh.addTarget(self, action: "handlerRefresh", forControlEvents: UIControlEvents.ValueChanged)
        movieList.insertSubview(refresh, atIndex: 0)
        
        self.title = "List Movie"
        
        movieList.registerNib(UINib(nibName: "ListMovieTableViewCell", bundle: nil), forCellReuseIdentifier: "cellID")
        self.listMovieController.viewDidLoad()
    }
    
    func handlerRefresh()
    {
        self.listMovieController.viewDidLoad()
        if(refresh != nil)
        {
            refresh?.endRefreshing()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if( procState != 1)
        {
            self.listMovieController.viewDidLoad()
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        listMovieController.saveMemory()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if(procState != 1 )
        {
            searchBar.resignFirstResponder()
            listMovieController.textDidFinishEditing()
        }
    }
//    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
//        if(procState != 1 )
//        {
//            searchBar.resignFirstResponder()
//            listMovieController.textDidFinishEditing()
//        }
//    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if((searchBar.text == "") && (procState != 1 ) )
        {
            listMovieController.textDidFinishEditing()
        }
        
   }
//    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
//        if(procState != 1 )
//        {
//            searchBar.resignFirstResponder()
//            listMovieController.textDidFinishEditing()
//        }
//        return true
//    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88;
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return noOfMovieList
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        NSOperationQueue.currentQueue()?.addOperationWithBlock({ [weak self, indexPath] in
            if let strongSelf = self {
                strongSelf.listMovieController.rowViewWillAppear(indexPath.row)
            }
        })
        return movieList.dequeueReusableCellWithIdentifier("cellID", forIndexPath: indexPath) as! UITableViewCell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        listMovieController.rowViewDidSelected(indexPath.row)
    }
}

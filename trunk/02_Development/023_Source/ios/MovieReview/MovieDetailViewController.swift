//
//  MovieDetailViewController.swift
//  MovieReview
//
//  Created by Nguyen Hanh on 7/6/15.
//  Copyright (c) 2015 MDI ASTEC VN CO., LTD. All rights reserved.
//

import UIKit
import MediaPlayer

class MovieDetailViewController: NFTViewController, MovieDetailViewProtocol, UITableViewDataSource, UITableViewDelegate, NFAlertableView, RatingViewDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var trailer: UIView!
    
    @IBOutlet weak var rate: RatingView!
    
    @IBOutlet weak var detailMovieTableView: UITableView!
    
    @IBOutlet var descriptionTableViewCell: UITableViewCell!
    
    @IBOutlet weak var descriptionWebView: UIWebView!
    
//    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet var addCommentTableViewCell: UITableViewCell!
    
    @IBOutlet weak var commentView: UIView!
    
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var usernameTextFeild: UITextField!
    
    @IBOutlet weak var commentTextFeild: UITextField!
    
    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var descriptImage: UIImageView!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var inputRating: RatingView!
    
    var expandDescript : Bool = false
    @IBAction func touchUpDescription(sender: AnyObject) {
        expandDescript = !expandDescript
        if (expandDescript == true)
        {
            descriptImage.image = UIImage(named: "arrow_up")
        }
        else
        {
            descriptImage.image = UIImage(named:"expand_more")
        }
        
        detailMovieTableView.reloadData()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if(textField == self.usernameTextFeild)
        {
            commentTextFeild.becomeFirstResponder()
        }
    }
    
    @IBAction func touchUpSubmitComment(sender: AnyObject) {
        detailMovieController.submitComment()
    }
    
    
    @IBAction func editTextBegin(sender: AnyObject) {
        
        detailMovieTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
        
        var contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 180, right: 0)
        detailMovieTableView.contentInset = contentInsets
        detailMovieTableView.scrollIndicatorInsets = contentInsets
        
        
        var frame : CGRect = detailMovieTableView.convertRect(commentTextFeild.bounds, fromView: commentTextFeild)
        detailMovieTableView.scrollRectToVisible(frame, animated: true)
        
    }
    
    
    @IBAction func editTextBeginUser(sender: AnyObject) {
        
        detailMovieTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1), atScrollPosition:UITableViewScrollPosition.Top, animated: false)
        
        var contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: 250, right: 0)
        detailMovieTableView.contentInset = contentInsets
        detailMovieTableView.scrollIndicatorInsets = contentInsets
        
        
        var frame : CGRect = detailMovieTableView.convertRect(commentTextFeild.bounds, fromView: usernameTextFeild)
        detailMovieTableView.scrollRectToVisible(frame, animated: true)
        
    }
    
    var expandComment : Bool = false
    @IBAction func touchUpComment(sender: AnyObject) {
        expandComment = !expandComment
        if (expandComment == true)
        {
            commentImage.image = UIImage(named: "arrow_up")
        }
        else
        {
            commentImage.image = UIImage(named:"expand_more")
        }
//        detailMovieTableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.None)
        detailMovieTableView.reloadData()
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField == usernameTextFeild)
        {
           self.commentTextFeild.becomeFirstResponder()
        }
        else
        {
            self.submitBtn.becomeFirstResponder()
            
        }
        return true
    }
    
    var moviePlayer:MPMoviePlayerController!
    
    var detailMovieController: MovieDetailController! { return controller as! MovieDetailController! }
    
    func movieEventPlaybackHandler( notification: NSNotification)
    {
        self.dismissMoviePlayerViewControllerAnimated()
        var movie : MPMoviePlayerViewController? = notification.object as? MPMoviePlayerViewController
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: MPMoviePlayerPlaybackDidFinishNotification, object: movie)
        
//        moviePlayer.setFullscreen(false, animated: false)
        moviePlayer.view.removeFromSuperview()
        SetMoviewView(detailMovieController.movie.trailer)
        moviePlayer.setFullscreen(true, animated: false)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        detailMovieController?.viewDidLoad()
        descriptionWebView.scrollView.scrollEnabled = false;
        
        inputRating.delegate = self
        inputRating.editable = true
        
        
        commentImage.image = UIImage(named:"expand_more")
        descriptImage.image = UIImage(named:"expand_more")
        
        var frame : CGRect = descriptionWebView.frame;
        frame.size.height = 1;
        descriptionWebView.frame = frame;
        var fittingSize : CGSize = descriptionWebView.sizeThatFits(CGSizeZero)
        
        frame.size = fittingSize
        descriptionWebView.frame = frame;
        
        detailMovieTableView.registerNib(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "commentItem")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "movieEventPlaybackHandler:", name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)
    }
    
    func rateChanged (ratingView : RatingView)
    {
        var val = ratingView.value
        NSLog(" rating val: %f", val)
    }
    
     /* UITableViewDataSource */
    
    var numOfComment : Int = 0
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(section == 0)
        {
            return 1
        }
        else if (section == 1)
        {
            return 1
        }
        else if ( section == 2)
        {
            return (numOfComment + 10)
        }
        else
        {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.section == 0)
        {
            
            var frame : CGRect = descriptionWebView.frame;
            var ret : CGFloat
            
            if(expandDescript == true)
            {
                descriptionWebView.hidden = false
                ret = 40 + descriptionWebView.frame.size.height
            
            }
            else
            {
                descriptionWebView.hidden = true
                ret = 40
            }
            
            descriptionTableViewCell.frame.size.height = ret
            return ret
            
        }
        else if(indexPath.section == 1 && indexPath.row == 0)
        {
            if(expandComment == true)
            {
//                commentView.hidden = false
                return 160
            }
            else
            {
//                commentView.hidden = true
                return 40
            }
        }
        else if(indexPath.section == 2)
        {
            if(indexPath.row < numOfComment)
            {
                var temp:UITextView = UITextView()
                temp.text = detailMovieController.movie.commentList[numOfComment - indexPath.row - 1].comment
                temp.font = UIFont(name: "System",  size: 13)
                var fitSize = temp.sizeThatFits(CGSize(width: detailMovieTableView.frame.width, height: CGFloat.max))
                var textheigh = fitSize.height
            
                var heigth  = 55 + textheigh
                return CGFloat(heigth)
            }
            else
            {
                return 65
            }
        }
        else
        {
            return 0
        }
    }

    var commentItem : CommentTableViewCell?
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if( indexPath.section == 0)
        {
            var cell = detailMovieTableView.dequeueReusableCellWithIdentifier("Description") as! UITableViewCell!
            if (cell == nil) {
                cell = descriptionTableViewCell
            }
            var frame : CGRect = descriptionWebView.frame;
            frame.size.height = 1;
            descriptionWebView.frame = frame;
            var fittingSize : CGSize = descriptionWebView.sizeThatFits(CGSizeZero)
            
            frame.size = fittingSize
            descriptionWebView.frame = frame;
            
            cell.frame.size.height = 50 + frame.size.height
            
            return cell
        }
        else if( indexPath.section == 1)
        {
            
            var cell = detailMovieTableView.dequeueReusableCellWithIdentifier("addComment") as! UITableViewCell!
            if( cell == nil)
            {
                cell = addCommentTableViewCell
            }
            
            return cell
        }
        else if( indexPath.section == 2)
        {
            if(indexPath.row < numOfComment)
            {
                let cell = detailMovieTableView.dequeueReusableCellWithIdentifier("commentItem") as! UITableViewCell!
                commentItem = cell as? CommentTableViewCell
                detailMovieController.loadRowComment(indexPath.row)
                return commentItem!
            }
            else
            {
                var cell = UITableViewCell()
                return cell
            }
        }
        else
        {
            var cell = detailMovieTableView.dequeueReusableCellWithIdentifier("none") as! UITableViewCell!
            return cell!
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 3
    }
    
    
    /* DetailMovieViewProtocol */
    
    func setMovieName(title: String)
    {
        self.title = title
    }
    func reloadData()
    {
        
        inputRating.value = 0
        usernameTextFeild.text = ""
        commentTextFeild.text = ""

        detailMovieTableView.reloadData()
        
    }
    
    var loadingState : Bool  = false/* false : none / true: loading */
    func SetProcessState(val : Bool)
    {
        loadingState = val
    }
    
    func ViewFinishLoading()
    {
        super.viewDidLoad()
    }
    
    func ShowAlert( title: String, message: String  , retry: Bool)
    {
        if( retry == true )
        {
            alertWithTitle(title, message: message , selections: ["Reload", "Back"], completionHandler: {
                (arg) -> Void in
                self.detailMovieController.alertOption(arg)
            })
        }
        else
        {
            alertWithTitle(title, message: message, selections: ["OK"], completionHandler: nil)
        }
        
    }
    
    func close()
    {
        self.popViewControllerAnimated(true)
    }

    func SetMoviewView(url : String)
    {
        var url:NSURL? = NSURL(string: url)
        
        if( url != nil )
        {
            
            moviePlayer = MPMoviePlayerController(contentURL: url)
            
            moviePlayer.view.frame = trailer.frame
            
            moviePlayer.controlStyle = .None
            
            moviePlayer.fullscreen = true
            
            moviePlayer.controlStyle = MPMovieControlStyle.Embedded
            
            moviePlayer.shouldAutoplay = true;
            moviePlayer.prepareToPlay()
            
            moviePlayer.play()
           
//            moviePlayer.controlStyle = MPMovieControlStyle.None
            
            
//            moviePlayer.addObserver(self, forKeyPath: <#String#>, options: <#NSKeyValueObservingOptions#>, context: <#UnsafeMutablePointer<Void>#>)
            
            moviePlayer.scalingMode = MPMovieScalingMode.AspectFill
        
            
            
            
            trailer.addSubview(moviePlayer.view)
            
            
        }
    }
    
    func SetRateVal(val: Double? )
    {
        if( val != nil )
        {
            rate.value = CGFloat(val!)
        }
        else
        {
            rate.hidden = true
        }

    }
    
    func setDetailMovieInfo(detail:String)
    {
        descriptionWebView.loadHTMLString(detail, baseURL: nil)
    }
    
    func loadingCommentItem(index : Int) -> CommentTableViewCellProtocol!
    {
        return commentItem
    }
    
    
    func setNumberOfComment( val:Int)
    {
        numOfComment = val
        
        detailMovieTableView.reloadData()
        
    }
    
    func getUser() -> String
    {
        return usernameTextFeild.text
    }
    func getComment() -> String
    {
        return commentTextFeild.text
    }
    func getRate() -> Int
    {
        return Int(inputRating.value)
    }

}


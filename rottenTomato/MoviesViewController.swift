//
//  MoviesViewController.swift
//  rottenTomato
//
//  Created by Shuhui Qu on 4/8/15.
//  Copyright (c) 2015 Shuhui Qu. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate {

    var movies: [NSDictionary]! = [NSDictionary]()
//    var searchedMovies: [NSDictionary]! = [NSDictionary]()
    
    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var networkErrorView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        var url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=jkrcmcm42ds9aymcm6ehfw9z")!
        var request = NSURLRequest(URL: url)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0);
        
        SVProgressHUD.showWithStatus("I am loading")
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),{
            // time-consuming task
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()){
                (response: NSURLResponse!, data: NSData!, error: NSError!)->Void in
                if((error) != nil){
                    self.networkErrorView.hidden = false
                    NSLog("Connection Error")
                    return
                }
                var json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                self.networkErrorView.hidden = true
                self.movies = json["movies"] as [NSDictionary]
                self.tableView.reloadData()
                NSLog("got the response back: %@", self.movies)
            }
            dispatch_async(dispatch_get_main_queue(),{
                SVProgressHUD.dismiss();
                });
            });
        
        
        tableView.delegate = self
        tableView.dataSource = self
        movieSearchBar.delegate = self
        // Do any additional setup after loading the view.
    }

    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        delay(2, closure: {
            self.refreshControl.endRefreshing()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //var cell = UITableViewCell() need recycling
        var cell = tableView.dequeueReusableCellWithIdentifier("My Movie Cell", forIndexPath: indexPath) as MovieCell
        
        var movie = movies[indexPath.row]
        
        cell.titleLabel.text = movie["title"]as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        
        
        var url = movie.valueForKeyPath("posters.thumbnail") as? String
        cell.posterView.setImageWithURL(NSURL(string: url!)!)
        
//        cell.textLabel.text = "Hello, \(indexPath.row)"
        NSLog("cell: %d", indexPath.row)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSLog("Navigating")
        var movieDetailViewController = segue.destinationViewController as MovieDetailViewController
        
        //sender is cell
        var cell = sender as UITableViewCell
        var indexPath = tableView.indexPathForCell(cell)!
        movieDetailViewController.movie = movies[indexPath.row]
        
        
    }
    func requestQuery(request:NSURLRequest){
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()){
            (response: NSURLResponse!, data: NSData!, error: NSError!)->Void in
            if((error) != nil){
                self.networkErrorView.hidden = false
                NSLog("Connection Error")
                return
            }
            var json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
            self.networkErrorView.hidden = true
            self.movies = json["movies"] as [NSDictionary]
            self.tableView.reloadData()
            NSLog("got the response back: %@", self.movies)
        }
    }

    func searchMovies(query: String){
        var escapedQuery = query.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        var url = "http://api.rottentomatoes.com/api/public/v1.0/movies.json?q=\(escapedQuery!)&page_limit=20&apikey=jkrcmcm42ds9aymcm6ehfw9z"
        requestQuery(NSURLRequest(URL: NSURL(string: url)!))
    }
    func searchBar(searchBar: UISearchBar!, textDidChange searchText: String!) {
        NSLog(searchText)
        if (searchText == ""){
            var url = NSURL(string: "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=jkrcmcm42ds9aymcm6ehfw9z")!
            var request = NSURLRequest(URL: url)
            requestQuery(request)
        }else{
            searchMovies(searchText)
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.tableView.reloadData()
        self.view.endEditing(true)
    }

}

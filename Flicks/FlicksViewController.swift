//
//  ViewController.swift
//  Flicks
//
//  Created by Julia Yu on 2/15/16.
//  Copyright © 2016 Julia Yu. All rights reserved.
//

import UIKit
import MBProgressHUD

//private let APIKEY = "229cf9c285d7dcc65abd26a73d9fa804"
//private let NOW_PLAYING = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(APIKEY)"
//private let TOP_RATED = "https://api.themoviedb.org/3/movie/top_rated?api_key=\(APIKEY)"

class FlicksViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorPanel: UIView!
    
    var movies:[Movie]?
    var endpoint: String?
    var searchBar: UISearchBar!
    
    let refreshControl = UIRefreshControl()
    
    func loadData() {
        
        print(self.endpoint)
    
        let url = NSURL(string:self.endpoint!)
        let request = NSURLRequest(URL: url!)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                            self.errorPanel.hidden = true
                            
                            if let results = responseDictionary["results"] as? NSArray {
                                var movies: [Movie] = []
                                for oneMovie in results as! [NSDictionary] {
                                    movies.append(Movie(data: oneMovie))
                                }
                                
                                self.movies = movies
                            }
                            
                            self.refreshControl.endRefreshing()
                            self.tableView.reloadData()
                    }
                }
                
                if let error = error {
                    print(error)
                    self.refreshControl.endRefreshing()
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    self.errorPanel.hidden = false
                }
        });
        task.resume()
    }
    
    func refresh(refreshControl: UIRefreshControl) {
        self.loadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 130
        self.errorPanel.hidden = true
//        self.endpoint = NOW_PLAYING 
        
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.insertSubview(self.refreshControl, atIndex: 0)
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()
        self.navigationItem.titleView = searchBar
        
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailSegue" {
            let vc = segue.destinationViewController as? FlicksDetailViewController
            
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        
            if let movies = self.movies {
                let movie = movies[indexPath!.row]
                if let destination = vc {
                    destination.detailData = movie
                }
            }
        }
    }
    
    @IBAction func onSegmentChange(sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        
    }
}

extension FlicksViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = self.movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FlicksCell") as! FlicksTableViewCell
        
        if let movies = self.movies {
            cell.cellData = movies[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
       
    }
}

extension FlicksViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//        searchSettings.searchString = searchBar.text
        searchBar.resignFirstResponder()
        print("searching for", searchBar.text)
//        doSearch()
    }
}
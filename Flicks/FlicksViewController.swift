//
//  ViewController.swift
//  Flicks
//
//  Created by Julia Yu on 2/15/16.
//  Copyright © 2016 Julia Yu. All rights reserved.
//

import UIKit
import MBProgressHUD

class FlicksViewController: UIViewController, UITableViewDataSource, UICollectionViewDataSource {
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorPanel: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies:[Movie]?
    var allMovies: [Movie]?
    var endpoint: String?
    var searchBar: UISearchBar!
    var previousSearch = ""

    let refreshControl = UIRefreshControl()
    
    //-------------------------------------------- reload colleciton or table view data whichever is visible
    
    func reloadAllData() {
        if !self.tableView.hidden {
            self.tableView.reloadData()
        }
        if !self.collectionView.hidden {
            self.collectionView.reloadData()
        }
    }
    
    //-------------------------------------------- filter the Movies data
    
    func searchData(searchTerm: String?) {
        if let term = searchTerm {
            
            if term == previousSearch {
                return
            }
            
            if term == "" {
                self.movies = self.allMovies // restore to original response
            } else {
                self.movies = self.allMovies
                
                self.movies = self.movies?.filter({
                    $0.title?.lowercaseString.rangeOfString(term.lowercaseString) != nil
                })
                
                previousSearch = term
            }
            
            reloadAllData()
        }
    }
    
    //-------------------------------------------- load the Movies data
    
    func loadData() {
        
        print("loading data from ", self.endpoint!)
    
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
                                
                                self.allMovies = movies
                                self.movies = movies
                                self.searchData(self.previousSearch)
                            }
                            
                            self.refreshControl.endRefreshing()
                            
                            self.reloadAllData()
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
    
    //-------------------------------------------- pull to refresh load data
    
    func refresh(refreshControl: UIRefreshControl) {
        self.loadData()
    }

    //-------------------------------------------- view did load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 130
        
        self.collectionView.dataSource = self
        self.tableView.delegate = self
        
        self.errorPanel.hidden = true
        
        refreshControl.tintColor = UIColor.whiteColor()
        refreshControl.backgroundColor = UIColor.blackColor()

        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
//        self.tableView.insertSubview(self.refreshControl, atIndex: 0)
        self.tableView.addSubview(self.refreshControl)
        
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.sizeToFit()

        self.navigationItem.titleView = searchBar

        self.navigationController?.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.tableView.hidden = false
        self.collectionView.hidden = true
        self.segmentControl.selectedSegmentIndex = 0
        
        loadData()
    }

    //-------------------------------------------- prepare for segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "tableDetailSegue" {
            let vc = segue.destinationViewController as? FlicksDetailViewController
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
        
            if let movies = self.movies {
                let movie = movies[indexPath!.row]
                if let destination = vc {
                    destination.detailData = movie
                }
            }
        }
        
        if segue.identifier == "collectionDetailSegue" {
            let vc = segue.destinationViewController as? FlicksDetailViewController
            let indexPath = collectionView.indexPathForCell(sender as! UICollectionViewCell)
            
            if let movies = self.movies {
                let movie = movies[indexPath!.row]
                if let destination = vc {
                    destination.detailData = movie
                }
            }
        }
    }
    
    //-------------------------------------------- toggle between grid and list view
    
    @IBAction func onSegmentChange(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            tableView.hidden = false
            collectionView.hidden = true
            self.tableView.reloadData()
        }
        if sender.selectedSegmentIndex == 1 {
            tableView.hidden = true
            collectionView.hidden = false
            self.collectionView.reloadData()
        }
        
    }
}


// Table view delegate methods

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

// collection view delegate methods

extension FlicksViewController: UICollectionViewDelegate {
    
    //-------------------------------------------- return length of collection
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = self.movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    //-------------------------------------------- return reusable cell of collection
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FlicksCollectionCell", forIndexPath: indexPath) as! FlicksCollectionViewCell
        
        if let movies = self.movies {
            cell.cellData = movies[indexPath.row]
        }
        
        return cell
    }
}


// Search bar delegate methods

extension FlicksViewController: UISearchBarDelegate {
    
    //-------------------------------------------- search begin
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }
    
    //-------------------------------------------- search end
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }
    
    //-------------------------------------------- search cancel
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    //-------------------------------------------- search
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.searchData(searchBar.text)
    }
    
    //-------------------------------------------- searc text change
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchData(searchBar.text)
    }
}
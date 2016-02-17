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
    var endpoint: String?
    var searchBar: UISearchBar!
    
    let refreshControl = UIRefreshControl()
    
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
                                
                                self.movies = movies
                            }
                            
                            self.refreshControl.endRefreshing()
                            self.tableView.reloadData()
                            self.collectionView.reloadData()
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
        
        self.collectionView.dataSource = self
        self.tableView.delegate = self
        
        self.errorPanel.hidden = true

        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.insertSubview(self.refreshControl, atIndex: 0)
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    
    @IBAction func onSegmentChange(sender: UISegmentedControl) {

        if sender.selectedSegmentIndex == 0 {
            tableView.hidden = false
            collectionView.hidden = true
        }
        if sender.selectedSegmentIndex == 1 {
            tableView.hidden = true
            collectionView.hidden = false
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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let movies = self.movies {
            return movies.count
        } else {
            return 0
        }
    }
    
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
//
//  AllShowsTableView.swift
//  Pursuit-Core-iOS-Episodes-from-Online
//
//  Created by Phoenix McKnight on 9/10/19.
//  Copyright © 2019 Benjamin Stone. All rights reserved.
//

import Foundation
import UIKit

class ShowViewController:UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
   
    @IBOutlet weak var searchBarOutlet: UISearchBar!
    
    @IBOutlet weak var allShowsTableView: UITableView!
    
    
   
    
    var ShowList = [ShowWrapper]() {
        didSet {
            self.allShowsTableView.reloadData()
        }
    }
    var userSearchTerm: String? {
        didSet {
            self.allShowsTableView.reloadData()
        }
    }
    var filteredShow: [ShowWrapper]  {
        guard let userSearchTerm = userSearchTerm else {
            return ShowList
        }
        guard userSearchTerm != "" else {
            return ShowList
        }
        return ShowList
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.userSearchTerm = searchText
        getShows(name: searchText)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func getShows(name:String?) {
        AllShowsAPIHelper.shared.getShow(name:name) { (results) in
            DispatchQueue.main.async {
                
                
                switch results {
                case .success(let showsFromOnline):
                    self.ShowList = showsFromOnline
                case .failure(let error) :
                    print(error)
                }
            }
        }
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUP()
    }
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let show = filteredShow[indexPath.row]
        if let cell = allShowsTableView.dequeueReusableCell(withIdentifier: "allShows") as? AllShowsTableViewCell {
           
            cell.activityStatusON()
         cell.allShowsLabel.text = show.show.name
            
            if let unWrappedImage = show.show.image {
          ImageHelper.shared.fetchImage(urlImage: unWrappedImage.original) {
                    (results) in
                    switch results {
                    case .failure(let error):
                        print(error)
                       
                        
                        
                    case .success(let filteredShow):
                        DispatchQueue.main.async {
                          usleep(5000)
                            cell.activityStatusOFF()
                            cell.allshowsImageView.image = filteredShow
                        }
                    }
                }
            } else {
                cell.activityStatusOFF()
                cell.allshowsImageView.image = UIImage(named: "imageLoadError")
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    func setUP() {
        allShowsTableView.dataSource = self
        allShowsTableView.delegate = self
        searchBarOutlet.delegate = self
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = storyboard?.instantiateViewController(withIdentifier: "ShowsInSeasonTableView") as! ShowsInSeasonTableView

        
            storyBoard.passingInfo = filteredShow[indexPath.row].show
        
    
        navigationController?.pushViewController(storyBoard, animated: true)
    }
    
}

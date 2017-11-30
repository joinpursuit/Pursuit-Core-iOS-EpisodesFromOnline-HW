//
//  EpisodeDetailViewController.swift
//  AC-iOS-EpisodesFromOnline-HW
//
//  Created by Reiaz Gafar on 11/29/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class EpisodeDetailViewController: UIViewController {

    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var episodeTitleLabel: UILabel!
    @IBOutlet weak var episodeSeasonLabel: UILabel!
    @IBOutlet weak var episodeNumberLabel: UILabel!
    @IBOutlet weak var episodeAirdateLabel: UILabel!
    @IBOutlet weak var episodeSummaryLabel: UITextView!
    
    var episode: Episode?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let episode = episode else { return }
        
        episodeImageView.image = nil
        episodeTitleLabel.text = episode.name
        episodeSeasonLabel.text = "Season: \(episode.season ?? 0)"
        episodeNumberLabel.text = "Episode: \(episode.number ?? 0)"
        episodeAirdateLabel.text = "Airdate: " + (episode.airdate ?? "No information available.")
        episodeSummaryLabel.text = episode.summary ?? "No information available."
        
        if let imageURL = episode.image?.original {
            let completion: (UIImage) -> Void = { (onlineImage: UIImage) in
                self.episodeImageView.image = onlineImage
            }
            ImageAPIClient.manager.getImage(from: imageURL, completionHandler: completion, errorHandler: { print($0) })
            if episodeImageView.image == nil {
                episodeImageView.image = #imageLiteral(resourceName: "no-image-icon")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

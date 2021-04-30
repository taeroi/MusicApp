//
//  ViewController.swift
//  TutorialMusicApp
//
//  Created by 태로고침 on 2021/04/29.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var tarckNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBOutlet weak var playerBlurView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}


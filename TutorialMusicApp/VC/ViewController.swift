//
//  ViewController.swift
//  TutorialMusicApp
//
//  Created by 태로고침 on 2021/04/29.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    //MARK: Components
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var tarckNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBOutlet weak var playerBlurView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    
    var topTrack = [TopTrack]()
    var audioPlayer: AVPlayer?
    var timer: Timer!
    var sectionHeaders = ["Top Music","Hindi","English","Tamil","Punjabi"]
    var tracks = [Tracks]()
    var isPlaying = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //MARK: Private Func
    private func loadJSON(){
        let path = Bundle.main.url(forResource: "music", withExtension: "json")
        do{
            let jsonData = try Data(contentsOf: path!,options: Data.ReadingOptions.mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: AnyObject]
            let items = jsonResult?["tracks"] as! NSArray
            for k in 0..<sectionHeaders.count{
                let otk = Tracks()
                otk.headerTitle = sectionHeaders[k]
                
                for i in items {
                    let data = i as? [String:AnyObject]
                    let object = TopTrack()
                    object.previewURL = data?["preview_url"] as? String
                    object.trackName = data?["name"] as? String
                    
                    let artists = data?["artists"] as? NSArray
                    object.artistName = (artists?.firstObject as? [String:AnyObject])?["name"] as? String
                    
                    let albums = data?["album"] as? [String:AnyObject]
                    let artWorkArray = albums?["images"] as! NSArray
                    let trackArtWork = artWorkArray.firstObject as! NSDictionary
                    object.artWork = trackArtWork.value(forKey: "url") as? String
                    
                    self.topTrack.append(object)
                }
                otk.tracks = self.topTrack
                self.tracks.append(otk)
                self.topTrack.removeAll()
            }
            self.tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: Layout
    private func customNavbar() {
        self.title = "Music Paly"
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .red
        
        let searchButton = UIBarButtonItem(image: UIImage(named: "search"), style: .done, target: self, action: nil)
        let menuButton =  UIBarButtonItem(image: UIImage(named: "menu"), style: .done, target: self, action: nil)
        
        self.navigationItem.leftBarButtonItem = menuButton
        self.navigationItem.rightBarButtonItem = searchButton

    }

}


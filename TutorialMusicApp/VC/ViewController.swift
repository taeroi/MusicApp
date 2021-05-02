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
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var trackPlayerView: UIView!
    @IBOutlet weak var playerBlurView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var durationLabel: UILabel!
    
    var topTrack = [TopTrack]()
    var tracks = [Tracks]()

    var audioPlayer: AVPlayer?
    var timer: Timer!
    var sectionHeaders = ["Top Music", "Hindi", "English", "Tamil", "Punjabi"]
    var isPlaying = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
        customNavbar()
        addBlurToPlayer()

    }

    //MARK: Private Func
    
    private func initialSetup(){
        let nib = UINib(nibName: "MusicCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        trackPlayerView.isHidden = true
        loadJSON()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
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
    
    @IBAction func pressedPlayPauseBtn(_ sender: UIButton) {
        if !isPlaying {
            isPlaying = true
            audioPlayer?.play()
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            isPlaying = false
            audioPlayer?.pause()
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
        }
    }
}

//MARK: Layout
extension ViewController {
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
    
    private func addBlurToPlayer(){
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = playerBlurView.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        playerBlurView.addSubview(blurView)
    }
    
    private func playTrack(track: TopTrack){
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: playerBlurView.frame.height, right: 0)
        trackPlayerView.isHidden = false
        let musicURL = URL(string: track.previewURL!)
        
        self.audioPlayer = AVPlayer(url: musicURL!)
        self.audioPlayer?.play()
        
        playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateProgressBar), userInfo: nil, repeats: true)
        trackNameLabel.text = track.trackName!
        artistNameLabel.text = track.artistName!
    }
    
    @objc func updateProgressBar(){
        let t1 = self.audioPlayer?.currentTime()
        let t2 = self.audioPlayer?.currentItem?.asset.duration
        
        let current = CMTimeGetSeconds(t1 ?? CMTime())
        let total = CMTimeGetSeconds(t2 ?? CMTime())
        
        if Int(current) != Int(total){
            let min = Int(current) / 60
            let sec = Int(current) % 60
            
            durationLabel.text = String(format: "%02d: %02d", min, sec)
            let percent = current/total
            
            self.progressView.setProgress(Float(percent), animated: true)
        } else {
            audioPlayer?.pause()
            audioPlayer = nil
            timer.invalidate()
            timer = nil
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, MusicCellProtocol {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? MusicCell else { return UITableViewCell()}
        if indexPath.row == 0 {
            cell._backgroundView.backgroundColor = .red
            cell.sectionHeaderLabel.textColor = .white
            cell.sectionHeaderLabel.text = sectionHeaders[0]
        } else {
            cell.sectionHeaderLabel.text = sectionHeaders[indexPath.row]
            cell._backgroundView.backgroundColor = .white
            cell.sectionHeaderLabel.textColor = .black
        }
        
        let obj = self.tracks[indexPath.row]
        cell.setCollectionViewDataSorceDelegate(index: indexPath, tracks: obj.tracks!)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 245
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    func didTapOnTrack(cell: MusicCell, indexPath: IndexPath) {
        let k = tableView.indexPath(for: cell)
        
        playTrack(track: self.tracks[k!.row].tracks![indexPath.row])
    }
    
    
    
}

//
//  PlayerViewController.swift
//  PLMusic
//
//  Created by 連振甫 on 2021/7/29.
//

import AVKit

class PlayerViewController: UIViewController {

    //MARK: - IBOutlet
    @IBOutlet var artistImageView: [UIImageView]!
    @IBOutlet weak var songLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var minTimeLabel: UILabel!
    @IBOutlet weak var maxTimeLabel: UILabel!
    @IBOutlet weak var percentSlider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var sliderTrack: NSLayoutConstraint!
    @IBOutlet weak var sliderTrackView: UIView!
    @IBOutlet weak var playlistButton: UIImageView!
    @IBOutlet weak var playListView: UIView!
    @IBOutlet weak var playListBlurView: UIVisualEffectView!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var repeatImage: UIImageView!
    @IBOutlet weak var randomButton: UIButton!
    @IBOutlet weak var randomImage: UIImageView!
    
    //MARK: - Property
    var isOpenPlayList = false
    var playListVC: PlayListViewController!
    var sliderTrackLayer = CAGradientLayer()
    var musicData:[Music] = []
    var selectItem = 0
    let manager = PaulPlayerManager.shared
    var status: PlayState = .pause
    var rule: PlayRule = .loop
    
    //MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupBackground()
        setupSlider()
        repeatButton.backgroundColor = UIColor(named: "SelectRule")
        randomButton.backgroundColor = .clear
        artistImageView.forEach({ $0.layer.cornerRadius = $0.frame.width * 0.2})
        manager.setupRemoteTransportControls()
        DataManager.shared.fetchMusic(completeHandler: {[weak self] data in
            
            guard let self = self else { return }
            
            guard data.count > 0 else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "錯誤", message: "音樂清單無資料", preferredStyle: .alert)
                    let check = UIAlertAction(title: "確定", style: .default, handler: nil)
                    alert.addAction(check)
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            
            self.musicData = data
            DispatchQueue.main.async {
                self.playListVC.musicData = self.musicData
                self.playListVC.tableView.reloadData()
                self.selectData(index: 0)
            }
        })
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playlist",
           let playListVC = segue.destination as? PlayListViewController {
            self.playListVC = playListVC
            self.playListVC.playerViewController = self
        }
    }
    
    
    //MARK: - IBAction
    
    @IBAction func repeatAction(_ sender: UIButton) {
        if rule == .loop {
            rule = .single
            repeatImage.image = UIImage(named: "repeat1")
        }else{
            rule = .loop
            repeatImage.image = UIImage(named: "repeat")
        }
        repeatButton.backgroundColor = UIColor(named: "SelectRule")
        randomButton.backgroundColor = .clear
    }
    
    @IBAction func setVolume(_ sender: UISlider) {
        manager.player.volume = sender.value
    }
    @IBAction func seekSliderAction(_ sender: UISlider) {
        manager.seekTo(Double(sender.value))
        updateTrackSlider()
    }
    
    @IBAction func previos(_ sender: Any) {
        manager.closePlayer()
        selectItem = (selectItem + musicData.count - 1) % musicData.count
        selectData(index: selectItem)
    }
    @IBAction func rightSwipe(_ sender: Any) {
        manager.closePlayer()
        selectItem = (selectItem + musicData.count - 1) % musicData.count
        selectData(index: selectItem)
    }
    
    @IBAction func playAction(_ sender: Any) {
        switch status {
        case .pause:
            manager.player.play()
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            status = .play
        case .play:
            manager.player.pause()
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            status = .pause
        case .unowned:
            selectData(index: 0)
            status = .play
        }
    }
    
    @IBAction func next(_ sender: Any) {
        manager.closePlayer()
        selectItem = (selectItem + musicData.count + 1) % musicData.count
        selectData(index: selectItem)
    }
    
    @IBAction func leftSwipe(_ sender: Any) {
        manager.closePlayer()
        selectItem = (selectItem + musicData.count + 1) % musicData.count
        selectData(index: selectItem)
    }
    @IBAction func randomAction(_ sender: UIButton) {
        rule = .random
        randomButton.backgroundColor = UIColor(named: "SelectRule")
        repeatButton.backgroundColor = .clear
    }
    
    @IBAction func showPlayList(_ sender: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 1, animations: {[unowned self] in
            
            playlistButton.image = isOpenPlayList ?  UIImage(named: "slide-up") : UIImage(named: "slide-down")
            
            playListView.transform = isOpenPlayList ? CGAffineTransform.identity : CGAffineTransform.identity.translatedBy(x: 0, y: -(playListView.frame.height - 110))
            
        }, completion:{[unowned self] finished in
            isOpenPlayList = !isOpenPlayList
        })
        
    }
    
    
    
    // MARK: - Method
    func setupBackground() {
        
        if let pink = UIColor(named: "F3B0E0"),
           let purple = UIColor(named: "9279CB") {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = view.bounds
            gradientLayer.colors = [pink.cgColor, purple.cgColor]
            view.layer.addSublayer(gradientLayer)
        }
        
        view.subviews.forEach({ view.bringSubviewToFront($0)})
    }
    
    func setupSlider() {
        percentSlider.setThumbImage(UIImage(named: "percentThumb"), for: .normal)
        sliderTrackView.backgroundColor = .clear
        sliderTrackView.layer.addSublayer(sliderTrackLayer)
    }
    
    
    func updateTrackSlider() {
        let percentWidth = CGFloat(self.percentSlider.value) * percentSlider.frame.width
        sliderTrack.constant = percentWidth
        
        if let color1 = UIColor(named: "1CBE9E"),
           let color2 = UIColor(named: "53E3C7") {
            
            sliderTrackLayer.frame = sliderTrackView.bounds
            sliderTrackLayer.colors = [color1.cgColor, color2.cgColor]
            sliderTrackLayer.startPoint = CGPoint(x: 0, y: 0.5)
            sliderTrackLayer.endPoint = CGPoint(x: 1, y: 0.5)
        }

    }
    
    func selectData(index:Int) {
        selectItem = index
        let selectMusic = musicData[index]
        let preMusic = musicData[(index + musicData.count - 1) % musicData.count]
        let nextMusic = musicData[(index + musicData.count + 1) % musicData.count]
        artistImageView[0].setImage(by: preMusic.artworkUrl100)
        artistImageView[1].setImage(by: selectMusic.artworkUrl100)
        artistImageView[2].setImage(by: nextMusic.artworkUrl100)
        artistLabel.text = selectMusic.artistName
        songLabel.text = selectMusic.trackName
        
        manager.current = index
        manager.maxCount = musicData.count
        manager.setupPlayer(with: selectMusic.previewUrl)
        manager.delegate = self
    }
}

//MARK: - PaulPlayerDelegate
extension PlayerViewController: PaulPlayerDelegate{
    func didReceiveNotification(player: AVPlayer?, notification: Notification.Name) {
        switch notification {
        case .PlayerUnknownNotification:
            manager.closePlayer()
            break
        case .PlayerReadyToPlayNotification:
            break
        case .PlayerDidToPlayNotification:
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            status = .play
            break
        case .PlayerFailedNotification:
            let alert = UIAlertController(title: "錯誤", message: "無法播放", preferredStyle: .alert)
            let action = UIAlertAction(title: "確認", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            break
        case .PauseNotification:
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            status = .pause
            break
        case .PlayerPlayFinishNotification:
            manager.closePlayer()
            switch rule {
            case .loop:
                selectItem = (selectItem + musicData.count + 1) % musicData.count
                selectData(index: selectItem)
            case .random:
                selectItem = Int.random(in: 0..<musicData.count)
                selectData(index: selectItem)
            case .single:
                if selectItem+1 < musicData.count {
                    selectItem = (selectItem + musicData.count + 1) % musicData.count
                    selectData(index: selectItem)
                }else{
                    playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
                    status = .unowned
                }
            }
            break
        default:
            break
        }
    }
    
    func didUpdatePosition(_ player: AVPlayer?, _ position: PlayerPosition) {
        percentSlider.value = Float(position.current)/Float(position.duration)
        minTimeLabel.text = String(format: "%02d:%02d", position.current/60, position.current%60)
        maxTimeLabel.text = String(format: "%02d:%02d", position.duration/60, position.duration%60)
        let selectMusic = musicData[selectItem]
        manager.setupNowPlaying(title: selectMusic.trackName, image: artistImageView[0].image)
        updateTrackSlider()
    }
    
    
}

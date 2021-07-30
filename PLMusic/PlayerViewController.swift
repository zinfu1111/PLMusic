//
//  PlayerViewController.swift
//  PLMusic
//
//  Created by 連振甫 on 2021/7/29.
//

import AVKit

class PlayerViewController: UIViewController {

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
    
    var isOpenPlayList = false
    var playListVC: PlayListViewController!
    var sliderTrackLayer = CAGradientLayer()
    var musicData:[Music] = []
    var selectMusic:Music?
    let player = AVPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupBackground()
        setupSlider()
        DataManager.shared.fetchMusic(completeHandler: { data in
            self.musicData = data
            DispatchQueue.main.async {
                self.playListVC.musicData = self.musicData
                self.playListVC.tableView.reloadData()
                self.setupMusicImagePage()
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
        }
    }
    
    
    //MARK: - IBAction
    
    @IBAction func repeatAction(_ sender: UIButton) {
    }
    
    @IBAction func seekSliderAction(_ sender: UISlider) {
        updateTrackSlider()
    }
    
    @IBAction func previos(_ sender: Any) {
    }
    
    @IBAction func playAction(_ sender: Any) {
    }
    
    @IBAction func next(_ sender: Any) {
    }
    
    @IBAction func randomAction(_ sender: UIButton) {
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
    
    func setupMusicImagePage() {
        
        artistImageView.forEach({ $0.layer.cornerRadius = $0.frame.width * 0.2})
        
        guard let selectMusic = selectMusic
        else {
            
            artistImageView[1].setImage(by: musicData[1].artworkUrl100)
            return
            
        }
    }
}

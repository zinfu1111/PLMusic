//
//  PlayerViewController.swift
//  PLMusic
//
//  Created by 連振甫 on 2021/7/29.
//

import UIKit

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
    var sliderTrackLayer = CAGradientLayer()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupBackground()
        percentSlider.setThumbImage(UIImage(named: "percentThumb"), for: .normal)
        sliderTrackView.backgroundColor = .clear
        sliderTrackView.layer.addSublayer(sliderTrackLayer)
    }
    
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
}

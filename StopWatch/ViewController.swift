//
//  ViewController.swift
//  StopWatch
//
//  Created by zhussupov on 7/11/19.
//  Copyright © 2019 Zhussupov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var timeLabel: UILabel! {
    didSet {
      timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: timeLabel!.font!.pointSize, weight: UIFont.Weight.regular)
    }
  }
  

  @IBOutlet weak var resetButton: UIButton!
  
  @IBOutlet weak var startButton: UIButton!
  
  var timer: Timer?
  
  var miliseconds: Int = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    timeLabel.textAlignment = .left
  }
  
  @objc func fireTimer(timer: Timer) {
    miliseconds += 1
    updateLabel()
  }

  @IBAction func didTapStartButton(_ sender: Any) {
    if startButton.backgroundColor == .red {
      startButton.setTitle("START", for: .normal)
      startButton.backgroundColor = .green
      timer?.invalidate()
      resetButton.isHidden = false
    } else {
      timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(fireTimer(timer:)), userInfo: nil, repeats: true)
      startButton.setTitle("STOP", for: .normal)
      startButton.backgroundColor = .red
      resetButton.isHidden = true
    }
  }
  
  @IBAction func didTapResetButton(_ sender: Any) {
    miliseconds = 0
    updateLabel()
  }
  
  func updateLabel() {
    let seconds = miliseconds/100%60
    let minutes = miliseconds/100/60
    
    //timeLabel.text = "\(minutes):\(seconds):\((miliseconds)%100)"
    timeLabel.text = String(format:"%02i:%02i:%02i", minutes, seconds, miliseconds%100)
  }
  
}


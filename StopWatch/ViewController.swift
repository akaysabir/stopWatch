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
  
  
  @IBOutlet weak var lapTimeTableView: UITableView!
  
  @IBOutlet weak var resetButton: UIButton!
  @IBOutlet weak var startButton: UIButton!
  
  let identifier = "stopWatch"
  
  var timer: Timer?
  var miliseconds: Int = 0
  var currentMiliseconds: Int = 0
  var min: Int = 1000000000
  var max: Int = 0
  
  var data: [Int] = [] {
    didSet {
      lapTimeTableView.reloadData() //calls datasource methods
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    timeLabel.textAlignment = .left
    
    lapTimeTableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
    lapTimeTableView.delegate = self
    lapTimeTableView.dataSource = self
    lapTimeTableView.separatorStyle = .none
    startButton.layer.cornerRadius = 15
    startButton.layer.masksToBounds = true
    resetButton.layer.cornerRadius = 15
    resetButton.layer.masksToBounds = true
    
  }
  
  @objc func fireTimer(timer: Timer) {
    miliseconds += 1
    currentMiliseconds += 1
    data[0] = currentMiliseconds
    updateLabel()
  }

  @IBAction func didTapStartButton(_ sender: Any) {
    if startButton.backgroundColor == .red {
      startButton.setTitle("START", for: .normal)
      startButton.backgroundColor = .green
      timer?.invalidate()
      resetButton.setTitle("RESET", for: .normal)
    } else {
      if data.isEmpty {
        data.append(currentMiliseconds)
      }
      timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(fireTimer(timer:)), userInfo: nil, repeats: true)
      RunLoop.current.add(timer!, forMode: .commonModes)
      
      startButton.setTitle("STOP", for: .normal)
      startButton.backgroundColor = .red
      resetButton.setTitle("LAP", for: .normal)
    }
  }
  
  @IBAction func didTapResetButton(_ sender: Any) {
    
    let title = resetButton.currentTitle ?? "lox"
    if title == "RESET" {
      miliseconds = 0
      currentMiliseconds = 0
      data.removeAll()
      min = 1000000000
      max = 0
    } else {
      data.insert(currentMiliseconds, at: 1)
      
      if currentMiliseconds > max {
        max = currentMiliseconds
      }
      if currentMiliseconds < min {
        min = currentMiliseconds
      }
      
      currentMiliseconds = 0
    }
    updateLabel()
  }
  
  func updateLabel() {
    let seconds = miliseconds/100%60
    let minutes = miliseconds/100/60
    
    //timeLabel.text = "\(minutes):\(seconds):\((miliseconds)%100)"
    timeLabel.text = String(format:"%02i:%02i:%02i", minutes, seconds, miliseconds%100)
  }
  
}

extension ViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
    
    let curMil = data[indexPath.row]
    let curSeconds = curMil/100%60
    let curMinutes = curMil/100/60
    let text = String(format:"%02i:%02i:%02i", curMinutes, curSeconds, curMil%100)
    let lapNumber = data.count - indexPath.row
    
    cell.textLabel?.text = "Lap \(lapNumber)                \(text)"
    cell.textLabel?.textColor = .white
    cell.backgroundColor = .black
    cell.selectionStyle = .none
    
    if data.count > 2 && indexPath.row != 0 {
      if curMil == min {
        cell.textLabel?.textColor = .green
      }
      if curMil == max {
        cell.textLabel?.textColor = .red
      }
    }
    return cell
  }
  

}

extension ViewController: UITableViewDelegate {

}


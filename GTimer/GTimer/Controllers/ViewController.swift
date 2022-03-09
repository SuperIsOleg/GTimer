//
//  ViewController.swift
//  GTimer
//
//  Created by Home on 5.03.22.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    let cercleTimer : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "TimerCircel")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let timerLabel : UILabel = {
        let timerLabel = UILabel()
        timerLabel.text = "05:00"
        timerLabel.font = UIFont.systemFont(ofSize: 50)
        timerLabel.textColor = .white
        timerLabel.numberOfLines = 0
        timerLabel.textAlignment = .center
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        return timerLabel
    }()
    
    private let startButton : UIButton = {
        let startButton = UIButton()
        startButton.layer.cornerRadius = 20
        startButton.setBackgroundImage(UIImage(named: "StartButton"), for: .normal)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        return startButton
    }()
    
    private let cancelButton : UIButton = {
        let cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        cancelButton.titleLabel?.numberOfLines = 0
        cancelButton.titleLabel?.textAlignment = .center
        cancelButton.backgroundColor = nil
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        return cancelButton
    }()
    
    
    var timer = Timer()
    var isTimerStarted = false
    
    let shapeLayer = CAShapeLayer()
    
    var durationTimer = 300
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.animationCircular()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(named: "LightBlue")!.cgColor,
                                UIColor(named: "DarkBlue")!.cgColor]
        view.layer.addSublayer(gradientLayer)
        
        setConstraints()
        
        startButton.addTarget(self, action: #selector(startButtonTaped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTaped), for: .touchUpInside)
    }
    
    @objc func startButtonTaped() {
        cancelButton.isEnabled = true
        cancelButton.alpha = 1.0
        
        if !isTimerStarted{
            basicAnimation()
            startTimer()
            isTimerStarted = true
            startButton.setBackgroundImage(UIImage(named: "PauseButton"), for: .normal)
            
        } else {
            timer.invalidate()
            isTimerStarted = false
            startButton.setBackgroundImage(UIImage(named: "ResumeButton"), for: .normal)
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc func cancelButtonTaped() {
        cancelButton.isEnabled = false
        cancelButton.alpha = 0.5
        timer.invalidate()
        durationTimer = 300
        isTimerStarted = false
        timerLabel.text = "05:00"
        startButton.setBackgroundImage(UIImage(named: "StartButton"), for: .normal)
    }
    
    @objc func timerAction() {
        durationTimer -= 1
        timerLabel.text = formatTimer()
        print(durationTimer)
        
        if durationTimer == 0 {
            timer.invalidate()
        }
    }
    
    func formatTimer() -> String {
        let minutes = Int(durationTimer) / 60 % 60
        let seconds = Int(durationTimer) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    //MARC: Animation
    
    func animationCircular() {
        
        let center = CGPoint(x: cercleTimer.frame.width / 2, y: cercleTimer.frame.height / 2)
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        let circularPatch = UIBezierPath(arcCenter: center, radius: 92, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        shapeLayer.path = circularPatch.cgPath
        shapeLayer.lineWidth = 3.5
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeColor = UIColor(named: "TimerColor")!.cgColor
        cercleTimer.layer.addSublayer(shapeLayer)
    }
    
    func basicAnimation() {
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 0
        basicAnimation.duration = CFTimeInterval(durationTimer)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = true
        shapeLayer.add(basicAnimation, forKey: "basicAnimation")
    }
}

extension ViewController {
    
    func setConstraints() {
        view.addSubview(cercleTimer)
        NSLayoutConstraint.activate([
            cercleTimer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cercleTimer.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 320),
            cercleTimer.heightAnchor.constraint(equalToConstant: 380),
            cercleTimer.widthAnchor.constraint(equalToConstant: 380)
        ])
        
        cercleTimer.addSubview(timerLabel)
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: cercleTimer.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: cercleTimer.centerYAnchor)
        ])
        
        view.addSubview(startButton)
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: cercleTimer.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: cercleTimer.bottomAnchor, constant: 178),
            startButton.heightAnchor.constraint(equalToConstant: 120),
            startButton.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        view.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.centerXAnchor.constraint(equalTo: startButton.centerXAnchor),
            cancelButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 0),
            cancelButton.heightAnchor.constraint(equalToConstant: 30),
            cancelButton.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
}


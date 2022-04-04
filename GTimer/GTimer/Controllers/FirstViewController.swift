//
//  FirstViewController.swift
//  GTimer
//
//  Created by Home on 4.04.22.
//

import UIKit

//class FirstViewController: UIViewController {
// 
//    var timer = Timer()
//    
//    var secNumber = SecIntArray()
//    var minNumber = MinIntArray()
//    
//    var minutesNumbersStarted = 60
//    var secondsNumbersStarted = 0
//    
//   lazy var durationTimer = minutesNumbersStarted + secondsNumbersStarted
//    
//    var isTimerStarted = false
//    var isAnimationStarted = false
//    
//    let shapeLayerWorkTimer = CAShapeLayer()
//    let shapeLayerBreakTimer = CAShapeLayer()
//    
//    lazy var viewTimerWorked = FactoryView.getView()
//    lazy var viewTimerBreak = FactoryView.getView()
//    
//    lazy var views = [viewTimerWorked, viewTimerBreak]
//    
//    //MARC: Timer
//    
//    @objc func startButtonTaped() {
//        cancelButton.isEnabled = true
//        cancelButton.alpha = 1.0
//        if !isTimerStarted {
//            pickerView.removeFromSuperview()
//            viewTimerWorked.addSubview(cercleTimerWorkImage)
//            NSLayoutConstraint.activate([
//                cercleTimerWorkImage.centerXAnchor.constraint(equalTo: viewTimerWorked.centerXAnchor),
//                cercleTimerWorkImage.centerYAnchor.constraint(equalTo: viewTimerWorked.centerYAnchor),
//                cercleTimerWorkImage.heightAnchor.constraint(equalToConstant: 400),
//                cercleTimerWorkImage.widthAnchor.constraint(equalToConstant: 400)
//            ])
//            startResumeAnimation()
//            startTimer()
//            isTimerStarted = true
//            startButton.setBackgroundImage(UIImage(named: "PauseButton"), for: .normal)
//        } else {
//            pauseAnimation()
//            timer.invalidate()
//            isTimerStarted = false
//            startButton.setBackgroundImage(UIImage(named: "ResumeButton"), for: .normal)
//        }
//    }
//    
//    func startTimer() {
//        timerWorkLabel.text = formatTimer()
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
//    }
//    
//    @objc func cancelButtonTaped() {
//        cercleTimerWorkImage.removeFromSuperview()
//        durationTimer = minutesNumbersStarted + secondsNumbersStarted
//        setUpPickerView()
//        stopAnimation()
//        cancelButton.isEnabled = false
//        cancelButton.alpha = 0.5
//        timer.invalidate()
//        isTimerStarted = false
//        timerWorkLabel.text = formatTimer()
//        startButton.setBackgroundImage(UIImage(named: "StartButton"), for: .normal)
//    }
//    
//    @objc func updateTimer() {
//        if durationTimer < 1 {
//            cancelButton.isEnabled = false
//            cancelButton.alpha = 0.5
//            startButton.setBackgroundImage(UIImage(named: "StartButton"), for: .normal)
//            timer.invalidate()
//            durationTimer = 0
//            isTimerStarted = false
//            timerWorkLabel.text = formatTimer()
//            cercleTimerWorkImage.removeFromSuperview()
//            setUpPickerView()
//        } else {
//            durationTimer -= 1
//            timerWorkLabel.text = formatTimer()
//        }
//    }
//    
//    func formatTimer() -> String {
//        let minutes = Int(durationTimer) / 60 % 60
//        let seconds = Int(durationTimer) % 60
//        return String(format: "%02i:%02i", minutes, seconds)
//    }
//    
//    
//    //MARC: Animation
//    
//    func animationCircularWorkTimer() {
//        let center = CGPoint(x: cercleTimerWorkImage.frame.width / 2, y: cercleTimerWorkImage.frame.height / 2)
//        let endAngle = (-CGFloat.pi / 2)
//        let startAngle = 2 * CGFloat.pi + endAngle
//        let circularPatch = UIBezierPath(arcCenter: center, radius: 97, startAngle: startAngle, endAngle: endAngle, clockwise: false)
//        shapeLayerWorkTimer.path = circularPatch.cgPath
//        shapeLayerWorkTimer.lineWidth = 3.5
//        shapeLayerWorkTimer.fillColor = UIColor.clear.cgColor
//        shapeLayerWorkTimer.strokeEnd = 1
//        shapeLayerWorkTimer.lineCap = CAShapeLayerLineCap.round
//        shapeLayerWorkTimer.strokeColor = UIColor(named: "TimerColorWork")!.cgColor
//        cercleTimerWorkImage.layer.addSublayer(shapeLayerWorkTimer)
//    }
//    
//    func animationCircularBreakTimer() {
//        let center = CGPoint(x: cercleTimerBreakImage.frame.width / 2, y: cercleTimerBreakImage.frame.height / 2)
//        let endAngle = (-CGFloat.pi / 2)
//        let startAngle = 2 * CGFloat.pi + endAngle
//        let circularPatch = UIBezierPath(arcCenter: center, radius: 97, startAngle: startAngle, endAngle: endAngle, clockwise: false)
//        shapeLayerBreakTimer.path = circularPatch.cgPath
//        shapeLayerBreakTimer.lineWidth = 3.5
//        shapeLayerBreakTimer.fillColor = UIColor.clear.cgColor
//        shapeLayerBreakTimer.strokeEnd = 1
//        shapeLayerBreakTimer.lineCap = CAShapeLayerLineCap.round
//        shapeLayerBreakTimer.strokeColor = UIColor(named: "TimerColorBreak")!.cgColor
//        cercleTimerBreakImage.layer.addSublayer(shapeLayerBreakTimer)
//    }
//    
//    func startResumeAnimation() {
//        if !isAnimationStarted {
//            startAnimation()
//        } else {
//            resumeAnimation()
//        }
//    }
//    
//    func startAnimation() {
//        let animation = CABasicAnimation(keyPath: "strokeEnd")
//        stopAnimation()
//        shapeLayerWorkTimer.strokeEnd = 0.0
//        animation.toValue = 0
//        animation.duration = CFTimeInterval(durationTimer)
//        animation.fillMode = CAMediaTimingFillMode.forwards
//        animation.isRemovedOnCompletion = true
//        shapeLayerWorkTimer.add(animation, forKey: "startAnimation")
//        shapeLayerBreakTimer.add(animation, forKey: "startAnimation")
//        isAnimationStarted = true
//    }
//    
//    func pauseAnimation() {
//        let pausedTime = shapeLayerWorkTimer.convertTime(CACurrentMediaTime(), from: nil)
//        shapeLayerWorkTimer.speed = 0.0
//        shapeLayerWorkTimer.timeOffset = pausedTime
//    }
//    
//    func resumeAnimation() {
//        let pausedTime = shapeLayerWorkTimer.timeOffset
//        shapeLayerWorkTimer.speed = 1.0
//        shapeLayerWorkTimer.timeOffset = 0.0
//        shapeLayerWorkTimer.beginTime = 0.0
//        let timeSincePaused = shapeLayerWorkTimer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
//        shapeLayerWorkTimer.beginTime = timeSincePaused
//    }
//    
//    func stopAnimation() {
//        shapeLayerWorkTimer.speed = 1.0
//        shapeLayerWorkTimer.timeOffset = 0.0
//        shapeLayerWorkTimer.beginTime = 0.0
//        shapeLayerWorkTimer.strokeEnd = 0.0
//        shapeLayerWorkTimer.removeAllAnimations()
//        isAnimationStarted = false
//    }
//    
//    internal func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        stopAnimation()
//    }
//}

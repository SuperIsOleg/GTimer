//
//  ViewController.swift
//  GTimer
//
//  Created by Home on 5.03.22.
//

import UIKit

final class MainViewController: UIViewController {
    
    var mainView: MainView { return self.view as! MainView}
    
    var timer = Timer()
    let shapeLayerWorkTimer = CAShapeLayer()
    
    var isTimerStartedWorked = false
    var isAnimationStartedWorked = false
 
    override func loadView() {
        self.view = MainView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.animationCircularWorkTimer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.onClouserPageControl = { [weak self] in self?.pageControlDidChange()}
        mainView.onClouserStartButton = { [weak self] in self?.startButtonTaped()}
        mainView.onClouserCancelButton = { [weak self] in self?.cancelButtonTaped()}
    }
    
    @objc func pageControlDidChange() {
        mainView.scrollView.setContentOffset(CGPoint(x: CGFloat(2) * view.frame.size.width, y: 0), animated: true)
    }
    
    // MARK: - TimerWorked
 
    @objc func startButtonTaped() {
        mainView.cancelButton.isEnabled = true
        mainView.cancelButton.alpha = 1.0
      
        if !isTimerStartedWorked {
            mainView.pickerViewWorked.removeFromSuperview()
            mainView.viewTimerWorked.addSubview(mainView.cercleTimerWorkImage)
            NSLayoutConstraint.activate([
                mainView.cercleTimerWorkImage.centerXAnchor.constraint(equalTo: mainView.viewTimerWorked.centerXAnchor),
                mainView.cercleTimerWorkImage.centerYAnchor.constraint(equalTo: mainView.viewTimerWorked.centerYAnchor),
                mainView.cercleTimerWorkImage.heightAnchor.constraint(equalToConstant: 400),
                mainView.cercleTimerWorkImage.widthAnchor.constraint(equalToConstant: 400)
            ])
            startResumeAnimation()
            startTimerWorked()
            isTimerStartedWorked = true
            mainView.startButton.setBackgroundImage(UIImage(named: "PauseButton"), for: .normal)
        } else {
            pauseAnimation()
            timer.invalidate()
            isTimerStartedWorked = false
            mainView.startButton.setBackgroundImage(UIImage(named: "ResumeButton"), for: .normal)
        }
    }
    
    func startTimerWorked() {
        mainView.timerWorkLabel.text = formatTimer()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func cancelButtonTaped() {
        mainView.cercleTimerWorkImage.removeFromSuperview()
        mainView.cercleTimerBreakImage.removeFromSuperview()
        mainView.durationTimerWorked = 0
        mainView.setUpPickerViewWorked()
        stopAnimation()
        mainView.cancelButton.isEnabled = false
        mainView.cancelButton.alpha = 0.5
        timer.invalidate()
        isTimerStartedWorked = false
        mainView.timerWorkLabel.text = formatTimer()
        mainView.startButton.setBackgroundImage(UIImage(named: "StartButton"), for: .normal)
    }
    
    @objc func updateTimer() {
        if mainView.durationTimerWorked < 1 {
            mainView.cancelButton.isEnabled = false
            mainView.cancelButton.alpha = 0.5
            mainView.startButton.setBackgroundImage(UIImage(named: "StartButton"), for: .normal)
            timer.invalidate()
            mainView.durationTimerWorked = mainView.minutesNumbersStartedWorked + mainView.secondsNumbersStartedWorked
            isTimerStartedWorked = false
            mainView.timerWorkLabel.text = formatTimer()
            mainView.cercleTimerWorkImage.removeFromSuperview()
            mainView.setUpPickerViewWorked()
        } else {
            mainView.durationTimerWorked -= 1
            mainView.timerWorkLabel.text = formatTimer()
        }
    }
    
    func formatTimer() -> String {
        let minutes = Int(mainView.durationTimerWorked) / 60 % 60
        let seconds = Int(mainView.durationTimerWorked) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    // MARK: - AnimationWorked
    
    func animationCircularWorkTimer() {
        let center = CGPoint(x: mainView.cercleTimerWorkImage.frame.width / 2, y: mainView.cercleTimerWorkImage.frame.height / 2)
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        let circularPatch = UIBezierPath(arcCenter: center, radius: 97, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        shapeLayerWorkTimer.path = circularPatch.cgPath
        shapeLayerWorkTimer.lineWidth = 3.5
        shapeLayerWorkTimer.fillColor = UIColor.clear.cgColor
        shapeLayerWorkTimer.strokeEnd = 1
        shapeLayerWorkTimer.lineCap = CAShapeLayerLineCap.round
        shapeLayerWorkTimer.strokeColor = UIColor(named: "TimerColorWork")!.cgColor
        mainView.cercleTimerWorkImage.layer.addSublayer(shapeLayerWorkTimer)
    }
    
    func startResumeAnimation() {
        if !isAnimationStartedWorked {
            startAnimation()
        } else {
            resumeAnimation()
        }
    }
    
    func startAnimation() {
        let animationWorked = CABasicAnimation(keyPath: "strokeEnd")
        stopAnimation()
        shapeLayerWorkTimer.strokeEnd = 0.0
        animationWorked.toValue = 0
        animationWorked.duration = CFTimeInterval(mainView.durationTimerWorked)
        animationWorked.fillMode = CAMediaTimingFillMode.forwards
        animationWorked.isRemovedOnCompletion = true
        shapeLayerWorkTimer.add(animationWorked, forKey: "startAnimation")
        isAnimationStartedWorked = true
    }
    
    func pauseAnimation() {
        let pausedTimeWorked = shapeLayerWorkTimer.convertTime(CACurrentMediaTime(), from: nil)
        shapeLayerWorkTimer.speed = 0.0
        shapeLayerWorkTimer.timeOffset = pausedTimeWorked
    }
    
    func resumeAnimation() {
        let pausedTimeWorked = shapeLayerWorkTimer.timeOffset
        shapeLayerWorkTimer.speed = 1.0
        shapeLayerWorkTimer.timeOffset = 0.0
        shapeLayerWorkTimer.beginTime = 0.0
        let timeSincePausedWorked = shapeLayerWorkTimer.convertTime(CACurrentMediaTime(), from: nil) - pausedTimeWorked
        shapeLayerWorkTimer.beginTime = timeSincePausedWorked
    }
    
    func stopAnimation() {
        shapeLayerWorkTimer.speed = 1.0
        shapeLayerWorkTimer.timeOffset = 0.0
        shapeLayerWorkTimer.beginTime = 0.0
        shapeLayerWorkTimer.strokeEnd = 0.0
        shapeLayerWorkTimer.removeAllAnimations()
        isAnimationStartedWorked = false
    }
    
    internal func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        stopAnimation()
    }
    
}

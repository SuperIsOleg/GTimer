//
//  ViewController.swift
//  GTimer
//
//  Created by Home on 5.03.22.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    lazy var viewTimerWorked: UIView = {
        let viewTimerWorked = UIView()
        viewTimerWorked.backgroundColor = nil
        return viewTimerWorked
    }()
    
    lazy var viewTimerBreak: UIView = {
        let viewTimerBreak = UIView()
        viewTimerBreak.backgroundColor = nil
        return viewTimerBreak
    }()
    
    lazy var views = [viewTimerWorked, viewTimerBreak]
    
    let cercleTimerWorkImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "TimerCircel")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let cercleTimerBreakImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "TimerCircel")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let timerWorkLabel: UILabel = {
        let timerWorkLabel = UILabel()
        timerWorkLabel.text = "01:00"
        timerWorkLabel.font = UIFont.systemFont(ofSize: 50)
        timerWorkLabel.textColor = .white
        timerWorkLabel.numberOfLines = 0
        timerWorkLabel.textAlignment = .center
        timerWorkLabel.translatesAutoresizingMaskIntoConstraints = false
        return timerWorkLabel
    }()
    
    let timerBreakLabel: UILabel = {
        let timerBreakLabel = UILabel()
        timerBreakLabel.text = "00:30"
        timerBreakLabel.font = UIFont.systemFont(ofSize: 50)
        timerBreakLabel.textColor = .white
        timerBreakLabel.numberOfLines = 0
        timerBreakLabel.textAlignment = .center
        timerBreakLabel.translatesAutoresizingMaskIntoConstraints = false
        return timerBreakLabel
    }()
    
    let workLabel: UILabel = {
        let workLabel = UILabel()
        workLabel.text = "Work"
        workLabel.font = UIFont.systemFont(ofSize: 25)
        workLabel.textColor = .white
        workLabel.numberOfLines = 0
        workLabel.textAlignment = .center
        workLabel.translatesAutoresizingMaskIntoConstraints = false
        return workLabel
    }()
    
    let breakLabel: UILabel = {
        let breakLabel = UILabel()
        breakLabel.text = "Break"
        breakLabel.font = UIFont.systemFont(ofSize: 25)
        breakLabel.textColor = .white
        breakLabel.numberOfLines = 0
        breakLabel.textAlignment = .center
        breakLabel.translatesAutoresizingMaskIntoConstraints = false
        return breakLabel
    }()
    
    lazy  var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        
        let colors: [UIColor] = [UIColor(named: "TimerColorWork")!, UIColor(named: "TimerColorBreak")!]
        
        for x in 0..<views.count {
            if x == 0 {
                pageControl.currentPageIndicatorTintColor = colors[x]
            } else {
                pageControl.pageIndicatorTintColor = colors[x]
            }
        }
        
        pageControl.numberOfPages = views.count
        pageControl.currentPage = 0
        pageControl.backgroundColor = nil
//        pageControl.currentPageIndicatorTintColor = UIColor(named: "TimerColorWork") // цвет выбранной вьюшки
//        pageControl.pageIndicatorTintColor = .green // цвет не выбранной вьюшки
        pageControl.preferredIndicatorImage = UIImage(named: "PageIndecator")
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: view.frame.size.width * CGFloat(views.count), height: view.frame.size.height)
        for i in 0..<views.count {
            views[i].frame = CGRect(x: CGFloat(i) * view.frame.size.width, y: 120, width: view.frame.width, height: 400)
            scrollView.addSubview(views[i])
        }
        scrollView.delegate = self
        return scrollView
    }()
    
    private let startButton: UIButton = {
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
    var durationTimer = 60
    var isTimerStarted = false
    var isAnimationStarted = false
    let shapeLayerWorkTimer = CAShapeLayer()
    let shapeLayerBreakTimer = CAShapeLayer()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.animationCircularWorkTimer()
        self.animationCircularBreakTimer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(named: "LightBlue")!.cgColor,
                                UIColor(named: "DarkBlue")!.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.addSublayer(gradientLayer)
        
        scrollView.frame = view.bounds
        view.addSubview(scrollView)
        
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_ :)), for: .valueChanged)
        view.addSubview(pageControl)
        
        setConstraints()
        
        startButton.addTarget(self, action: #selector(startButtonTaped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTaped), for: .touchUpInside)
    }
    
    @objc func pageControlDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        scrollView.setContentOffset(CGPoint(x: CGFloat(current) * view.frame.size.width, y: 0), animated: true)
    }
    
    @objc func startButtonTaped() {
        cancelButton.isEnabled = true
        cancelButton.alpha = 1.0
        
        if !isTimerStarted{
            startResumeAnimation()
            startTimer()
            isTimerStarted = true
            startButton.setBackgroundImage(UIImage(named: "PauseButton"), for: .normal)
            
        } else {
            pauseAnimation()
            timer.invalidate()
            isTimerStarted = false
            startButton.setBackgroundImage(UIImage(named: "ResumeButton"), for: .normal)
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func cancelButtonTaped() {
        stopAnimation()
        cancelButton.isEnabled = false
        cancelButton.alpha = 0.5
        timer.invalidate()
        durationTimer = 60
        isTimerStarted = false
        timerWorkLabel.text = "01:00"
        startButton.setBackgroundImage(UIImage(named: "StartButton"), for: .normal)
       
    }
    
    @objc func updateTimer() {
        if durationTimer < 1 {
        cancelButton.isEnabled = false
            cancelButton.alpha = 0.5
            startButton.setBackgroundImage(UIImage(named: "StartButton"), for: .normal)
            timer.invalidate()
            durationTimer = 60
            isTimerStarted = false
            timerWorkLabel.text = "01:00"
        } else {
            durationTimer -= 1
            timerWorkLabel.text = formatTimer()
        }
    }
    
    func formatTimer() -> String {
        let minutes = Int(durationTimer) / 60 % 60
        let seconds = Int(durationTimer) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    //MARC: Animation
    
    func animationCircularWorkTimer() {
        
        let center = CGPoint(x: cercleTimerWorkImage.frame.width / 2, y: cercleTimerWorkImage.frame.height / 2)
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        let circularPatch = UIBezierPath(arcCenter: center, radius: 97, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        shapeLayerWorkTimer.path = circularPatch.cgPath
        shapeLayerWorkTimer.lineWidth = 3.5
        shapeLayerWorkTimer.fillColor = UIColor.clear.cgColor
        shapeLayerWorkTimer.strokeEnd = 1
        shapeLayerWorkTimer.lineCap = CAShapeLayerLineCap.round
        shapeLayerWorkTimer.strokeColor = UIColor(named: "TimerColorWork")!.cgColor
        cercleTimerWorkImage.layer.addSublayer(shapeLayerWorkTimer)
    }
    
    func animationCircularBreakTimer() {
        
        let center = CGPoint(x: cercleTimerBreakImage.frame.width / 2, y: cercleTimerBreakImage.frame.height / 2)
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        let circularPatch = UIBezierPath(arcCenter: center, radius: 97, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        shapeLayerBreakTimer.path = circularPatch.cgPath
        shapeLayerBreakTimer.lineWidth = 3.5
        shapeLayerBreakTimer.fillColor = UIColor.clear.cgColor
        shapeLayerBreakTimer.strokeEnd = 1
        shapeLayerBreakTimer.lineCap = CAShapeLayerLineCap.round
        shapeLayerBreakTimer.strokeColor = UIColor(named: "TimerColorBreak")!.cgColor
        cercleTimerBreakImage.layer.addSublayer(shapeLayerBreakTimer)
    }
    
    func startResumeAnimation() {
        if !isAnimationStarted {
            startAnimation()
        } else {
            resumeAnimation()
        }
    }
    
    func startAnimation() {
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        resetAnimation()
        shapeLayerWorkTimer.strokeEnd = 0.0
        animation.toValue = 0
        animation.duration = CFTimeInterval(durationTimer)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = true
        shapeLayerWorkTimer.add(animation, forKey: "startAnimation")
        shapeLayerBreakTimer.add(animation, forKey: "startAnimation")
        isAnimationStarted = true
    }
    
    func resetAnimation() {
        shapeLayerWorkTimer.speed = 1.0
        shapeLayerWorkTimer.timeOffset = 0.0
        shapeLayerWorkTimer.beginTime = 0.0
        shapeLayerWorkTimer.strokeEnd = 0.0
        isAnimationStarted = false
    }
    
    func pauseAnimation() {
        let pausedTime = shapeLayerWorkTimer.convertTime(CACurrentMediaTime(), from: nil)
        shapeLayerWorkTimer.speed = 0.0
        shapeLayerWorkTimer.timeOffset = pausedTime
    }
    
    func resumeAnimation() {
        let pausedTime = shapeLayerWorkTimer.timeOffset
        shapeLayerWorkTimer.speed = 1.0
        shapeLayerWorkTimer.timeOffset = 0.0
        shapeLayerWorkTimer.beginTime = 0.0
        let timeSincePaused = shapeLayerWorkTimer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        shapeLayerWorkTimer.beginTime = timeSincePaused
    }
    
    func stopAnimation() {
        shapeLayerWorkTimer.speed = 1.0
        shapeLayerWorkTimer.timeOffset = 0.0
        shapeLayerWorkTimer.beginTime = 0.0
        shapeLayerWorkTimer.strokeEnd = 0.0
        shapeLayerWorkTimer.removeAllAnimations()
        isAnimationStarted = false
    }
 
    internal func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        stopAnimation()
    }
}

extension ViewController {
    
    func setConstraints() {
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 320),
            scrollView.heightAnchor.constraint(equalToConstant: 380),
        ])
        
        viewTimerWorked.addSubview(cercleTimerWorkImage)
        NSLayoutConstraint.activate([
            cercleTimerWorkImage.centerXAnchor.constraint(equalTo: viewTimerWorked.centerXAnchor),
            cercleTimerWorkImage.centerYAnchor.constraint(equalTo: viewTimerWorked.centerYAnchor),
            cercleTimerWorkImage.heightAnchor.constraint(equalToConstant: 400),
            cercleTimerWorkImage.widthAnchor.constraint(equalToConstant: 400)
        ])
 
        cercleTimerWorkImage.addSubview(timerWorkLabel)
        NSLayoutConstraint.activate([
            timerWorkLabel.centerXAnchor.constraint(equalTo: cercleTimerWorkImage.centerXAnchor),
            timerWorkLabel.centerYAnchor.constraint(equalTo: cercleTimerWorkImage.centerYAnchor)
        ])
        
        viewTimerWorked.addSubview(workLabel)
        NSLayoutConstraint.activate([
            workLabel.centerXAnchor.constraint(equalTo: viewTimerWorked.centerXAnchor),
            workLabel.centerYAnchor.constraint(equalTo: viewTimerWorked.bottomAnchor)
        ])
        
        viewTimerBreak.addSubview(cercleTimerBreakImage)
        NSLayoutConstraint.activate([
            cercleTimerBreakImage.centerXAnchor.constraint(equalTo: viewTimerBreak.centerXAnchor),
            cercleTimerBreakImage.centerYAnchor.constraint(equalTo: viewTimerBreak.centerYAnchor),
            cercleTimerBreakImage.heightAnchor.constraint(equalToConstant: 400),
            cercleTimerBreakImage.widthAnchor.constraint(equalToConstant: 400)
        ])
        
        cercleTimerBreakImage.addSubview(timerBreakLabel)
        NSLayoutConstraint.activate([
            timerBreakLabel.centerXAnchor.constraint(equalTo: cercleTimerBreakImage.centerXAnchor),
            timerBreakLabel.centerYAnchor.constraint(equalTo: cercleTimerBreakImage.centerYAnchor)
        ])
        
        viewTimerBreak.addSubview(breakLabel)
        NSLayoutConstraint.activate([
            breakLabel.centerXAnchor.constraint(equalTo: viewTimerBreak.centerXAnchor),
            breakLabel.centerYAnchor.constraint(equalTo: viewTimerBreak.bottomAnchor)
        ])
        
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: viewTimerWorked.bottomAnchor, constant: 30),
            pageControl.heightAnchor.constraint(equalToConstant: 10),
            pageControl.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        view.addSubview(startButton)
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: pageControl.centerXAnchor),
            startButton.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 70),
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

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
    }
}


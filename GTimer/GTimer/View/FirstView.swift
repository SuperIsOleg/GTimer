//
//  FirstView.swift
//  GTimer
//
//  Created by Home on 5.03.22.
//

import UIKit

class FirstView: UIViewController {
    
    let pickerView = UIPickerView()
    
    var timer = Timer()
    
    var secNumber = SecIntArray()
    var minNumber = MinIntArray()
    
    var minutesNumbersStarted = 60
    var secondsNumbersStarted = 0
    
   lazy var durationTimer = minutesNumbersStarted + secondsNumbersStarted
    
    var isTimerStarted = false
    var isAnimationStarted = false
    
    let shapeLayerWorkTimer = CAShapeLayer()
    let shapeLayerBreakTimer = CAShapeLayer()
    
    lazy var viewTimerWorked = FactoryView.getView()
    lazy var viewTimerBreak = FactoryView.getView()
    
    lazy var views = [viewTimerWorked, viewTimerBreak]
    
    let cercleTimerWorkImage = FactoryImage.getImage(named: "TimerCircel")
    let cercleTimerBreakImage = FactoryImage.getImage(named: "TimerCircel")
    
    let timerWorkLabel = FactoryLabel.getTitleLabel(textTitleLabel: "01:00", sizeTitle: 50)
    let timerBreakLabel = FactoryLabel.getTitleLabel(textTitleLabel: "00:30", sizeTitle: 50)
    let workLabel = FactoryLabel.getTitleLabel(textTitleLabel: "Work", sizeTitle: 25)
    let breakLabel = FactoryLabel.getTitleLabel(textTitleLabel: "Break", sizeTitle: 25)
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        let colors: [UIColor] = [UIColor(named: "TimerColorWork")!, UIColor(named: "TimerColorBreak")!]
        pageControl.numberOfPages = views.count
        pageControl.currentPage = 0
        pageControl.backgroundColor = nil
        pageControl.preferredIndicatorImage = UIImage(named: "PageIndecator")
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        for x in 0..<views.count {
            if x == 0 {
                pageControl.currentPageIndicatorTintColor = colors[x]
            } else {
                pageControl.pageIndicatorTintColor = colors[x]
            }
        }
        return pageControl
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = view.bounds
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
    
    let startButton: UIButton = {
        let startButton = UIButton()
        startButton.layer.cornerRadius = 20
        startButton.setBackgroundImage(UIImage(named: "StartButton"), for: .normal)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        return startButton
    }()
    
    let cancelButton : UIButton = {
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.animationCircularWorkTimer()
        self.animationCircularBreakTimer()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        view.addSubview(pageControl)
        setGradientLayer()
        setConstraints()
        setUpPickerView()
        pageControl.addTarget(self, action: #selector(pageControlDidChange(_ :)), for: .valueChanged)
        startButton.addTarget(self, action: #selector(startButtonTaped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTaped), for: .touchUpInside)
    }
    
    @objc func pageControlDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        scrollView.setContentOffset(CGPoint(x: CGFloat(current) * view.frame.size.width, y: 0), animated: true)
    }
    
    func setUpPickerView() {
        pickerView.frame.size.width = 240
        pickerView.layer.position = CGPoint(x: self.viewTimerWorked.frame.width/2, y:self.viewTimerWorked.frame.size.height/3)
        pickerView.reloadAllComponents()
        viewTimerWorked.addSubview(pickerView)
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    func setGradientLayer () {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor(named: "LightBlue")!.cgColor,
                                UIColor(named: "DarkBlue")!.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.addSublayer(gradientLayer)
    }
    
    //MARC: Timer
    
    @objc func startButtonTaped() {
        cancelButton.isEnabled = true
        cancelButton.alpha = 1.0
        if !isTimerStarted {
            pickerView.removeFromSuperview()
            viewTimerWorked.addSubview(cercleTimerWorkImage)
            NSLayoutConstraint.activate([
                cercleTimerWorkImage.centerXAnchor.constraint(equalTo: viewTimerWorked.centerXAnchor),
                cercleTimerWorkImage.centerYAnchor.constraint(equalTo: viewTimerWorked.centerYAnchor),
                cercleTimerWorkImage.heightAnchor.constraint(equalToConstant: 400),
                cercleTimerWorkImage.widthAnchor.constraint(equalToConstant: 400)
            ])
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
        timerWorkLabel.text = formatTimer()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func cancelButtonTaped() {
        cercleTimerWorkImage.removeFromSuperview()
        durationTimer = minutesNumbersStarted + secondsNumbersStarted
        setUpPickerView()
        stopAnimation()
        cancelButton.isEnabled = false
        cancelButton.alpha = 0.5
        timer.invalidate()
        isTimerStarted = false
        timerWorkLabel.text = formatTimer()
        startButton.setBackgroundImage(UIImage(named: "StartButton"), for: .normal)
    }
    
    @objc func updateTimer() {
        if durationTimer < 1 {
            cancelButton.isEnabled = false
            cancelButton.alpha = 0.5
            startButton.setBackgroundImage(UIImage(named: "StartButton"), for: .normal)
            timer.invalidate()
            durationTimer = 0
            isTimerStarted = false
            timerWorkLabel.text = formatTimer()
            cercleTimerWorkImage.removeFromSuperview()
            setUpPickerView()
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
        stopAnimation()
        shapeLayerWorkTimer.strokeEnd = 0.0
        animation.toValue = 0
        animation.duration = CFTimeInterval(durationTimer)
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = true
        shapeLayerWorkTimer.add(animation, forKey: "startAnimation")
        shapeLayerBreakTimer.add(animation, forKey: "startAnimation")
        isAnimationStarted = true
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

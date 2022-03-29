//
//  ViewController.swift
//  GTimer
//
//  Created by Home on 5.03.22.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    var pickerView: UIPickerView = {
        var pickerView = UIPickerView()
        pickerView.backgroundColor = nil
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
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
    
    let timerWorkLabel = FactoryLabel.getTitleLabel(textTitleLabel: "01:00", sizeTitle: 50)
    let timerBreakLabel = FactoryLabel.getTitleLabel(textTitleLabel: "00:30", sizeTitle: 50)
    let workLabel = FactoryLabel.getTitleLabel(textTitleLabel: "Work", sizeTitle: 25)
    let breakLabel = FactoryLabel.getTitleLabel(textTitleLabel: "Break", sizeTitle: 25)
    let labelMinutes = FactoryLabel.getTitleLabel(textTitleLabel: "мин.", sizeTitle: 20)
    let labelSeconds = FactoryLabel.getTitleLabel(textTitleLabel: "сек.", sizeTitle: 20)
    
    
    lazy  var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        
        let colors: [UIColor] = [UIColor(named: "TimerColorWork")!, UIColor(named: "TimerColorBreak")!]
        pageControl.numberOfPages = views.count
        pageControl.currentPage = 0
        pageControl.backgroundColor = nil
        pageControl.preferredIndicatorImage = UIImage(named: "PageIndecator")
        //        pageControl.setIndicatorImage(UIImage(named: "PageIndecator"), forPage: 1)
        
        for x in 0..<views.count {
            if x == 0 {
                pageControl.currentPageIndicatorTintColor = colors[x]
            } else {
                pageControl.pageIndicatorTintColor = colors[x]
            }
        }
        
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
    
    var minutesNumbers = 0
    var secondsNumbers = 0
    
    lazy var durationTimerStarted: Int = {
        return minutesNumbers + secondsNumbers
    }()
    
    lazy var durationTimer: Int = {
        return durationTimerStarted
    }()
    
    var time: [Int] = Array(0...59)
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
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
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
            
            viewTimerWorked.addSubview(cercleTimerWorkImage)
            NSLayoutConstraint.activate([
                cercleTimerWorkImage.centerXAnchor.constraint(equalTo: viewTimerWorked.centerXAnchor),
                cercleTimerWorkImage.centerYAnchor.constraint(equalTo: viewTimerWorked.centerYAnchor),
                cercleTimerWorkImage.heightAnchor.constraint(equalToConstant: 400),
                cercleTimerWorkImage.widthAnchor.constraint(equalToConstant: 400)
            ])
            
            pickerView.reloadAllComponents()
            
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
        
        cercleTimerWorkImage.removeFromSuperview()
        
        viewTimerWorked.addSubview(pickerView)
        NSLayoutConstraint.activate([
            pickerView.centerXAnchor.constraint(equalTo: viewTimerWorked.centerXAnchor),
            pickerView.centerYAnchor.constraint(equalTo: viewTimerWorked.centerYAnchor),
            pickerView.heightAnchor.constraint(equalToConstant: 200),
            pickerView.widthAnchor.constraint(equalToConstant: viewTimerWorked.bounds.size.width - 100)
        ])
        
        stopAnimation()
        cancelButton.isEnabled = false
        cancelButton.alpha = 0.5
        timer.invalidate()
        durationTimer = durationTimerStarted
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
            durationTimer = durationTimerStarted
            isTimerStarted = false
            timerWorkLabel.text = formatTimer()
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

extension ViewController {
    
    func setConstraints() {
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 320),
            scrollView.heightAnchor.constraint(equalToConstant: 380),
        ])
        
        viewTimerWorked.addSubview(pickerView)
        NSLayoutConstraint.activate([
            pickerView.centerXAnchor.constraint(equalTo: viewTimerWorked.centerXAnchor),
            pickerView.centerYAnchor.constraint(equalTo: viewTimerWorked.centerYAnchor),
            pickerView.heightAnchor.constraint(equalToConstant: 200),
            pickerView.widthAnchor.constraint(equalToConstant: viewTimerWorked.bounds.size.width - 100)
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
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            startButton.heightAnchor.constraint(equalToConstant: 120),
            startButton.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        view.addSubview(cancelButton)
        NSLayoutConstraint.activate([
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            cancelButton.heightAnchor.constraint(equalToConstant: 30),
            cancelButton.widthAnchor.constraint(equalToConstant: 70)
        ])
        
        pickerView.addSubview(labelMinutes)
        NSLayoutConstraint.activate([
            labelMinutes.centerXAnchor.constraint(equalTo: pickerView.centerXAnchor, constant: -10),
            labelMinutes.centerYAnchor.constraint(equalTo: pickerView.centerYAnchor)
        ])
        
        pickerView.addSubview(labelSeconds)
        NSLayoutConstraint.activate([
            labelSeconds.centerXAnchor.constraint(equalTo: pickerView.centerXAnchor, constant: 90),
            labelSeconds.centerYAnchor.constraint(equalTo: pickerView.centerYAnchor)
        ])
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    //    var selectedRow: Int {
    //        return pickerView.selectedRow(inComponent: 0) // для чего он?
    //    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return time.count
        case 1:
            return time.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(time[row])"
        case 1:
            return "\(time[row])"
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case 0:
            minutesNumbers = (time[row] * 60)
            return  print("\(durationTimer)")
        case 1:
            secondsNumbers = (time[row])
            return print("\(durationTimer)")
        default:
            break
        }
        
    }
    
    //     возвращает расстояние между компонентами в ячейке
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100
    }
    
    // возвращает высоту ячейки
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerLabelNumbers = UILabel()
        pickerLabelNumbers.textColor = (row == pickerView.selectedRow(inComponent: component)) ? UIColor.white : UIColor.white
        pickerLabelNumbers.text = String(time[row])
        pickerLabelNumbers.textAlignment = .center
        pickerLabelNumbers.font = UIFont.systemFont(ofSize: 20)
        return pickerLabelNumbers
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadAllComponents()
    }
    
}



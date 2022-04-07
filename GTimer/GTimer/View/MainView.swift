//
//  MainView.swift
//  GTimer
//
//  Created by Home on 6.04.22.
//

import UIKit

final class MainView: UIView {
    
    let mainConctrollerView = MainViewController()
    
    var secNumber = SecIntArray()
    var minNumber = MinIntArray()

    var minutesNumbersStartedWorked = 0
    var secondsNumbersStartedWorked = 0

    lazy var durationTimerWorked = minutesNumbersStartedWorked + secondsNumbersStartedWorked
    
    var onClouserPageControl: (() -> Void)?
    var onClouserStartButton: (() -> Void)?
    var onClouserCancelButton: (() -> Void)?

    let pickerViewWorked = UIPickerView()
    let pickerViewBreak = UIPickerView()

    lazy var viewTimerWorked = FactoryView.getView()
    lazy var viewTimerBreak = FactoryView.getView()
    
    lazy var views = [viewTimerWorked, viewTimerBreak]
    
    let cercleTimerWorkImage = FactoryImage.getImage(named: "TimerCircel")
    let cercleTimerBreakImage = FactoryImage.getImage(named: "TimerCircel")
    
    let timerWorkLabel = FactoryLabel.getTitleLabel(textTitleLabel: "00:00", sizeTitle: 50)
    let timerBreakLabel = FactoryLabel.getTitleLabel(textTitleLabel: "00:00", sizeTitle: 50)
    let workLabel = FactoryLabel.getTitleLabel(textTitleLabel: "Work", sizeTitle: 25)
    let breakLabel = FactoryLabel.getTitleLabel(textTitleLabel: "Break", sizeTitle: 25)
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        let colors: [UIColor] = [UIColor(named: "TimerColorWork")!, UIColor(named: "TimerColorBreak")!]
        pageControl.numberOfPages = views.count
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
        scrollView.frame = self.bounds
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.contentSize = CGSize(width: self.frame.size.width * CGFloat(views.count), height: self.frame.size.height)
        for i in 0..<views.count {
            views[i].frame = CGRect(x: CGFloat(i) * self.frame.size.width, y: 120, width: self.frame.width, height: 400)
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(scrollView)
        self.addSubview(pageControl)
        setGradientLayer()
        setConstraints()
        setUpPickerViewWorked()
        setUpPickerViewBreak()
        pageControl.addTarget(self, action: #selector(self.pageControlDidChange), for: .valueChanged)
        startButton.addTarget(self, action: #selector(self.startButtonTaped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(self.cancelButtonTaped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func pageControlDidChange() {
        onClouserPageControl?()
    }
    
    @objc func startButtonTaped() {
        onClouserStartButton?()
    }
    
    @objc func cancelButtonTaped() {
        onClouserCancelButton?()
    }
    
    func setUpPickerViewWorked() {
        pickerViewWorked.frame.size.width = 240
        pickerViewWorked.layer.position = CGPoint(x: self.viewTimerWorked.frame.width/2, y:self.viewTimerWorked.frame.size.height/3)
        pickerViewWorked.reloadAllComponents()
        viewTimerWorked.addSubview(pickerViewWorked)
        pickerViewWorked.delegate = self
        pickerViewWorked.dataSource = self
    }
    
    func setUpPickerViewBreak() {
        pickerViewBreak.frame.size.width = 240
        pickerViewBreak.layer.position = CGPoint(x: self.viewTimerBreak.frame.width/2, y:self.viewTimerBreak.frame.size.height/3)
        pickerViewBreak.reloadAllComponents()
        viewTimerBreak.addSubview(pickerViewBreak)
        pickerViewBreak.delegate = self
        pickerViewBreak.dataSource = self
    }
    
    func setGradientLayer () {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor(named: "LightBlue")!.cgColor,
                                UIColor(named: "DarkBlue")!.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        self.layer.addSublayer(gradientLayer)
    }
}

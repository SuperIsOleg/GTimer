//
//  ViewController+Constraints.swift
//  GTimer
//
//  Created by Home on 4.04.22.
//

import UIKit

extension ViewController {
    
    func setConstraints() {
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 320),
            scrollView.heightAnchor.constraint(equalToConstant: 380),
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
    }
}

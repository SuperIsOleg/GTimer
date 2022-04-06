//
//  FirstView+UIScrollView.swift
//  GTimer
//
//  Created by Home on 4.04.22.
//

import UIKit

extension MainView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x) / Float(scrollView.frame.size.width)))
    }
}

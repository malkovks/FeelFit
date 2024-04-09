//
//  FFOnboardingPageViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 09.04.2024.
//

import UIKit

class FFOnboardingPageViewModel {
    
    let pageViewController: UIPageViewController
    
    init(pageViewController: UIPageViewController) {
        self.pageViewController = pageViewController
    }
    
    func changePageViewController(sender: UIPageControl, pages: [UIViewController]){
        pageViewController.setViewControllers(pages, direction: .forward, animated: true)
    }
    
    func closeOnboardingViewController(){
        UserDefaults.standard.setValue(true, forKey: "isOnboardingOpenedFirst")
        pageViewController.dismiss(animated: true)
    }
    
    func pageControlTimerProgress(_ progress: UIPageControlTimerProgress, shouldAdvanceToPage page: Int, pages: [UIViewController]) -> Bool{
        let nextPage = pages[page]
        pageViewController.setViewControllers([nextPage], direction: .forward, animated: true)
        return true
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], viewControllerPages pages: [UIViewController], pageControl: UIPageControl, transitionCompleted completed: Bool){
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.lastIndex(of: viewControllers[0]) else { return }
        
        pageControl.currentPage = currentIndex
    }
}

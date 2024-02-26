//
//  FFOnboardingPageViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 26.02.2024.
//

import UIKit

class FFOnboardingPageViewController: UIPageViewController, SetupViewController {
    
    let pageControl = UIPageControl()
    var pages = [UIViewController]()
    let initialPages = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc private func didTapPageControl(_ sender: UIPageControl){
        print("value changed \(sender.currentPage)")
        pageControl.currentPage = sender.currentPage
    }
    
   //Сделать фон мутным при помощи UIVisualBlurEffect
    
    func setupView() {
        
        view.backgroundColor = .systemBackground
        setupNavigationController()
        setupViewModel()
        setupPageController()
        setupConstraints()
        setupStyle()
    }
    
    func setupStyle(){
        pageControl.currentPageIndicatorTintColor = FFResources.Colors.activeColor
        pageControl.pageIndicatorTintColor = FFResources.Colors.darkPurple
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPages
    }
    
    func setupPageController(){
        dataSource = self
        delegate = self
        
        pageControl.addTarget(self, action: #selector(didTapPageControl), for: .primaryActionTriggered)
        pageControl.backgroundStyle = .prominent
        pageControl.progress = UIPageControlTimerProgress(preferredDuration: 5)
        
        let page1 = FFOnboardingViewController(imageName: "newspaper", pageTitle: "News", pageSubtitle: "Some subtitles for news page. will add later")
        let page2 = FFOnboardingViewController(imageName: "figure.strengthtraining.traditional", pageTitle: "Muscles", pageSubtitle: "Some subtitles for muscles section. Include exercises on primary humans muscles. ")
        let page3 = FFOnboardingViewController(imageName: "heart.text.square", pageTitle: "Health", pageSubtitle: "In this application, we use your data by importing it from the Health application. This data is primarily intended to more accurately track, regulate and control your health.\nAll data is encrypted and is not distributed anywhere.")
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        setViewControllers([pages[initialPages]], direction: .forward, animated: true)
    }
    
    func setupNavigationController() {
        
    }
    
    func setupViewModel() {
        
    }
}

extension FFOnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil}
        
        if index == 0 {
            return pages.last
        } else {
            return pages[index-1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil}
        if index < pages.count - 1  {
            return pages[index + 1]
        } else {
            return pages.first
        }
    }
}

extension FFOnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            
            guard let viewControllers = pageViewController.viewControllers else { return }
            guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
            
            pageControl.currentPage = currentIndex
        }
}


extension FFOnboardingPageViewController {
    private func setupConstraints(){
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(20)
        }
    }
}

#Preview {
    return FFOnboardingPageViewController()
}

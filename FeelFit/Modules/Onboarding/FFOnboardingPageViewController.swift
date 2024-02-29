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
    private let pageProgress = UIPageControlTimerProgress(preferredDuration: 10)
    private var suspensionTimer: Timer?
    private var isTimerPaused: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pageProgress.resumeTimer()
    }
    
    @objc private func didTapPageControl(_ sender: UIPageControl){
        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true)
    }
    
    @objc private func didTapPauseTimer(){
        print("Timer paused")
    }
    
   //Сделать фон мутным при помощи UIVisualBlurEffect
    
    func setupView() {
        
        view.backgroundColor = .systemBackground
        setupNavigationController()
        setupViewModel()
        setupPageController()
        setupConstraints()
        setupStyle()
        
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(didTapPressedGesture))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapPressedGesture(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            pageProgress.pauseTimer()
        } else if gesture.state == .ended || gesture.state == .cancelled{
            pageProgress.resumeTimer()
        }
        
    }
    
    private func pauseTimer(){
        if !isTimerPaused {
            suspensionTimer?.invalidate()
        } else {
            suspensionTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(didTapPauseTimer), userInfo: nil, repeats: true)
        }
    }
    
    private func resumeTimer(){
        
    }
    
    //MARK: - Setup onboarding page View controller
    func setupStyle(){
        pageControl.currentPageIndicatorTintColor = FFResources.Colors.activeColor
        pageControl.pageIndicatorTintColor = FFResources.Colors.darkPurple
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPages
        pageControl.addTarget(self, action: #selector(didTapPageControl), for: .primaryActionTriggered)
        pageControl.backgroundStyle = .automatic
        pageControl.direction = .leftToRight
        
        pageProgress.delegate = self
        pageProgress.resetsToInitialPageAfterEnd = true
        pageControl.progress = pageProgress
    }
    
    func setupPageController(){
        dataSource = self
        delegate = self
        
        
        
        let page1 = FFOnboardingViewController(imageName: "app.badge",
                                               pageTitle: "Notification",
                                               pageSubtitle: "This function necessary for sending You important system or your custom notifications if you already set up notification timer.",
                                               type: .notification)
        let page2 = FFOnboardingViewController(imageName: "photo.on.rectangle",
                                               pageTitle: "Media and Camera",
                                               pageSubtitle: "It use many files include media files which you especially using and creating. It allow you to use your own photos and creating new",
                                               type: .cameraAndLibrary)
        let page3 = FFOnboardingViewController(imageName: "heart.text.square",
                                               pageTitle: "Health",
                                               pageSubtitle: "In this application, we use Your data by importing it from the Health application. This data is primarily intended to more accurately track, regulate and control your health.\nAll data is encrypted and is not distributed anywhere.",
                                               type: .health)
        let page4 = FFOnboardingViewController(imageName: "lock.open.iphone",
                                               pageTitle: "Background task",
                                               pageSubtitle: "This page include information about background tasks, it collect some data for fastest and comfortable usage while application is unused or phone is locked",
                                               type: .none)
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        pages.append(page4)
        
        setViewControllers([pages[initialPages]], direction: .forward, animated: true)
    }
    
    func setupNavigationController() {
        
    }
    
    func setupViewModel() {
        
    }
}

extension FFOnboardingPageViewController: UIPageControlTimerProgressDelegate {
    func pageControlTimerProgress(_ progress: UIPageControlTimerProgress, shouldAdvanceToPage page: Int) -> Bool {
        let nextPage = pages[page]
        self.setViewControllers([nextPage], direction: .forward, animated: true)
        return true
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
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pageProgress.pauseTimer()
        suspensionTimer?.invalidate()
        
        suspensionTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: false, block: { _ in
            self.pageProgress.resumeTimer()
        })
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

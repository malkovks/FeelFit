//
//  FFOnboardingPageViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 26.02.2024.
//

import UIKit

class FFOnboardingPageViewController: UIPageViewController, SetupViewController {
    
    private let pageControl = UIPageControl()
    private var nextPageButton = UIButton(type: .custom)
    
    private var pages = [UIViewController]()
    private let initialPages = 0
    private var currentIndex = 0
    private var suspensionTimer: Timer?
    private var isTimerPaused: Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc private func didTapPageControl(_ sender: UIPageControl){
        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true)
    }

    @objc private func didTapDismissOnboarding(){
        UserDefaults.standard.setValue(true, forKey: "isOnboardingOpenedFirst")
        self.dismiss(animated: true)
    }
    
    @objc private func didTapSkipOnboarding(){
        UserDefaults.standard.setValue(true, forKey: "isOnboardingOpenedFirst")
        self.dismiss(animated: true)
    }
    
   //Сделать фон мутным при помощи UIVisualBlurEffect
    
    func setupView() {
        view.backgroundColor = .systemBackground
        
        setupNavigationController()
        setupViewModel()
        setupPageViewController()
        setupPageControl()
        setupNextPageButton()
        setupConstraints()
        
    }
    //Доделать функцию переключения страницы по кнопке
    @objc private func didTapNextPage() {
        var currentIndex = pageControl.currentPage
        let pagesCount = pages.count-1
            
        
        if currentIndex != pagesCount {
            currentIndex += 1
            pageControl.currentPage = currentIndex
            self.setViewControllers([pages[currentIndex]], direction: .forward, animated: true)
            if currentIndex == pagesCount {
                nextPageButton.configuration?.title = "Let's start"
            }
        }
    }
    
    //MARK: - Setup onboarding page View controller
    private func setupNextPageButton(){
        nextPageButton.configuration = .filled()
        nextPageButton.configuration?.baseBackgroundColor = .systemBlue
        nextPageButton.configuration?.title = "Next"
        nextPageButton.addTarget(self, action: #selector(didTapNextPage), for: .primaryActionTriggered)
    }
    
    private func setupPageControl(){
        pageControl.currentPageIndicatorTintColor = FFResources.Colors.activeColor
        pageControl.pageIndicatorTintColor = FFResources.Colors.darkPurple
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPages
        pageControl.addTarget(self, action: #selector(didTapPageControl), for: .primaryActionTriggered)
        pageControl.backgroundStyle = .automatic
        pageControl.direction = .leftToRight
        
    }
    
    private func setupPageViewController(){
        dataSource = self
        delegate = self
        
        
        
        let page1 = FFOnboardingViewController(imageName: "lock.square",
                                               pageTitle: "Access to sensitive information",
                                               pageSubtitle: "This page displays the services that this application uses. Data from these services is intended for the correct and more detailed operation of the application, and this data will be protected and will not be accessible to anyone except you. If you want to change access to any service, you can always do this in the system Settings application.")
        let page2 = FFOnboardingAuthenticationViewController()
        page2.delegate = self
        let page3 = FFOnboardingUserDataViewController()
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        currentIndex = pages.count
        
        setViewControllers([pages[initialPages]], direction: .forward, animated: true)
    }
    
    func setupNavigationController() { }
    
    func setupViewModel() {}
}

extension FFOnboardingPageViewController: FFOnboardingActionsDelegate {
    
    func didTapSkipRegistration() {
        dismiss(animated: true)
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
        }
        return nil
    }
}

extension FFOnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            
            guard let viewControllers = pageViewController.viewControllers else { return }
            guard let currentIndex = pages.lastIndex(of: viewControllers[0]) else { return }
            
            pageControl.currentPage = currentIndex
    }
}


extension FFOnboardingPageViewController {
    private func setupConstraints(){
        let userInterfaceStackView = UIStackView(arrangedSubviews: [pageControl, nextPageButton])
        userInterfaceStackView.axis = .vertical
        userInterfaceStackView.spacing = 10
        userInterfaceStackView.alignment = .center
        userInterfaceStackView.distribution = .fillProportionally
        
        view.addSubview(userInterfaceStackView)
        userInterfaceStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
            make.bottom.equalToSuperview().multipliedBy(0.95)
            make.width.equalToSuperview().dividedBy(2)
        }
    }
}

#Preview {
    let navVC = FFNavigationController(rootViewController: FFOnboardingPageViewController())
    navVC.modalTransitionStyle = .coverVertical
    navVC.isNavigationBarHidden = true
    navVC.modalPresentationStyle = .fullScreen
    return navVC
}

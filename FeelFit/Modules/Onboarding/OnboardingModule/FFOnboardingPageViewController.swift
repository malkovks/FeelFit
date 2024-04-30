//
//  FFOnboardingPageViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 26.02.2024.
//

import UIKit

class FFOnboardingPageViewController: UIPageViewController {
    
    var isDisplayServicesAccess: Bool = true
    
    var nextPageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.configuration = .filled()
        button.configuration?.baseBackgroundColor = .systemBlue
        button.configuration?.title = "Next"
        return button
    }()
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl(frame: .zero)
        pageControl.currentPageIndicatorTintColor = FFResources.Colors.activeColor
        pageControl.pageIndicatorTintColor = FFResources.Colors.darkPurple
        pageControl.backgroundStyle = .automatic
        pageControl.direction = .leftToRight
        return pageControl
    }()
    private var skipOnboardingButton = UIButton(type: .custom)
    private var xmarkButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "xmark")?.withConfiguration(UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        button.tintColor = .darkGray
        return button
    }()
    
    private let onboardingStackView: UIStackView = {
        let userInterfaceStackView = UIStackView(frame: .zero)
        userInterfaceStackView.axis = .vertical
        userInterfaceStackView.spacing = 10
        userInterfaceStackView.alignment = .center
        userInterfaceStackView.distribution = .fillProportionally
        return userInterfaceStackView
    }()
    
    private var pages = [UIViewController]()
    private let initialPages = 0
    private var currentIndex = 0
    private var viewModel: FFOnboardingPageViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    //MARK: - Action methods
    @objc private func didTapPageControl(_ sender: UIPageControl){
        
        viewModel.changePageViewController(sender: sender, pages: self.pages)
    }
    
    @objc private func didTapDismissOnboarding(){
        viewModel.closeOnboardingViewController()
    }
    
    @objc private func didTapNextPage() {
        var currentIndex = pageControl.currentPage
        let pagesCount = pages.count-1
        
        
        if currentIndex != pagesCount {
            currentIndex += 1
            pageControl.currentPage = currentIndex
            self.setViewControllers([pages[currentIndex]], direction: .forward, animated: true)
            if currentIndex == pagesCount {
                toggleButtonsHidden()
            }
        }
    }
    
    private func toggleButtonsHidden(){
        DispatchQueue.main.async { [unowned self ] in
            UIView.animate(withDuration: 0.2) {
                self.nextPageButton.isHidden.toggle()
                self.skipOnboardingButton.isHidden.toggle()
            }
        }
    }
}

    //MARK: - Setup onboarding page View controller
extension FFOnboardingPageViewController: SetupViewController {
    func setupView() {
        view.backgroundColor = .systemBackground
        
        setupNavigationController()
        setupViewModel()
        setupPageViewController()
        setupPageControl()
        setupNextPageButton()
        setupSkipOnboardingPageButton()
        setupConstraints()
        setupXmarkButton()
    }
    
    private func setupNextPageButton(){
        
        nextPageButton.addTarget(self, action: #selector(didTapNextPage), for: .primaryActionTriggered)
    }
    
    private func setupXmarkButton(){
        xmarkButton.addTarget(self, action: #selector(didTapDismissOnboarding), for: .primaryActionTriggered)
    }
    
    private func setupSkipOnboardingPageButton(){
        skipOnboardingButton.isHidden = true
        skipOnboardingButton.configuration = .filled()
        skipOnboardingButton.configuration?.baseBackgroundColor = .main
        skipOnboardingButton.configuration?.title = "Lets Start"
        skipOnboardingButton.addTarget(self, action: #selector(didTapDismissOnboarding), for: .primaryActionTriggered)
    }
    
    private func setupPageControl(){
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPages
        pageControl.addTarget(self, action: #selector(didTapPageControl), for: .primaryActionTriggered)
    }
    
    private func setupPageViewController(){
        dataSource = self
        delegate = self
        
        let page1 = FFOnboardingAccessViewController(imageName: "lock.square",
                                               pageTitle: "Access to sensitive information",
                                               pageSubtitle: "This page displays the services that this application uses. Data from these services is intended for the correct and more detailed operation of the application, and this data will be protected and will not be accessible to anyone except you. If you want to change access to any service, you can always do this in the system Settings application.")
        let page2 = FFOnboardingAuthenticationViewController()
        let page3 = FFOnboardingUserDataViewController()
        
        if isDisplayServicesAccess {
            pages.append(page1)
        }
        
        
        pages.append(page2)
        pages.append(page3)
        currentIndex = pages.count
        
        setViewControllers([pages[initialPages]], direction: .forward, animated: true)
    }
    
    func setupNavigationController() { }
    
    func setupViewModel() {
        viewModel = FFOnboardingPageViewModel(pageViewController: self)
    }
    
    private func isEndWorkWithOnboarding(isHidden: Bool){
        nextPageButton.isHidden = !isHidden
        skipOnboardingButton.isHidden = isHidden
    }
}

extension FFOnboardingPageViewController: UIPageControlTimerProgressDelegate {
    func pageControlTimerProgress(_ progress: UIPageControlTimerProgress, shouldAdvanceToPage page: Int) -> Bool {
        viewModel.pageControlTimerProgress(progress, shouldAdvanceToPage: page, pages: pages)
    }
}


extension FFOnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil}
        
        if index == 0 {
            return nil
        } else if index != pages.count {
            isEndWorkWithOnboarding(isHidden: false)
            return pages[index-1]
        } else {
            isEndWorkWithOnboarding(isHidden: true)
            return pages[index-1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController) else { return nil}
        if index < pages.count - 1  {
            isEndWorkWithOnboarding(isHidden: true)
            return pages[index + 1]
        } else if index == pages.count-1 {
            isEndWorkWithOnboarding(isHidden: true)
            return nil
        } else {
            isEndWorkWithOnboarding(isHidden: false)
            return nil
        }
        
    }
}

extension FFOnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        viewModel.pageViewController(pageViewController, didFinishAnimating: finished, previousViewControllers: previousViewControllers, viewControllerPages: pages, pageControl: pageControl, transitionCompleted: completed)
    }
}


extension FFOnboardingPageViewController {
    private func setupConstraints(){
        let userElements = [pageControl, nextPageButton, skipOnboardingButton]
        userElements.forEach { controls in
            onboardingStackView.addArrangedSubview(controls)
        }
        
        view.addSubview(onboardingStackView)
        onboardingStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.1)
            make.bottom.equalToSuperview().multipliedBy(0.95)
            make.width.equalToSuperview().dividedBy(2)
        }
        
        view.addSubview(xmarkButton)
        xmarkButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(40)
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

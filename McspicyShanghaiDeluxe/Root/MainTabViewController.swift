//
//  MainTabViewController.swift
//  McspicyShanghaiDeluxe
//
//  Created by 조아라 on 7/2/24.
//

import UIKit


enum PresentationContext {
    case fromFirstVC
    case fromSecondVCCell
    case fromSecondVCAddButton
}


class MainTabController: UITabBarController, UITabBarControllerDelegate {
    let movingView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(.white)
        configureViewControllers()
        
        tabBar.tintColor = UIColor(.yellow)
        tabBar.unselectedItemTintColor = UIColor(.white)
        
        movingView.backgroundColor = UIColor(.gray)
        movingView.frame = CGRect(x: 0, y: 0, width: 6, height: 6)
        movingView.layer.cornerRadius = movingView.frame.size.width / 2
        movingView.clipsToBounds = true
        tabBar.addSubview(movingView)
        
        DispatchQueue.main.async {
            self.setInitialMovingViewPosition()
        }
    }
    
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = nav.navigationBar.standardAppearance

        return nav
    }
    
    func configureViewControllers() {
        let firstVC = IndexViewController()
//        let secondVC = SecondViewController()
        
        let nav1 = templateNavigationController(image: UIImage(systemName: "banknote"), rootViewController: firstVC)
//        let nav2 = templateNavigationController(image: UIImage(systemName: "capsule.fill"), rootViewController: secondVC)
//        
        nav1.tabBarItem.title = "Currency"
//        nav2.tabBarItem.title = "Index"
//        firstVC.delegate = secondVC
        viewControllers = [nav1, /*nav2*/]
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)

            //Reference from https://stackoverflow.com/a/71162696
            let buttons = self.tabBar.subviews.filter { subview in
                String(describing: type(of: subview)) == "UITabBarButton"
            }
            
            buttons.forEach { button in
                button.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    button.centerYAnchor.constraint(equalTo: self.tabBar.topAnchor, constant: 33),
                    button.heightAnchor.constraint(equalToConstant: button.frame.height),
                    button.widthAnchor.constraint(equalToConstant: button.frame.width),
                    button.leadingAnchor.constraint(equalTo: self.tabBar.leadingAnchor, constant: button.frame.minX)
                ])
            }
        }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = self.tabBar.items?.firstIndex(of: item) else { return }
        
        let subviews = tabBar.subviews.filter({ $0 is UIControl })
        guard subviews.count > index else { return }
        
        let x = subviews[index].center.x - movingView.frame.width / 2
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.movingView.frame.origin.x = x
        }, completion: nil)
    }
    
    func setInitialMovingViewPosition() {
        guard let items = tabBar.items, items.count > 0 else { return }
        let subviews = tabBar.subviews.filter({ $0 is UIControl })
        guard subviews.count > 0 else { return }
        
        let firstItemView = subviews[0]
        let initialX = firstItemView.center.x - movingView.frame.width / 2
        self.movingView.frame.origin.x = initialX
    }
}

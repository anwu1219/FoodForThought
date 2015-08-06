//
//  SignupInstructionViewController.swift
//  Foodscape
//
//  Created by Wu, Andrew on 7/28/15.
//  Copyright (c) 2015 Davidson College. All rights reserved.
//

import UIKit

class SignupInstructionViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        
        var dishes: Dishes!
        private let images = ["instruction1","instruction2","instruction3","instruction4"]
        private var count = 0
        private var isFromMain : Bool?
        var pageViewController : UIPageViewController!
    
        @IBAction func swiped(sender: AnyObject) {
            
            self.pageViewController.view .removeFromSuperview()
            self.pageViewController.removeFromParentViewController()
            reset()
        }
        
        func reset() {
            /* Getting the page View controller */
            pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
            self.pageViewController.dataSource = self
            
            let pageContentViewController = self.viewControllerAtIndex(0)
            self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
            

            self.pageViewController.view.frame = CGRectMake(0, 0, UIScreen.mainScreen().applicationFrame.width, UIScreen.mainScreen().applicationFrame.height)
            self.addChildViewController(pageViewController)
            self.view.addSubview(pageViewController.view)
            self.pageViewController.didMoveToParentViewController(self)
            
            self.view.backgroundColor = UIColor.blackColor()
            
            
            let appearance = UIPageControl.appearance()
            appearance.pageIndicatorTintColor = UIColor.grayColor()
            appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
            appearance.backgroundColor = UIColor.darkGrayColor()
            
    }
        
        @IBAction func start(sender: AnyObject) {
            let pageContentViewController = self.viewControllerAtIndex(0)
            self.pageViewController.setViewControllers([pageContentViewController!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            reset()
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
            
            var index = (viewController as! PageContentViewController).pageIndex!
            index++
            if(index == self.images.count){
                sleep(1)
                self.dismissViewControllerAnimated(true, completion: { () -> Void in})
            }
            return self.viewControllerAtIndex(index)
            
        }
        
        func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
            
            var index = (viewController as! PageContentViewController).pageIndex!
            if(index == 0){
                return nil
            }
            index--
            return self.viewControllerAtIndex(index)
            
        }
        
        func viewControllerAtIndex(index : Int) -> UIViewController? {
            if((self.images.count == 0) || (index >= self.images.count)) {
                return nil
            }
            let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageContentViewController") as! PageContentViewController
            
            pageContentViewController.imageName = self.images[index]
            pageContentViewController.pageIndex = index
            return pageContentViewController
        }
        
        func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
            return images.count
        }
        
        func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
            return 0
        }
    
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = true
        super.viewWillAppear(animated)
    }
    
    
        func fromMain(){
            self.isFromMain = true
        }
        
}


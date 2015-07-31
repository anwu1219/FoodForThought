//
//  signupInstructionViewController.swift
//  Foodscape
//
//  Created by Wu, Andrew on 7/28/15.
//  Copyright (c) 2015 Davidson College. All rights reserved.
//

import UIKit

class SignupInstructionViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        
        var dishes: Dishes!
        let pageTitles = ["Title 1", "Title 2", "Title 3", "Title 4"]
        var images = ["sloth","sloth","sloth","sloth"]
        var count = 0
        var isFromMain : Bool?
        
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
            
            /* We are substracting 30 because we have a start again button whose height is 30*/
            self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height - 30)
            self.addChildViewController(pageViewController)
            self.view.addSubview(pageViewController.view)
            self.pageViewController.didMoveToParentViewController(self)
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
            if((self.pageTitles.count == 0) || (index >= self.pageTitles.count)) {
                return nil
            }
            let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageContentViewController") as! PageContentViewController
            
            pageContentViewController.imageName = self.images[index]
            pageContentViewController.titleText = self.pageTitles[index]
            pageContentViewController.pageIndex = index
            return pageContentViewController
        }
        
        func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
            return pageTitles.count
        }
        
        func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
            return 0
        }
        
        
        func fromMain(){
            self.isFromMain = true
        }
        
}


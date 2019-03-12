//
//  PageViewController.swift
//  NASAoftheDay
//
//  Created by Sam Owen on 12/02/2019.
//  Copyright © 2019 EskiSoftware. All rights reserved.
//

import Foundation
import UIKit

class PageViewController: UIPageViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        dataSource = self;
        
        let firstView : PageContentViewController = viewControllerAtDate(index: 0);
        
        setViewControllers([firstView], direction: .forward, animated: true, completion: nil);
    }
    
    // index is the number of days before todays date
    func viewControllerAtDate(index : Int) -> PageContentViewController {
        let pageContentViewController : PageContentViewController = self.storyboard!.instantiateViewController(withIdentifier: "PageContentViewController") as! PageContentViewController;
        
        pageContentViewController.dateOffset = index
        
        return pageContentViewController;
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // This is the index of the page we a navigating away from
        let index : Int = (viewController as! PageContentViewController).dateOffset;
        
        // If it's zero, there's no page before, return nil
        if (index == NSNotFound) {
            return nil;
        }
        
        return self.viewControllerAtDate(index: index - 1);
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index : Int = (viewController as! PageContentViewController).dateOffset
        
        // Not found? nil.
        if (index == NSNotFound) {
            return nil
        }
        
        // Increment, as that'll be the index of the next page
        index += 1;
        
        // Can't go past todays date
        if (index > 0) {
            return nil
        }
        
        return self.viewControllerAtDate(index: index);
    }
}


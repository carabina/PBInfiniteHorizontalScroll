//
//  PBnfiniteHorizontalScrollViewController.swift
//  PBInfiniteHorizontalScroll
//
//  Created by 김성민 on 2016. 11. 25..
//  Copyright © 2016년 CocoaPods. All rights reserved.
//

import UIKit


public protocol PBInfiniteHorizontalScrollViewControllerDelegate {

    func willShowViewControllerAtIndex(scrollViewController : PBInfiniteHorizontalScrollViewController, index : UInt) //this function does not guarantee that didShowViewControllerAtIndex() is executed for the index. User can cancel the dragging.

    func didShowViewControllerAtIndex(scrollViewController : PBInfiniteHorizontalScrollViewController, index : UInt)


}

public protocol PBInfiniteHorizontalScrollViewControllerDataSource {

    func numberOfViewControllers(scrollViewController : PBInfiniteHorizontalScrollViewController) -> UInt

    func indexOfViewController(scrollViewController : PBInfiniteHorizontalScrollViewController, viewController : UIViewController) -> UInt

    func viewControllerAtIndex(scrollViewController : PBInfiniteHorizontalScrollViewController, index : UInt) -> UIViewController

}






public class PBInfiniteHorizontalScrollViewController: UIViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource {


    public var delegate : PBInfiniteHorizontalScrollViewControllerDelegate!
    public var dataSource : PBInfiniteHorizontalScrollViewControllerDataSource!

    public var currentIndex : UInt?


    public func scrollToIndex(index : UInt, animated: Bool, completion: ((Bool) -> Void)?){

        let direction : UIPageViewControllerNavigationDirection

        if self.pageViewController.viewControllers?.count != 0 {

            let current = self.dataSource.indexOfViewController(scrollViewController: self, viewController: self.pageViewController.viewControllers![0])
            let next = index

            if (Int(next) - Int(current)) > 0 {
                direction = .forward
            }else{
                direction = .reverse
            }

        }else{

            direction = .forward

        }

        let startingViewControllers = [self.dataSource!.viewControllerAtIndex(scrollViewController: self, index: index)]

        self.pageViewController.setViewControllers(startingViewControllers, direction: direction, animated: animated, completion:{

            (completed) in

            self.pageViewController(self.pageViewController, willTransitionTo:startingViewControllers)

            self.pageViewController(self.pageViewController, didFinishAnimating: true, previousViewControllers: [], transitionCompleted: true)

            if completion != nil {

                completion!(completed)

            }


        })

    }


    public func reloadData(){

        guard self.dataSource != nil else {
            return
        }

        if self.pageViewController == nil {

            self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)

            self.addChildViewController(self.pageViewController!)
            self.view.addSubview(self.pageViewController!.view)
            self.pageViewController!.view.frame = self.view.bounds

            self.view.translatesAutoresizingMaskIntoConstraints = false
            self.pageViewController?.view.translatesAutoresizingMaskIntoConstraints = false

            self.view.addConstraints(
                [NSLayoutConstraint(item: self.view, attribute: .top, relatedBy: .equal, toItem: self.pageViewController!.view, attribute: .top, multiplier: 1, constant: 0),
                 NSLayoutConstraint(item: self.view, attribute: .leading, relatedBy: .equal, toItem: self.pageViewController!.view, attribute: .leading, multiplier: 1, constant: 0),
                 NSLayoutConstraint(item: self.view, attribute: .trailing, relatedBy: .equal, toItem: self.pageViewController!.view, attribute: .trailing, multiplier: 1, constant: 0),
                 NSLayoutConstraint(item: self.view, attribute: .bottom, relatedBy: .equal, toItem: self.pageViewController!.view, attribute: .bottom, multiplier: 1, constant: 0)])

        }

        self.pageViewController!.dataSource = self
        self.pageViewController!.delegate = self

        self.pageViewController!.didMove(toParentViewController: self)

        if currentIndex == nil {
            currentIndex = 0
        }

        scrollToIndex(index: currentIndex!, animated: false, completion: nil)




    }













    private var pageViewController : UIPageViewController!

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?{


        let i = self.dataSource.indexOfViewController(scrollViewController: self, viewController: viewController)

        if i == 0 {
            return self.dataSource.viewControllerAtIndex(scrollViewController: self,
                                                         index: (self.dataSource.numberOfViewControllers(scrollViewController: self) - 1))


        } else {

            return self.dataSource.viewControllerAtIndex(scrollViewController: self, index: i - 1)
        }

    }


    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{

        let i = self.dataSource.indexOfViewController(scrollViewController: self, viewController: viewController)

        return self.dataSource.viewControllerAtIndex(scrollViewController: self, index: (i + 1) % (self.dataSource.numberOfViewControllers(scrollViewController: self)))


    }

    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]){


        if let d = self.delegate {
            d.willShowViewControllerAtIndex(scrollViewController : self,
                                            index :
                self.dataSource.indexOfViewController(scrollViewController: self, viewController: pendingViewControllers.last!))

        }
    }


    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){

        if completed, let d = self.delegate {

            currentIndex = self.dataSource.indexOfViewController(scrollViewController: self, viewController: pageViewController.viewControllers![0])


            d.didShowViewControllerAtIndex(scrollViewController : self,
                                           index : currentIndex!)
            
            
        }
        
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

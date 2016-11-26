//
//  ViewController.swift
//  PBInfiniteHorizontalScroll
//
//  Created by Sungmin Kim on 11/25/2016.
//  Copyright (c) 2016 Sungmin Kim. All rights reserved.
//

import UIKit
import PBInfiniteHorizontalScroll

class ViewController: UIViewController,PBInfiniteHorizontalScrollViewControllerDataSource,PBInfiniteHorizontalScrollViewControllerDelegate {





    @IBOutlet var containerView: UIView!

    let infiniteHorizontalScrollViewController = PBInfiniteHorizontalScrollViewController()

    let viewControllers = [UIViewController(), UIViewController(), UIViewController()]

    public func didShowViewControllerAtIndex(scrollViewController: PBInfiniteHorizontalScrollViewController, index: UInt) {
        print("did show \(index)")
    }

    func willShowViewControllerAtIndex(scrollViewController : PBInfiniteHorizontalScrollViewController, index : UInt){

        print("will show \(index)")

    }


    @IBAction func buttonClicked(_ sender: Any) {


        self.infiniteHorizontalScrollViewController.scrollToIndex(index: 1, animated: true, completion: nil)

    }
    func numberOfViewControllers(scrollViewController : PBInfiniteHorizontalScrollViewController) -> UInt{
        return 3
    }

    func indexOfViewController(scrollViewController : PBInfiniteHorizontalScrollViewController, viewController : UIViewController) -> UInt
    {
        return UInt(viewController.view.tag)
    }
    func viewControllerAtIndex(scrollViewController : PBInfiniteHorizontalScrollViewController, index : UInt) -> UIViewController{
        let u = viewControllers[Int(index)]

        u.view.tag = Int(index)
        
        switch index {
        case 0:  u.view.backgroundColor = UIColor.red
        case 1:  u.view.backgroundColor = UIColor.blue
        case 2:  u.view.backgroundColor = UIColor.green
        default: break
        }


        return u;

    }

    override func viewDidLoad() {
        super.viewDidLoad()




        addChildViewController(infiniteHorizontalScrollViewController)

        self.containerView.addSubview(infiniteHorizontalScrollViewController.view)

        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        infiniteHorizontalScrollViewController.view.translatesAutoresizingMaskIntoConstraints = false

        self.containerView.addConstraints(
            [NSLayoutConstraint(item: self.containerView, attribute: .top, relatedBy: .equal, toItem: infiniteHorizontalScrollViewController.view, attribute: .top, multiplier: 1, constant: 0),
             NSLayoutConstraint(item: self.containerView, attribute: .leading, relatedBy: .equal, toItem: infiniteHorizontalScrollViewController.view, attribute: .leading, multiplier: 1, constant: 0),
             NSLayoutConstraint(item: self.containerView, attribute: .trailing, relatedBy: .equal, toItem: infiniteHorizontalScrollViewController.view, attribute: .trailing, multiplier: 1, constant: 0),
             NSLayoutConstraint(item: self.containerView, attribute: .bottom, relatedBy: .equal, toItem: infiniteHorizontalScrollViewController.view, attribute: .bottom, multiplier: 1, constant: 0)])


        infiniteHorizontalScrollViewController.dataSource = self
        infiniteHorizontalScrollViewController.delegate = self
        
        infiniteHorizontalScrollViewController.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


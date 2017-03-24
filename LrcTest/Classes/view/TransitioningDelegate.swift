//
//  ClockPresentationViewController.swift
//  LrcTest
//
//  Created by pengyucheng on 21/03/2017.
//  Copyright © 2017 PBBReader. All rights reserved.
//

import UIKit

//交互动画，展示过程的过渡动画设计
class ClockPresentationViewController: UIPresentationController,UIAdaptivePresentationControllerDelegate
{
    //登场视图的背景
    var chromeView: UIView = UIView()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?)
    {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        //登场视图的背景样式
        chromeView.backgroundColor = UIColor.init(white: 0.0, alpha: 0.4)
        chromeView.alpha = 0.0
        //退场手势
        let chromeViewTap = UITapGestureRecognizer.init(target: self, action: #selector(ClockPresentationViewController.chromeViewTapped(_:)))
        chromeView.addGestureRecognizer(chromeViewTap)
    }
    
    //点击执行退场动画
    @objc func chromeViewTapped(_ gesture:UITapGestureRecognizer)
    {
        if gesture.state == .ended
        {
            presentingViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    //重载存储属性：get方法返回登场页面的位置和大小
    override var frameOfPresentedViewInContainerView: CGRect
    {
        var presentViewFrame = CGRect.zero
        let containerBounds = containerView?.bounds
        //登场控制器内容页面的大小
        presentViewFrame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: (containerBounds?.size)!)
        presentViewFrame.origin.y = (containerBounds?.size.height)! - presentViewFrame.size.height
        return presentViewFrame
    }
    
    //返回登场控制器内容页面的大小，在这里设置为屏幕高度的三分之一款
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        
        return CGSize.init(width:parentSize.width, height: 352.0)
//        return CGSize.init(width:parentSize.width, height: CGFloat(floorf(Float(parentSize.height/2.0))))
    }
    
    /*
     转场开始时
     animate(alongsideTransition:completion:)：转场协调器确保了转场与过渡动画同步进行
     1. 添加过渡视图：在containerView中插入视图chromeView
     2. 添加转场动画:为转场中涉及到的视图（chromeView）
     */
    override func presentationTransitionWillBegin() {
        //
        chromeView.frame = (self.containerView?.bounds)!
        chromeView.alpha = 0.0
        containerView?.insertSubview(chromeView, at:0)
        //coordinator转场协调器负责转场动画的呈现和dismissal
        let coordinator = presentedViewController.transitionCoordinator
        if (coordinator != nil) {
            //添加登场动画
            coordinator!.animate(alongsideTransition: {
                (context:UIViewControllerTransitionCoordinatorContext!) -> Void in
                //animate the alpha to 1.0.
                self.chromeView.alpha = 1.0
            }, completion:nil)
            
        } else {
            chromeView.alpha = 1.0
        }
    }
    
    
    /*
     转场结束时
     1. 添加消失时转场动画
     */
    override func dismissalTransitionWillBegin()
    {
        let coordinator = presentedViewController.transitionCoordinator
        if (coordinator != nil) {
            //添加退场动画
            coordinator!.animate(alongsideTransition: {
                (context:UIViewControllerTransitionCoordinatorContext!) -> Void in
                self.chromeView.alpha = 0.0
            }, completion:nil)
        } else {
            chromeView.alpha = 0.0
        }
    }
    
    //在设备旋转的情况下，重置背景视图的外观和登场控制器内容的外观
    override func containerViewWillLayoutSubviews()
    {
        chromeView.frame = (containerView?.bounds)!
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    //设置整个转场动画是否将覆盖全屏幕
    override var shouldPresentInFullscreen: Bool
    {
        return false
    }
    
    /*
     两种覆盖全屏的方式：
     1. .OverFullScreen: 浮动式全屏，即：登场视图下方的视图不会完全被遮挡
     2. .FullScreen  : 全覆盖全屏 即：占据全屏来显示登场视图
     */
    
    override var adaptivePresentationStyle: UIModalPresentationStyle
    {
        return UIModalPresentationStyle.custom
    }
}

public class nav:NSObject,UINavigationControllerDelegate
{
    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        //
        return nil
        
    }
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return nil
    }
    
}
@objc(ClockTransitioningDelegate)
public class ClockTransitioningDelegate: NSObject,UIViewControllerTransitioningDelegate
{
    //returns a presentation controller that manages the presentation of a view controller.
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        //presentation动画控制器
        let presentationController = ClockPresentationViewController(presentedViewController:presented, presenting:presenting)
        
        return presentationController
    }
    //returns an animator object that will be used when a view controller is being presented
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //开始登场
        let animationController = ClockAnimatedTransitioning()
        animationController.isPresentation = true
        return animationController
        
    }
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        //退场开始
        let animationController = ClockAnimatedTransitioning()
        animationController.isPresentation = false
        return animationController
    }
}

class ClockAnimatedTransitioning: NSObject,UIViewControllerAnimatedTransitioning
{
    //used to determine if the presentation animation is presenting (as opposed to dismissing).
    var isPresentation : Bool = false
    
    //returns the duration in seconds of the transition animation.
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        //返回动画时间
        return 0.5
    }
    
    //get the respective views of these view controllers.
    //Next we get the container view and if the presentation animation is presenting, we add the to view to the container view.
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        //get the from and to view controllers from the UIViewControllerContextTransitioning object.
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        //determine the start and end positions of the view.
        let fromView = fromVC?.view
        let toView = toVC?.view
        let containerView = transitionContext.containerView
        
        if isPresentation {
            containerView.addSubview(toView!)
        }
        //decide on which view controller to animate based on whether the transition is a presentation or dismissal
        let animatingVC = isPresentation ? toVC : fromVC
        let animatingView = animatingVC?.view
        
        let finalFrameForVC = transitionContext.finalFrame(for: animatingVC!)
        //This will animate the view from right to left during a presentation and vice versa during dismissal.
//        initialFrameForVC.origin.x += initialFrameForVC.size.width
        //定义由下向上
        var initialFrameForVC = finalFrameForVC
        initialFrameForVC.origin.y += initialFrameForVC.size.height
        
        let initialFrame = isPresentation ? initialFrameForVC : finalFrameForVC
        let finalFrame = isPresentation ? finalFrameForVC : initialFrameForVC
        
        animatingView?.frame = initialFrame
        //根据协议中的方法获取动画的时间。
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay:0, usingSpringWithDamping:300.0, initialSpringVelocity:5.0, options:UIViewAnimationOptions.allowUserInteraction, animations:{
            
            //we move the view to the final position.
            animatingView?.frame = finalFrame
            
        }, completion:{ (value: Bool) in
            
            //在退场结束时，从操场移除toView（退场时为fromView）
            if !self.isPresentation {
                //If the transition is a dismissal, we remove the view.
//                fromView?.removeFromSuperview()
            }
            //we complete the transition by calling transitionContext.completeTransition()
            transitionContext.completeTransition(true)
        })
    }
}


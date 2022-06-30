//
//  ViewController.swift
//  ExampleVideoCallUI
//
//  Created by Azhar Anwar on 30/06/22.
//

import UIKit
import VideoCallUI

class ViewController: UIViewController, VideoCallControllerDelegate {
  func teleCallController(callController controller: VideoCallController, didTapBack tappedBack: Bool) {
    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut) {
      
      let newFrame = self.isVideoViewSmall ?
        CGRect(origin: self.bigOrigin, size: self.bigSize) :
        CGRect(origin: self.smallOrigin, size: self.smallSize)
      
      self.videoCallController.view.frame = newFrame
      self.videoCallController.mainVideoView.frame.size = newFrame.size
      
      self.videoCallController.view.layer.cornerRadius = self.isVideoViewSmall ? 0.0 : self.cornerRadius
      
      self.isVideoViewSmall.toggle()
      
      self.updateCallViews(isHidden: self.isVideoViewSmall)
      
    } completion: { (_) in
      //
    }
  }
  
  func teleCallController(callController controller: VideoCallController, didTapMainView: Bool) {
    guard isVideoViewSmall else { return }
    
    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut) {
      
      let newFrame = self.isVideoViewSmall ?
        CGRect(origin: self.bigOrigin, size: self.bigSize) :
        CGRect(origin: self.smallOrigin, size: self.smallSize)
      
      self.videoCallController.view.frame = newFrame
      self.videoCallController.mainVideoView.frame.size = newFrame.size
      
      self.videoCallController.view.layer.cornerRadius = self.isVideoViewSmall ? 0.0 : self.cornerRadius
      
      self.isVideoViewSmall.toggle()
      
      self.updateCallViews(isHidden: self.isVideoViewSmall)
      
    } completion: { (_) in
      //
    }
  }
  
  
  // MARK: - Properties
  
  // TODO: -  Move this to package
  var isVideoViewSmall = false
  lazy var smallSize = CGSize(width: view.frame.width/3.5, height: view.frame.height/4.0)
  lazy var smallOrigin = SmallVideoViewPosition.topRight(smallSize).origin
  
  let bigOrigin: CGPoint = .zero
  lazy var bigSize = CGSize(width: view.frame.width, height: view.frame.height)
  let cornerRadius: CGFloat = 16.0
  
  // MARK: - Child controllers
  private lazy var videoCallController: VideoCallController = {
    let controller = VideoCallController()
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    controller.view.addGestureRecognizer(panGesture)
    controller.view.layer.cornerCurve = .continuous
    controller.view.clipsToBounds = true
    controller.delegate = self
    controller.smallVideoView.backgroundColor = .red
    controller.view.backgroundColor = .blue
    return controller
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupTeleCallSubview()
  }

  // MARK: - Methods
  
  // TODO: -  move this to package
  private func updateCallViews(isHidden hidden: Bool) {
    videoCallController.activeCallActionButtonsView.isHidden = hidden
    videoCallController.backButton.isHidden = hidden
    videoCallController.callDetailsView.isHidden = hidden
    videoCallController.smallVideoView.isHidden = hidden
  }
  
  private func setupTeleCallSubview() {
    add(videoCallController)
    guard let teleView = videoCallController.view else { return }
//    teleView.isHidden = true
    teleView.frame = CGRect(origin: .zero, size: view.frame.size)
  }
  
  @objc
  private func handlePan(_ gesture: UIPanGestureRecognizer) {
    guard isVideoViewSmall else { return }
    
    let translation = gesture.translation(in: view)
    
    guard let gestureView = gesture.view else {
      return
    }
    
    gestureView.center = CGPoint(
      x: gestureView.center.x + translation.x,
      y: gestureView.center.y + translation.y
    )
    
    let viewX = gestureView.center.x
    let viewY = gestureView.center.y
    
    var snapOrigin = CGPoint()
    
    if viewX >= view.center.x && viewY >= view.center.y {
      snapOrigin = SmallVideoViewPosition.bottomRight(gestureView.frame.size).origin
    } else if viewX >= view.center.x && viewY <= view.center.y {
      snapOrigin = SmallVideoViewPosition.topRight(gestureView.frame.size).origin
    } else if viewX <= view.center.x && viewY >= view.center.y {
      snapOrigin = SmallVideoViewPosition.bottomLeft(gestureView.frame.size).origin
    } else if viewX <= view.center.x && viewY <= view.center.y {
      snapOrigin = SmallVideoViewPosition.topLeft.origin
    }
    
    gesture.setTranslation(.zero, in: self.view)
    self.smallOrigin = snapOrigin
    
    if gesture.state == .ended {
      UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut) {
        gestureView.frame.origin = snapOrigin
      } completion: { _ in
        self.smallOrigin = snapOrigin
      }
      
    }
  }

}

@nonobjc extension UIViewController {
  func add(_ child: UIViewController, frame: CGRect? = nil) {
    addChild(child)
    
    if let frame = frame {
      child.view.frame = frame
    }
    
    view.addSubview(child.view)
    child.didMove(toParent: self)
  }
  
  func remove() {
    willMove(toParent: nil)
    view.removeFromSuperview()
    removeFromParent()
  }
}

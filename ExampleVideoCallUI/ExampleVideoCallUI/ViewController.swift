//
//  ViewController.swift
//  ExampleVideoCallUI
//
//  Created by Azhar Anwar on 30/06/22.
//

import UIKit
import VideoCallUI

final class ViewController: UIViewController {
  
  // MARK: - Child controllers
  private lazy var videoCallController: VideoCallController = {
    let controller = VideoCallController()
    controller.delegate = self
    
    /// Colors for example
    controller.smallVideoView.backgroundColor = .black
    controller.mainVideoView.backgroundColor = UIColor(red:0.49, green:0.73, blue:0.78, alpha:1.00)
    controller.callDetailsView.nameLabel.text = "Test name"
    
    return controller
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    add(videoCallController, frame: CGRect(origin: .zero, size: view.frame.size))
  }
}

extension ViewController: VideoCallControllerDelegate {
  func didTapBack(videoCallController: VideoCallController) {
    /// Do something
  }
  
  func didTapMainView(videoCallController: VideoCallController) {
    /// Do something
  }
  
  func didTapEndCall(videoCallController: VideoCallController) {
    /// Do something
  }
  
  func didTapFloatingCallView(videoCallController: VideoCallController) {
    /// Do something
  }
  
  func didTapCameraSwitchButton(videoCallController: VideoCallController) {
    /// Do something
  }
  
  func didTapCameraButton(videoCallController: VideoCallController) {
    /// Do something
  }
  
  func didTapMicButton(videoCallController: VideoCallController) {
    /// Do something
  }
}

@nonobjc extension UIViewController {
  
  /// Method to simplify adding a child controller to a parent. Helps you avoid some common gotchas.
  /// - Parameters:
  ///   - child: The child controller
  ///   - frame: The frame of the parent
  func add(_ child: UIViewController, frame: CGRect? = nil) {
    addChild(child)
    
    if let frame = frame {
      child.view.frame = frame
    }
    
    view.addSubview(child.view)
    child.didMove(toParent: self)
  }
}

//
//  VideoCallController.swift
//  
//
//  Created by Azhar Anwar on 30/06/22.
//

import UIKit
import CallKit

public enum VideoCallFramePosition {
  case minimised
  case maximised
}

public enum SmallVideoViewPosition {
  case topLeft, topRight(CGSize)
  case bottomLeft(CGSize), bottomRight(CGSize)
  
  public var origin: CGPoint {
    let topSpacingX = 24.0
    let topSpacingY: CGFloat = 64.0
    let bottomSpacing = 24.0
    
    switch self {
      case .topLeft:
        return CGPoint(x: topSpacingX, y: topSpacingY)
      case .topRight(let size):
        return CGPoint(x: UIScreen.main.bounds.maxX - (size.width + topSpacingX), y: topSpacingY)
      case .bottomLeft(let size):
        return CGPoint(x: bottomSpacing, y: UIScreen.main.bounds.maxY - (size.height + bottomSpacing))
      case .bottomRight(let size):
        return CGPoint(
          x: UIScreen.main.bounds.maxX - (size.width + bottomSpacing),
          y: UIScreen.main.bounds.maxY - (size.height + bottomSpacing)
        )
    }
  }
}

public protocol VideoCallControllerDelegate: AnyObject {
  func didTapBack(videoCallController: VideoCallController)
  func didTapMainView(videoCallController: VideoCallController)
  func didTapEndCall(videoCallController: VideoCallController)
  func didTapFloatingCallView(videoCallController: VideoCallController)
  func didTapCameraSwitchButton(videoCallController: VideoCallController)
  func didTapCameraButton(videoCallController: VideoCallController)
  func didTapMicButton(videoCallController: VideoCallController)
}

public class VideoCallController: UIViewController {
  
  // MARK: - Properties
  public weak var delegate: VideoCallControllerDelegate?
  
  public var didEndCall: (() -> Void)?
  
  public let smallVideoSize: CGSize = .init(width: 106.0, height: 174.0)
    
    private var activeCallActionButtonsViewBottomConstraint: NSLayoutConstraint?
  
  // MARK: - Animation properties
  public private(set) var isVideoViewSmall = false
  private lazy var smallSize = CGSize(width: (parent?.view.frame.width ?? 100.0)/3.5, height: (parent?.view.frame.height ?? 100.0)/4.0)
  private lazy var smallOrigin = SmallVideoViewPosition.topRight(smallSize).origin
  
  private let bigOrigin: CGPoint = .zero
  private lazy var bigSize = CGSize(width: parent?.view.frame.width ?? 200.0, height: parent?.view.frame.height ?? 200.0)
  private let cornerRadius: CGFloat = 16.0
  
  // MARK: - Subviews
  public let activeCallActionButtonsView = VideoCallButtonsView()
  
  public let callDetailsView = CallDetailsView()
  
  public lazy var backButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
    button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    return button
  }()
  
  @objc
  private func handleBack() {
    animateCallViews()
  }
  
  public lazy var mainVideoView: UIView = {
    let view = UIView()
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLargeVideoViewTap))
    view.addGestureRecognizer(tapGesture)
    return view
  }()
  
  public private(set) var buttonsAreOnscreen = true
  
  public lazy var smallVideoView: SmallVideoView = {
    let view = SmallVideoView()
    view.isUserInteractionEnabled = true
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSmallVideoViewTap))
    view.addGestureRecognizer(tapGesture)
    return view
  }()
  
  public var isLocalSmall = true
  
  @objc
  private func handleSmallVideoViewTap() {
    isLocalSmall.toggle()
    delegate?.didTapFloatingCallView(videoCallController: self)
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .black
    
    view.addSubview(mainVideoView)
    mainVideoView.frame = view.frame
    
    view.sendSubviewToBack(mainVideoView)
    
    setupActiveCallUI()
    
    let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    view.addGestureRecognizer(panGesture)
    view.layer.cornerCurve = .continuous
    view.clipsToBounds = true
    
    /// End call
    activeCallActionButtonsView.endCallButton.addTarget(self, action: #selector(handleCallEnded), for: .touchUpInside)
    /// Audio button
    activeCallActionButtonsView.audioButton.addTarget(self, action: #selector(handleAudio), for: .touchUpInside)
    /// Video Button
    activeCallActionButtonsView.videoButton.addTarget(self, action: #selector(handleVideo), for: .touchUpInside)
    /// Switch Camera
    activeCallActionButtonsView.cameraSwitchButton.addTarget(self, action: #selector(handleCameraSwitch), for: .touchUpInside)
    
  }
  
  // MARK: - Methods
  
    private func animateCallButtons(
        withOffset offset: CGFloat,
        withAlpha alpha: CGFloat
      ) {
        activeCallActionButtonsViewBottomConstraint?.constant = offset
        UIView.animate(
          withDuration: 0.4,
          delay: 0.0,
          usingSpringWithDamping: 1.0,
          initialSpringVelocity: 1.0,
          options: .curveEaseInOut,
          animations: {
            self.activeCallActionButtonsView.alpha = alpha
            self.view.layoutIfNeeded()
          },
          completion: nil)
    }
  
  private func animateCallViews() {
    UIView.animate(
      withDuration: 0.4,
      delay: 0.0,
      usingSpringWithDamping: 1.0,
      initialSpringVelocity: 1.0,
      options: .curveEaseInOut
    ) {
      let newFrame = self.isVideoViewSmall ?
      CGRect(origin: self.bigOrigin, size: self.bigSize) :
      CGRect(origin: self.smallOrigin, size: self.smallSize)
      
      self.view.frame = newFrame
      self.mainVideoView.frame.size = newFrame.size
      
      self.view.layer.cornerRadius = self.isVideoViewSmall ? 0.0 : self.cornerRadius
      
      self.isVideoViewSmall.toggle()
      
      self.updateCallViews(isHidden: self.isVideoViewSmall)
      
    } completion: { (_) in
      if self.isVideoViewSmall {
        self.delegate?.didTapMainView(videoCallController: self)        
      } else {
        self.delegate?.didTapBack(videoCallController: self)
      }
    }
  }
  
  @objc
  private func handleLargeVideoViewTap() {
    if buttonsAreOnscreen {
      animateCallButtons(withOffset: 40.0, withAlpha: 0.0)
      buttonsAreOnscreen = false
    } else {
      animateCallButtons(withOffset: -40.0, withAlpha: 1.0)
      buttonsAreOnscreen = true
    }
    
    guard isVideoViewSmall else { return }
    
    animateCallViews()
  }
  
  @objc
  private func handlePan(_ gesture: UIPanGestureRecognizer) {
    guard isVideoViewSmall,
          let parent = parent
    else { return }
    
    let translation = gesture.translation(in: parent.view)
    
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
    
    if viewX >= parent.view.center.x && viewY >= parent.view.center.y {
      snapOrigin = SmallVideoViewPosition.bottomRight(gestureView.frame.size).origin
    } else if viewX >= parent.view.center.x && viewY <= parent.view.center.y {
      snapOrigin = SmallVideoViewPosition.topRight(gestureView.frame.size).origin
    } else if viewX <= parent.view.center.x && viewY >= parent.view.center.y {
      snapOrigin = SmallVideoViewPosition.bottomLeft(gestureView.frame.size).origin
    } else if viewX <= parent.view.center.x && viewY <= parent.view.center.y {
      snapOrigin = SmallVideoViewPosition.topLeft.origin
    }
    
    gesture.setTranslation(.zero, in: parent.view)
    self.smallOrigin = snapOrigin
    
    if gesture.state == .ended {
      UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut) {
        gestureView.frame.origin = snapOrigin
      } completion: { _ in
        self.smallOrigin = snapOrigin
      }
    }
  }
  
  private func updateCallViews(isHidden hidden: Bool) {
    activeCallActionButtonsView.isHidden = hidden
    backButton.isHidden = hidden
    callDetailsView.isHidden = hidden
    smallVideoView.isHidden = hidden
  }
  
  @objc
  private func handleCameraSwitch(_ sender: UIButton) {
    sender.isSelected.toggle()
    delegate?.didTapCameraSwitchButton(videoCallController: self)
  }
  
  @objc
  private func handleVideo(_ sender: UIButton) {
    sender.isSelected.toggle()
    
    if sender.isSelected {
      smallVideoView.blurView.isHidden = false
    } else {
      smallVideoView.blurView.isHidden = true
    }
    
    delegate?.didTapCameraButton(videoCallController: self)
  }
  
  @objc
  private func handleAudio(_ sender: UIButton) {
    sender.isSelected.toggle()
    
    if sender.isSelected {
      smallVideoView.audioInactiveImageView.isHidden = false
    } else {
      smallVideoView.audioInactiveImageView.isHidden = true
    }
    
    delegate?.didTapMicButton(videoCallController: self)
  }
  
  @objc
  private func handleCallEnded() {
    self.delegate?.didTapEndCall(videoCallController: self)
  }

    private func setupActiveCallUI() {
        view.addSubview(activeCallActionButtonsView)
        activeCallActionButtonsView.translatesAutoresizingMaskIntoConstraints = false
        activeCallActionButtonsViewBottomConstraint = activeCallActionButtonsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40.0)
        NSLayoutConstraint.activate([
            activeCallActionButtonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activeCallActionButtonsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24.0),
            activeCallActionButtonsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24.0),
            activeCallActionButtonsView.heightAnchor.constraint(equalToConstant: 56.0),
            activeCallActionButtonsViewBottomConstraint!
        ])
        
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8.0),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 44.0),
            backButton.heightAnchor.constraint(equalToConstant: 44.0)
        ])
        
        view.addSubview(callDetailsView)
        callDetailsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            callDetailsView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16.0),
            callDetailsView.heightAnchor.constraint(equalToConstant: 30.0),
            callDetailsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            callDetailsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0)
        ])
        
        view.addSubview(smallVideoView)
        smallVideoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            smallVideoView.heightAnchor.constraint(equalToConstant: smallVideoSize.height),
            smallVideoView.widthAnchor.constraint(equalToConstant: smallVideoSize.width),
            smallVideoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24.0),
            smallVideoView.bottomAnchor.constraint(equalTo: activeCallActionButtonsView.topAnchor, constant: -24.0)
        ])
    }

}

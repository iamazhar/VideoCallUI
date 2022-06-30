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
  func teleCallController(callController controller: VideoCallController, didTapBack tappedBack: Bool)
  func teleCallController(callController controller: VideoCallController, didTapMainView: Bool)
}

public final class VideoCallController: UIViewController {
  
  // MARK: - Properties
  
  public weak var delegate: VideoCallControllerDelegate?
  
  public var didEndCall: (() -> Void)?
  public var didJoinCall: (() -> Void)?
  
  public let smallVideoSize: CGSize = .init(width: 106.0, height: 174.0)
  
  // MARK: - Subviews
  
  public let activeCallActionButtonsView = ActiveCallActionButtonsView()
  
  public let callDetailsView = ActiveCallDetailsView()
  
  public lazy var backButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
    button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
    return button
  }()
  
  @objc
  private func handleBack() {
    delegate?.teleCallController(callController: self, didTapBack: true)
  }
  
  public lazy var mainVideoView: UIView = {
    let view = UIView()
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLargeVideoViewTap))
    view.addGestureRecognizer(tapGesture)
    return view
  }()
  
  public var buttonsAreOnscreen = true
  
  private func animateCallButtons(
    withOffset offset: CGFloat,
    withAlpha alpha: CGFloat
  ) {
    UIView.animate(
      withDuration: 0.4,
      delay: 0.0,
      usingSpringWithDamping: 1.0,
      initialSpringVelocity: 1.0,
      options: .curveEaseInOut,
      animations: {
        self.activeCallActionButtonsView.snp.updateConstraints { make in
          make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(offset)
        }
        self.activeCallActionButtonsView.alpha = alpha
        self.view.layoutIfNeeded()
      },
      completion: nil)
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
    delegate?.teleCallController(callController: self, didTapMainView: true)
  }
  
  public lazy var smallVideoView: ActiveCallSmallVideoView = {
    let view = ActiveCallSmallVideoView()
    view.isUserInteractionEnabled = true
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSmallVideoViewTap))
    view.addGestureRecognizer(tapGesture)
    return view
  }()
  
  public var isLocalSmall = true
  
  @objc
  private func handleSmallVideoViewTap() {
    isLocalSmall.toggle()
    
    // TODO: - call a closure
    
//    if isLocalSmall {
//      localVideoCanvas.view = mainVideoView
//      remoteVideoCanvas.view = smallVideoView
//      isLocalSmall = false
//    } else {
//      localVideoCanvas.view = smallVideoView
//      remoteVideoCanvas.view = mainVideoView
//      isLocalSmall = true
//    }
  }
  
  private func showPermissionsAlert() {
    // TODO: -  call closure
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .yellow
    
    view.addSubview(mainVideoView)
    mainVideoView.frame = view.frame

    view.sendSubviewToBack(mainVideoView)
    
    setupActiveCallUI()
    
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
  
  @objc
  private func handleCameraSwitch(_ sender: UIButton) {
    sender.isSelected.toggle()
    // TODO: -  call closure
  }
  
  @objc
  private func handleVideo(_ sender: UIButton) {
    sender.isSelected.toggle()
    
    if sender.isSelected {
      smallVideoView.blurView.isHidden = false
    } else {
      smallVideoView.blurView.isHidden = true
    }
    
    // TODO: - call closure
  }
  
  @objc
  private func handleAudio(_ sender: UIButton) {
    sender.isSelected.toggle()
    
    if sender.isSelected {
      smallVideoView.audioInactiveImageView.isHidden = false
    } else {
      smallVideoView.audioInactiveImageView.isHidden = true
    }
    
    // TODO: -  call closure
  }
  
  @objc
  private func handleCallEnded() {
    didEndCall?()
//    UIApplication.shared.isIdleTimerDisabled = false
  }
  
  private func setupActiveCallUI() {
    view.addSubview(activeCallActionButtonsView)
    activeCallActionButtonsView.snp.makeConstraints { make in
      make.centerX.equalTo(view)
      make.leading.equalTo(view).offset(24.0)
      make.trailing.equalTo(view).offset(-24.0)
      make.height.equalTo(56.0)
      make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40.0)
    }
    
    view.addSubview(backButton)
    backButton.snp.makeConstraints { make in
      make.leading.equalTo(view.safeAreaLayoutGuide).offset(8.0)
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.width.height.equalTo(44.0)
    }
    
    view.addSubview(callDetailsView)
    callDetailsView.snp.makeConstraints { make in
      make.top.equalTo(backButton.snp.bottom).offset(16.0)
      make.height.equalTo(30.0)
      make.leading.equalTo(view.safeAreaLayoutGuide).offset(16.0)
      make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16.0)
    }
    
    view.addSubview(smallVideoView)
    smallVideoView.snp.makeConstraints { make in
      make.height.equalTo(smallVideoSize.height)
      make.width.equalTo(smallVideoSize.width)
      make.leading.equalTo(view).offset(24.0)
      make.bottom.equalTo(activeCallActionButtonsView.snp.top).offset(-24.0)
    }
  } 
}

//
//  ActiveCallSmallVideoView.swift
//  
//
//  Created by Azhar Anwar on 30/06/22.
//

import UIKit
import SnapKit

public final class ActiveCallSmallVideoView: UIView {
  
  // MARK: - Properties
  private let inactiveSymbolSize: CGSize = .init(width: 20.0, height: 16.0)
  
  // MARK: - Subviews
  public let videoView = UIView()
  
  public let audioInactiveImageView: UIImageView = {
    let view = UIImageView(image: UIImage(systemName: "mic.slash"))
    view.tintColor = .white
    view.isHidden = true
    view.contentMode = .scaleAspectFit
    return view
  }()
  
  public let videoInactiveImageVIew: UIImageView = {
    let view = UIImageView(image: UIImage(systemName: "video.slash"))
    view.tintColor = .white
    view.isHidden = true
    view.contentMode = .scaleAspectFit
    return view
  }()
  
  private let inactiveStackView: UIStackView = {
    let view = UIStackView()
    view.axis = .horizontal
    view.distribution = .fillEqually
    view.spacing = 16.0
    view.alignment = .center
    return view
  }()
  
  private let blurEffect = UIBlurEffect(style: .light)
  public lazy var blurView: UIVisualEffectView  = {
    let view = UIVisualEffectView(effect: blurEffect)
    view.isHidden = true
    return view
  }()
  
  // MARK: - init
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    layer.cornerRadius = 8.0
    clipsToBounds = true
    
    addSubview(blurView)
    blurView.snp.makeConstraints { make in
      make.top.bottom.leading.trailing.equalTo(self)
    }
    
    inactiveStackView.addArrangedSubview(audioInactiveImageView)
    audioInactiveImageView.snp.makeConstraints { make in
      make.width.equalTo(inactiveSymbolSize.width)
      make.height.equalTo(inactiveSymbolSize.height)
    }
    
    inactiveStackView.addArrangedSubview(videoInactiveImageVIew)
    videoInactiveImageVIew.snp.makeConstraints { make in
      make.width.equalTo(inactiveSymbolSize.width)
      make.height.equalTo(inactiveSymbolSize.height)
    }
    
    addSubview(inactiveStackView)
    inactiveStackView.snp.makeConstraints { make in
      make.centerX.equalTo(self)
      make.bottom.equalTo(self).offset(-12.0)
    }
    
    addSubview(videoView)
    videoView.snp.makeConstraints { make in
      make.top.bottom.leading.trailing.equalTo(self)
    }
    sendSubviewToBack(videoView)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Methods
}


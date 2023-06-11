//
//  ActiveDetailsView.swift
//  
//
//  Created by Azhar Anwar on 30/06/22.
//

import UIKit
import SnapKit

public class CallDetailsView: UIStackView {
  
  // MARK: - Properties
  private let elapsedTimeContainerSize: CGSize = .init(width: 69.0, height: 28.0)
  
  // MARK: - Subviews
  public let nameLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = .boldSystemFont(ofSize: 15.0)
    return label
  }()
  
  public let mutedImageView: UIImageView = {
    let view = UIImageView(image: UIImage(systemName: "mic.slash"))
    view.tintColor = .white
    view.contentMode = .scaleAspectFit
    view.isHidden = true
    return view
  }()
  
  public lazy var detailsStackView: UIStackView = {
    let view = UIStackView()
    view.alignment = .center
    view.axis = .horizontal
    view.distribution = .fill
    view.spacing = 16.0
    return view
  }()
  
  private lazy var detailsContainerView: UIView = {
    let view = UIView()
    view.backgroundColor = .init(white: 0.0, alpha: 0.2)
    view.layer.cornerRadius = elapsedTimeContainerSize.height / 2.0
    return view
  }()
  
  public let elapsedTimeLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
    label.text = "00:00"
    return label
  }()
  
  public lazy var elapsedTimeContainerView: UIView = {
    let view = UIView()
    view.backgroundColor = .init(white: 0.0, alpha: 0.2)
    view.layer.cornerRadius = elapsedTimeContainerSize.height / 2.0
    return view
  }()
  
  private let spacerView = UIView()
  
  // MARK: - init
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupSubviews()
  }
  
  // MARK: - Methods
  private func setupSubviews() {
    detailsStackView.addArrangedSubview(nameLabel)
    
    detailsStackView.addArrangedSubview(mutedImageView)
    mutedImageView.snp.makeConstraints { make in
      make.height.equalTo(16.0)
      make.width.equalTo(20.0)
    }
    
    detailsContainerView.addSubview(detailsStackView)
    detailsStackView.snp.makeConstraints { make in
      make.center.equalTo(detailsContainerView)
      make.leading.equalTo(detailsContainerView).offset(12.0)
      make.trailing.equalTo(detailsContainerView).offset(-12.0)
    }
    
    addArrangedSubview(detailsContainerView)
    
    addArrangedSubview(spacerView)
    
    /// Elapsed time
    elapsedTimeContainerView.addSubview(elapsedTimeLabel)
    elapsedTimeLabel.snp.makeConstraints { make in
      make.center.equalTo(elapsedTimeContainerView)
      make.height.equalTo(elapsedTimeLabel.intrinsicContentSize.height)
      make.width.equalTo(elapsedTimeLabel.intrinsicContentSize.width)
    }
    
    addArrangedSubview(elapsedTimeContainerView)
    elapsedTimeContainerView.snp.makeConstraints { make in
      make.width.equalTo(elapsedTimeContainerSize.width)
      make.height.equalTo(elapsedTimeContainerSize.height)
    }
  }
  
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

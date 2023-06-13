//
//  File.swift
//  
//
//  Created by Azhar Anwar on 30/06/22.
//

import UIKit
import SnapKit

public class VideoCallButtonsView: UIStackView {
    
    // MARK: - Subviews
    public let endCallButton: UIButton = {
        let button = UIButton()
        button.tintColor = .systemRed
        button.setImage(UIImage(systemName: "phone.down.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24.0, weight: UIImage.SymbolWeight.regular))?.withTintColor(.systemRed, renderingMode: .alwaysTemplate), for: .normal)
        return button
    }()
    
    public let audioButton: UIButton = {
        let button = UIButton()
        button.imageView?.tintColor = .white
        button.setImage(UIImage(systemName: "mic", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24.0, weight: UIImage.SymbolWeight.regular)), for: .normal)
        button.setImage(UIImage(systemName: "mic.slash", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24.0, weight: UIImage.SymbolWeight.regular)), for: .selected)
        return button
    }()
    
    public let videoButton: UIButton = {
        let button = UIButton()
        button.imageView?.tintColor = .white
        button.setImage(UIImage(
            systemName: "video",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 24.0, weight: UIImage.SymbolWeight.regular)
        ), for: .normal)
        
        button.setImage(UIImage(systemName: "video.slash"), for: .selected)
        return button
    }()
    
    public let cameraSwitchButton: UIButton = {
        let button = UIButton()
        button.imageView?.tintColor = .white
        button.setImage(UIImage(
            systemName: "arrow.triangle.2.circlepath.camera.fill",
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 24.0, weight: UIImage.SymbolWeight.regular)
        ), for: .normal)
        return button
    }()
    
    // MARK: - init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        axis = .horizontal
        distribution = .equalSpacing
        alignment = .center
        spacing = 24.0
        
        setupSubviews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setupSubviews() {
        addArrangedSubview(endCallButton)
        endCallButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            endCallButton.widthAnchor.constraint(equalToConstant: 56.0),
            endCallButton.heightAnchor.constraint(equalToConstant: 56.0)
        ])
        
        addArrangedSubview(audioButton)
        audioButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            audioButton.widthAnchor.constraint(equalToConstant: 56.0),
            audioButton.heightAnchor.constraint(equalToConstant: 56.0)
        ])
        
        addArrangedSubview(videoButton)
        videoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoButton.widthAnchor.constraint(equalToConstant: 56.0),
            videoButton.heightAnchor.constraint(equalToConstant: 56.0)
        ])
        
        addArrangedSubview(cameraSwitchButton)
        cameraSwitchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cameraSwitchButton.widthAnchor.constraint(equalToConstant: 56.0),
            cameraSwitchButton.heightAnchor.constraint(equalToConstant: 56.0)
        ])
    }
    
}


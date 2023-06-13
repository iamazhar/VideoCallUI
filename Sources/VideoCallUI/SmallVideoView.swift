//
//  ActiveCallSmallVideoView.swift
//  
//
//  Created by Azhar Anwar on 30/06/22.
//

import UIKit
import SnapKit

public class SmallVideoView: UIView {
    
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
        blurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: topAnchor),
            blurView.bottomAnchor.constraint(equalTo: bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        inactiveStackView.addArrangedSubview(audioInactiveImageView)
        audioInactiveImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            audioInactiveImageView.widthAnchor.constraint(equalToConstant: inactiveSymbolSize.width),
            audioInactiveImageView.heightAnchor.constraint(equalToConstant: inactiveSymbolSize.height)
        ])
        
        inactiveStackView.addArrangedSubview(videoInactiveImageVIew)
        videoInactiveImageVIew.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoInactiveImageVIew.widthAnchor.constraint(equalToConstant: inactiveSymbolSize.width),
            videoInactiveImageVIew.heightAnchor.constraint(equalToConstant: inactiveSymbolSize.height)
        ])
        
        addSubview(inactiveStackView)
        inactiveStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inactiveStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            inactiveStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.0)
        ])
        
        addSubview(videoView)
        videoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoView.topAnchor.constraint(equalTo: topAnchor),
            videoView.bottomAnchor.constraint(equalTo: bottomAnchor),
            videoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        sendSubviewToBack(videoView)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

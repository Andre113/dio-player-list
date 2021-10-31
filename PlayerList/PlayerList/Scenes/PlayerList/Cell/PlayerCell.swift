//
//  PlayerCell.swift
//  PlayerList
//
//  Created by André Lucas Ota on 27/10/21.
//

import Foundation
import UIKit

final class PlayerCell: UITableViewCell {
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var avatarTopConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
    }
}

extension PlayerCell {
    func setup(player: PlayerModel) {
        nameLabel.text = player.name
        downloadImage(avatarURL: player.avatarURL)
    }
}

private extension PlayerCell {
    func setupUI() {
        configureView()
        configureConstraints()
    }
    
    func configureView() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
    }
    
    func configureConstraints() {
        let avatarTopConstraint = avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
        avatarTopConstraint.priority = .defaultLow
        NSLayoutConstraint.activate([
            avatarTopConstraint,
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            avatarImageView.heightAnchor.constraint(equalToConstant: 80),
            avatarImageView.widthAnchor.constraint(equalToConstant: 80)
        ])
        self.avatarTopConstraint = avatarTopConstraint
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
    
    func downloadImage(avatarURL: String) {
        guard let url = URL(string: avatarURL) else { return }
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.avatarImageView.image = UIImage(data: data)
                }
            } catch {
                print(error)
            }
        }
    }
}

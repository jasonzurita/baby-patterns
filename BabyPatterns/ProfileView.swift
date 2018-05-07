//
//  ProfileView.swift
//  BabyPatterns
//
//  Created by Jason Zurita on 12/15/16.
//  Copyright © 2016 Jason Zurita. All rights reserved.
//

import UIKit

protocol ProfileViewDelegate: class {
    func changeProfileImageButtonTapped()
}

class ProfileView: UIView {

    weak var delegate: ProfileViewDelegate?

    @IBOutlet var view: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeView()
    }

    private func initializeView() {
        loadNib()
        view.frame = bounds
        addSubview(view)

        imageView.layer.masksToBounds = true
    }

    override func draw(_: CGRect) {
        imageView.layer.cornerRadius = imageView.frame.height * 0.5
    }

    @IBAction func changeProfileImageButtonTapped(_: UIButton) {
        delegate?.changeProfileImageButtonTapped()
    }
}

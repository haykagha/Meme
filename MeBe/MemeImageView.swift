//
//  MemeImageView.swift
//  MeBe
//
//  Created by Vahan's MBP on 9/11/19.
//  Copyright © 2019 Vahan's MBP. All rights reserved.
//

import UIKit

class MemeImageView: UIViewController {
    
    var myImage: UIImage?
    
    @IBOutlet weak var memeView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeView.image = myImage
    }
    

}

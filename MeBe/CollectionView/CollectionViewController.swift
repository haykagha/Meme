//
//  CollectionViewController.swift
//  MeBe
//
//  Created by Vahan's MBP on 9/12/19.
//  Copyright © 2019 Vahan's MBP. All rights reserved.
//

import UIKit


class CollectionViewController: UICollectionViewController {
    
    var memeImage: UIImage?
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - 6 ) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCell", for: indexPath) as! CollectionViewCell
        cell.memeImage.image = memes[indexPath.row].memedImage
        cell.memeImage.contentMode = .scaleAspectFill
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.memeImage = memes[indexPath.row].memedImage
        performSegue(withIdentifier: "showCollectionImage", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCollectionImage" {
            let vc = segue.destination as! MemeImageView
            vc.myImage = memeImage
        }
    }
}

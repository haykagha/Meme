//
//  MemeTableViewController.swift
//  MeBe
//
//  Created by Vahan's MBP on 9/5/19.
//  Copyright © 2019 Vahan's MBP. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var memeImage: UIImage?
    var k: CGFloat?
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MemeCell
        cell.myLabel.text = memes[indexPath.row].topText! + "..." + memes[indexPath.row].bottomText!
        cell.myImage.image = memes[indexPath.row].memedImage
        
        // set cell's image size
        k = memes[indexPath.row].memedImage!.size.height / memes[indexPath.row].memedImage!.size.width
        cell.myImage.heightAnchor.constraint(equalToConstant: cell.myImage.frame.width * k! * 0.5).isActive = true
        cell.myImage.widthAnchor.constraint(equalToConstant: cell.myImage.frame.width * 0.5)
        cell.myImage.contentMode = .scaleAspectFill
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.memeImage = memes[indexPath.row].memedImage
        performSegue(withIdentifier: "showImage", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImage" {
            let vc = segue.destination as! MemeImageView
            vc.myImage = memeImage
        }
    }
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit
        editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath:
        IndexPath) {
        if editingStyle == .delete {
            appDelegate.memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: . automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt
        fromIndexPath: IndexPath, to: IndexPath) {
        let movedEmoji = appDelegate.memes.remove(at: fromIndexPath.row)
        appDelegate.memes.insert(movedEmoji, at: to.row)
        tableView.reloadData()
    }
    
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        let tableViewEditingMode = tableView.isEditing
        tableView.setEditing(!tableViewEditingMode, animated: true)
    }
}





//
//  AccountViewController.swift
//  JoinMeApp
//
//  Created by Jose Ricardo Arriaza on 8/5/24.
//

import UIKit
import AVFoundation
import CoreData

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    let profileProperties:[String] = ["Name", "Username", "Homecity", "Bio"]
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.layer.masksToBounds = true
        // for know this is fine but we also have to add the option to store the profile picture
        profilePicture.image = UIImage(named: "GenericAvatar")
        picker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.editedImage] as! UIImage
        profilePicture.contentMode = .scaleAspectFit
        profilePicture.image = selectedImage
        //save selected image to core data for now skip
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountCell", for: indexPath) as! AccountTableViewCell
        cell.propertyLabel.text = profileProperties[indexPath.row]
        cell.userData.textColor = .lightGray
        cell.pushIcon.textColor = .lightGray
        //create new attributes in Core Data to fill out the label
        cell.userData.text = "Placeholder"
        return cell
    }
    
    @IBAction func photoChange(_ sender: Any) {
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.picker.sourceType = .photoLibrary
            self.picker.allowsEditing = true
            self.present(self.picker, animated: true)
        }))
        controller.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            if (UIImagePickerController.availableCaptureModes(for: .rear) == nil) && (UIImagePickerController.availableCaptureModes(for: .front) == nil) {
                let minicontroller = UIAlertController(title: "No Camera Available", message: "Current device has no camera", preferredStyle: .alert)
                minicontroller.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(minicontroller, animated: true)
    
            } else {
                switch AVCaptureDevice.authorizationStatus(for: .video) {
                case .notDetermined:
                    AVCaptureDevice.requestAccess(for: .video) {
                        accessGranted in
                        guard accessGranted else {return}
                    }
                case .authorized:
                    break
                default:
                    return
                }
                self.picker.sourceType = .camera
                self.picker.allowsEditing = true
                self.picker.cameraCaptureMode = .photo
                self.present(self.picker, animated: true)
                
            }
        }))
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "changeSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeSegue", let destination = segue.destination as? ChangeProfileViewController {
            let row = tableView.indexPathForSelectedRow?.row
            destination.titleField = profileProperties[row!]
            destination.delegate = self
        }
    }
    
    func userUpdated() {
        tableView.reloadData()
    }
}

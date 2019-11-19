//
//  ViewController.swift
//  MyRecipe
//
//  Created by AHMAD SHAKIR on 19/11/2019.
//  Copyright © 2019 AHMAD SHAKIR. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var image: UITextView!
    @IBOutlet weak var ingredient: UITextView!
    @IBOutlet weak var step: UITextView!
    @IBOutlet weak var image2: UIImageView!
    
    var imagetext:String = ""
    var ingtext:String = ""
    var steptext:String = ""
    
    
    
    var imagePicker: ImagePicker!
    
    
    @IBAction func btnsave(_ sender: Any) {
        save()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        image2.isUserInteractionEnabled = true
        image2.addGestureRecognizer(tapGestureRecognizer)
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        set()
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
         print("imageTapped")
        // Your action
     
        self.imagePicker.present(from:tappedImage)
        
    }
    
    func set(){
        image.text=imagetext
        ingredient.text=ingtext
        step.text=steptext
        imagetext=""
        ingtext=""
        steptext=""
    }
    
    
    func save(){
        print("SAVE")
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Now let’s create an entity and new user records.
        let userEntity = NSEntityDescription.entity(forEntityName: "Recipe", in: managedContext)!
        
        //final, we need to add some data to our newly created record for each keys using
        //here adding 5 data with loop
        
        let imageData = image2.image?.jpegData(compressionQuality: 0.75)
        
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(image.text, forKeyPath: "image")
        user.setValue(ingredient.text, forKey: "ingredient")
        user.setValue(step.text, forKey: "step")
        user.setValue(imageData, forKey: "image2")
        
        
        //Now we have set all the values. The next step is to save them inside the Core Data
        
        do {
            try managedContext.save()
            retrieveData()
            self.navigationController?.popViewController(animated: true)
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
     
    }
    
    
    func retrieveData() {
        print("RETRIEVEDATA")
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Recipe")
        
        //        fetchRequest.fetchLimit = 1
        //        fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur")
        //        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "email", ascending: false)]
        //
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "image") as! String)
                print(data.value(forKey: "ingredient") as! String)
                print(data.value(forKey: "step") as! String)
                print(data.value(forKey: "image2"))
            }
            
        } catch {
            
            print("Failed")
        }
    }
    override func viewWillDisappear(_ animated: Bool){
        imagetext=""
        ingtext=""
        steptext=""
    }
   
    
}
extension ViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        self.image2.image = image
    }
}

//
//  AddTaskViewController.swift
//  CoreToDo
//
//  Created by Hirono Momotaro on 2017/10/08.
//  Copyright © 2017年 Hirono Momotaro. All rights reserved.
//

import UIKit
import Unbox

class AddTaskViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var categorySegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var btnAdd: UIButton!
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var task: Task?
    
    var taskCategory = "ToDo"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // taskに値が代入されていたら、textFieldとsegmentedControlにそれを表示
        if let task = task {
            taskTextField.text = task.name
            taskCategory = task.category
            btnAdd.setTitle("Edit", for: .normal)
            switch task.category {
            case "ToDo":
                categorySegmentedControl.selectedSegmentIndex = 0
            case "Shopping":
                categorySegmentedControl.selectedSegmentIndex = 1
            case "Assignment":
                categorySegmentedControl.selectedSegmentIndex = 2
            default:
                categorySegmentedControl.selectedSegmentIndex = 0
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions of Buttons
    @IBAction func categoryChosen(_ sender: UISegmentedControl) {
        // choose category of task
        switch sender.selectedSegmentIndex {
        case 0:
            taskCategory = "ToDo"
        case 1:
            taskCategory = "Shopping"
        case 2:
            taskCategory = "Assignment"
        default:
            taskCategory = "ToDo"
        }
    }
    
    @IBAction func plusButtonTapped(_ sender: Any) {
        let taskName = taskTextField.text
        if taskName == "" {
            dismiss(animated: true, completion: nil)
            return
        }
        
        // 受け取った値が空であれば、新しいTask型オブジェクトを作成する
        if task == nil {
            task = Task()
        }
        
        if (task?.id == 0)
        {
            //新規登録
            URLSessionFacade.get(url: URLString.InsertTodoURL, queryItems: Task.getInsertQueryItems(task_name: taskName!, task_category: taskCategory))
        }
        else
        {
            //修正登録
            URLSessionFacade.get(url: URLString.UpdateTodoURL, queryItems: Task.getUpdateQueryItems(task_id: (task?.id)!, task_name: taskName!, task_category: taskCategory))
        }
        
        // 変更内容を保存する
//        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

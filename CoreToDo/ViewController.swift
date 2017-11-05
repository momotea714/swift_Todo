//
//  ViewController.swift
//  CoreToDo
//
//  Created by Hirono Momotaro on 2017/10/08.
//  Copyright © 2017年 Hirono Momotaro. All rights reserved.
//

import UIKit
import CoreData
import Unbox
import ANLoader

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var taskTableView: UITableView!
    private let segueEditTaskViewController = "SegueEditTaskViewController"
    var tasks:[Task] = []
    var tasksToShow:[String:[Task]] = ["ToDo":[], "Shopping":[], "Assignment":[]]
    let taskCategories:[String] = ["ToDo", "Shopping", "Assignment"]

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        taskTableView.dataSource = self
        taskTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // CoreDataからデータをfetchしてくる
        
        getData()
        
    }
    
    @IBAction func btnRefreshData(_ sender: Any) {
        viewWillAppear(true)
//        ANLoader.hide()
    }
    
    // MARK: - Method of Getting data from Core Data
    func getData() {
        ANLoader.showLoading()
        let url = URLComponents(string: URLString.SelectTodoListURL)!
        let task = URLSession.shared.dataTask(with: url.url!){ data, response, error in
            if let data = data {
                do {
                    let json: [Task] = try unbox(data: data)
                    
                    // tasksToShow配列を空にする。（同じデータを複数表示しないため）
                    for key in self.tasksToShow.keys {
                        self.tasksToShow[key] = []
                    }
                    
                    for task in json  {
                        self.tasksToShow[task.category]?.append(task)
                    }
                    // taskTableViewを再読み込みする
//                    self.taskTableView.reloadData()
                    
                    DispatchQueue.main.async {
                        self.taskTableView.reloadData()
//                        ANLoader.hide()
                    }
                    
                    print(json)
                } catch {
                    print("Serialize Error")
                }
            } else {
                print(error ?? "Error")
            }
        }
        ANLoader.hide()
        task.resume()
        
//        // データ保存時と同様にcontextを定義
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        do {
//            // CoreDataからデータをfetchしてtasksに格納
//            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
//            tasks = try context.fetch(fetchRequest)
//
//            // tasksToShow配列を空にする。（同じデータを複数表示しないため）
//            for key in tasksToShow.keys {
//                tasksToShow[key] = []
//            }
//            // 先ほどfetchしたデータをtasksToShow配列に格納する
//            for task in tasks {
//                tasksToShow[task.category!]?.append(task.name!)
//            }
//        } catch {
//            print("Fetching Failed.")
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Data Source
    
    // taskCategories[]に格納されている文字列がTableViewのセクションになる
    func numberOfSections(in tableView: UITableView) -> Int {
        return taskCategories.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return taskCategories[section]
    }
    
    // tasksToShowにカテゴリー（tasksToShowのキーとなっている）ごとのnameが格納されている
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksToShow[taskCategories[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = taskTableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseIdentifier, for: indexPath) as? TaskTableViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        let sectionData = tasksToShow[taskCategories[indexPath.section]]
        let cellData = sectionData?[indexPath.row]
        
        cell.taskLabel.text = "\(String(describing: cellData!.name))"
        cell.taskLabel.textColor = .brown    // ここを追加しただけです。
        cell.tag = (cellData?.id)!
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if editingStyle == .delete {
            let deletedCategory = taskCategories[indexPath.section]
            let deletedTask = tasksToShow[deletedCategory]?[indexPath.row]
            let task_id:Int = (deletedTask?.id)!
            URLSessionFacade.get(url: URLString.DeleteTodoURL, queryItems: Task.getDeleteQueryItems(task_id: task_id))
            getData()
//            // 先ほど取得したcategoryとnameに合致するデータのみをfetchするようにfetchRequestを作成
//            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "name = %@ and category = %@", deletedName!, deletedCategory)
//            // そのfetchRequestを満たすデータをfetchしてtask（配列だが要素を1種類しか持たない）に代入し、削除する
//            do {
//                // 削除したいデータのみをfetchする
//                // 削除したいデータのcategoryとnameを取得
////                let task = try context.fetch(fetchRequest)
////                context.delete(task[0])
//            } catch {
//                print("Fetching Failed.")
//            }

            // 削除したあとのデータを保存する
//            (UIApplication.shared.delegate as! AppDelegate).saveContext()

            // 削除後の全データをfetchする
            
        }
        // taskTableViewを再読み込みする
//        taskTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationViewController = segue.destination as? AddTaskViewController else { return }

        // contextをAddTaskViewController.swiftのcontextへ渡す
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        destinationViewController.context = context
        if let indexPath = taskTableView.indexPathForSelectedRow, segue.identifier == segueEditTaskViewController {
            // 編集したいデータのcategoryとnameを取得
            let editedCategory = taskCategories[indexPath.section]
            let task = tasksToShow[editedCategory]?[indexPath.row]
            
            destinationViewController.task = task
            
        }
        
    }

}


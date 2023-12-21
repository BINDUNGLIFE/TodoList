//
//  TodoListViewController.swift
//  testTodo
//
//  Created by 김가빈 on 12/21/23.
//


import UIKit
// 할일 저장 리스트 (전역변수)
var list = [TodoList]()

class TodoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    /// 할일리스트
    @IBOutlet weak var todoListTableView: UITableView!
    /// 편집 버튼
    lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonAction))
        return button
    }()
    /// 완료 버튼
    lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonAction))
        return button
    }()
    
    /// done 버튼 클릭 이벤트 - tap시 수정모드 종료
    @objc func doneButtonAction() {
        self.navigationItem.leftBarButtonItem = editButton
        todoListTableView.setEditing(false, animated: true)
    }
    
    /// 편집 버튼 클릭 이벤트
    @objc func editButtonAction() {
        // 리스트 비어있을 때 return
        guard !list.isEmpty else {
            return
        }
        self.navigationItem.leftBarButtonItem = doneButton
        todoListTableView.setEditing(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = editButton
        todoListTableView.delegate = self
        todoListTableView.dataSource = self
        
        loadAllData()
        print(list.description)
        
        doneButton.style = .plain
        doneButton.target = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        saveAllData()
        todoListTableView.reloadData()
    }
    
    // userdefault 저장
    func saveAllData() {
        let data = list.map {
            [
                "title": $0.title,  // $0 : 0번부터
                "content": $0.content!,
                "isComplete": $0.isComplete
            ]
        }
        
        print(type(of: data))
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "items")
        userDefaults.synchronize()
    }
    
    // userDefault 데이터 불러오기
    func loadAllData() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "items") as? [[String: AnyObject]] else {
            return
        }
        
        print(data.description)
        
        // list 배열에 저장하기
        print(type(of: data))
        list = data.map {
            let title = $0["title"] as? String
            let content = $0["content"] as? String
            let isComplete = $0["isComplete"] as? Bool
            
            return TodoList(title: title!, content: content!, isComplete: isComplete!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = list[indexPath.row].title
        cell.detailTextLabel?.text = list[indexPath.row].content
        if list[indexPath.row].isComplete {
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    // 수정모드
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        list.remove(at: indexPath.row)
        todoListTableView.reloadData()
    }
    
    // 리스트 선택시 완료된 일로 표시
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 이미 체크되있는 경우 return
        guard !list[indexPath.row].isComplete else {
            return
        }
        
        // 리스트 선택 시 완료된 할일 표시(checkmark)
        list[indexPath.row].isComplete = true
        
        let dialog = UIAlertController(title: "Todo List", message: "일을 완료했습니다!!!!!", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        dialog.addAction(action)
        self.present(dialog, animated: true, completion: nil)
        
        todoListTableView.reloadData()
    }
}

//
//  ViewController.swift
//  testTodo
//
//  Created by 김가빈 on 12/20/23.
//

import UIKit

class AddTodoViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    var didAddHandler: ((TodoList) -> Void)?
    
    @IBAction func addListItemAction(_ sender: Any) {
        
        let title = titleTextField.text!
        let content = contentTextView.text ?? ""
        
        let item: TodoList = TodoList(title: title, content: content)
        
        print("Add List title : \(item.title)")
        // TodoListViewController에 생성한 전역변수에 append
        list.append(item)
        
        // Done 버튼 클릭 시 새로운 TodoList 객체 생성
        // 생성한 객체에 입력한 정보 저장
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        contentTextView.layer.borderColor = UIColor.gray.cgColor
        contentTextView.layer.borderWidth = 0.3
        contentTextView.layer.cornerRadius = 2.0
        contentTextView.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}




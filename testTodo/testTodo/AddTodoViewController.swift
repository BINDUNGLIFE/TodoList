//
//  AddTodoViewController.swift
//  testTodo
//
//  Created by 김가빈 on 12/21/23.
//

import UIKit

class AddTodoViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    var didAddHandler: ((Todo) -> Void)?
    
    
    @IBAction func addListItemAction(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty else {
                // 사용자에게 제목을 입력하라는 경고를 표시할 수 있습니다.
                // 예: 알림 대화상자를 표시하는 코드를 여기에 추가합니다.
                return
        }
        
        let content = contentTextView.text ?? ""
            let newTodo = Todo(title: title, content: content, isComplete: false, category: "Work")
            
            // TodoListViewController로 새 Todo 객체를 전달하기 위해 핸들러를 호출합니다.
            didAddHandler?(newTodo)
            
            // 현재 뷰 컨트롤러를 닫고 이전 화면으로 돌아갑니다.
            self.navigationController?.popViewController(animated: true)
        }
    
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        titleTextField.placeholder = "제목을 입력하세요"
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



/*
 
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


import UIKit


// 할 일 항목의 데이터 모델을 정의
struct Todo {
    var title: String
    var content: String
    var isComplete: Bool
    var category: String
    
    // 새로운 항목을 생성하고 초기화
    init(title: String, content: String, isComplete: Bool, category: String) {
        self.title = title
        self.content = content
        self.isComplete = isComplete
        self.category = category
        
    }
}

class TodoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // 항목을 저장하는데 사용
    var list = [Todo]()
    var didAddHandler: ((Todo) -> Void)?
    // 섹션별로 나눈 Todo배열
    var categorizedTodos: [String: [Todo]] = [:]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddTodoView" { // fSegue의 Identifier를 확인합니다.
            if let addTodoVC = segue.destination as? AddTodoViewController {
                // 핸들러를 정의하여 TodoListViewController의 테이블뷰를 갱신합니다.
                addTodoVC.didAddHandler = { [weak self] newTodo in
                    // 새로운 Todo를 list 배열에 추가합니다.
                    self?.list.append(newTodo)
                    // 카테고리별로 Todo를 다시 분류하고, 테이블 뷰를 갱신합니다.
                    self?.categorizeTodos()
                    self?.TodoListTableView.reloadData()
                }
            }
        }
    }
    
    //데이터를 카테고리별로 나누는 로직
    func categorizeTodos() {
        categorizedTodos = [:] //초기화
        for todo in list {
            categorizedTodos[todo.category, default: []].append(todo)
        }
    }
    // 섹션의 개수를 반환
    func numberOfSections(in tableView: UITableView) -> Int {
        return categorizedTodos.keys.count
    }
    
    
    // 헤더를 반환
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(categorizedTodos.keys)[section]
    }
    
    // 푸터를 반환
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "This is \(Array(categorizedTodos.keys)[section]) Footer"
    }
    
    // 각 섹션에 해당하는 로우의 개수를 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let categoryKey = Array(categorizedTodos.keys)[section]
        return categorizedTodos[categoryKey]?.count ?? 0
    }
    
    // 셀을 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let categoryKey = Array(categorizedTodos.keys)[indexPath.section]
        if let todos = categorizedTodos[categoryKey], indexPath.row < todos.count {
            let todo = todos[indexPath.row]
            cell.textLabel?.text = todo.title
            cell.detailTextLabel?.text = todo.content
            cell.accessoryType = todo.isComplete ? .checkmark : .none
            // 체크마크 설정
            cell.accessoryType = todo.isComplete ? .checkmark : .none
        }
        return cell
    }
    
    @IBOutlet weak var TodoListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TodoListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        // 네비게이션 아이템에 편집 버튼 추가
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        // 테이블 뷰의 delegate와 dataSource 설정
        TodoListTableView.delegate = self
        TodoListTableView.dataSource = self
        
        // 데이터 로드
        loadAllData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TodoListTableView.reloadData()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        TodoListTableView.setEditing(editing, animated: animated)
    }
    
    
    
    func saveAllData() {
        let data = list.map {
            [
                "title": $0.title,
                "content": $0.content ,
                "isComplete": $0.isComplete
            ]
        }
        UserDefaults.standard.set(data, forKey: "items")
    }
    
    func loadAllData() {
        if let data = UserDefaults.standard.object(forKey: "items") as? [[String: Any]] {
            list = data.map { dict in
                guard let title = dict["title"] as? String,
                      let content = dict["content"] as? String,
                      let isComplete = dict["isComplete"] as? Bool,
                      let category = dict["category"] as? String else {
                    return Todo(title: "", content: "", isComplete: false, category: "")
                }
                return Todo(title: title, content: content, isComplete: isComplete, category: category)
            }
            categorizeTodos()
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let categoryKey = Array(categorizedTodos.keys)[indexPath.section]
            
            // 먼저 list 배열에서 해당 항목을 찾아 제거합니다.
            if let todoToRemove = categorizedTodos[categoryKey]?[indexPath.row] {
                list.removeAll { $0.category == categoryKey && $0.title == todoToRemove.title }
            }
            
            // 그 다음 categorizedTodos에서 해당 항목을 제거합니다.
            categorizedTodos[categoryKey]?.remove(at: indexPath.row)
            
            // 테이블 뷰에서 해당 셀을 삭제
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // 데이터 저장
            saveAllData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 카테고리와 일치하는 Todo 항목을 찾습니다.
        let categoryKey = Array(categorizedTodos.keys)[indexPath.section]
        if var todos = categorizedTodos[categoryKey] {
            // 선택된 Todo 항목의 완료 상태를 변경합니다.
            todos[indexPath.row].isComplete = true // 또는 .toggle()로 토글할 수 있습니다.
            // 변경된 완료 상태를 전역 Todo 배열에도 반영합니다.
            if let indexInList = list.firstIndex(where: { $0.title == todos[indexPath.row].title && $0.category == categoryKey }) {
                list[indexInList].isComplete = todos[indexPath.row].isComplete
            }
            // 변경된 데이터로 categorizedTodos를 업데이트합니다.
            categorizedTodos[categoryKey] = todos
            // 테이블뷰의 해당 셀을 갱신합니다.
            tableView.reloadRows(at: [indexPath], with: .none)
            
            // 할 일 완료 알림을 표시합니다.
            let dialog = UIAlertController(title: "Todo List", message: "할 일을 완료했습니다.", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default) { _ in
                // 알림을 닫은 후에 할 작업이 있다면 여기에 작성합니다.
            }
            dialog.addAction(action)
            self.present(dialog, animated: true, completion: nil)
        }
        
        // 선택된 셀의 선택 상태를 해제합니다.
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    func updateTodoItem(at index: Int, with title: String, content: String) {
        if list.indices.contains(index) {
            // 배열 업데이트
            list[index].title = title
            list[index].content = content
            
            // UserDefaults 업데이트
            saveAllData()
            
            // 테이블 뷰 업데이트
            TodoListTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
            
        }
        
    }
    
}



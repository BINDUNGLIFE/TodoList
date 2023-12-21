import UIKit

// 할일 저장 리스트 (전역변수)
var list = [TodoList]()

class TodoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    /// 할일리스트를 보여주는 테이블 뷰

    @IBOutlet weak var TodoListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

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
        saveAllData()
        TodoListTableView.reloadData()
    }

    // MARK: - Data Management
    func saveAllData() {
        let data = list.map {
            [
                "title": $0.title,
                "content": $0.content ?? "",
                "isComplete": $0.isComplete
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "items")
        userDefaults.synchronize()
    }

    func loadAllData() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "items") as? [[String: AnyObject]] else { return }
        list = data.map {
            let title = $0["title"] as? String ?? ""
            let content = $0["content"] as? String
            let isComplete = $0["isComplete"] as? Bool ?? false
            return TodoList(title: title, content: content, isComplete: isComplete)
        }
    }

    // MARK: - UITableView DataSource & Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = list[indexPath.row].title
        cell.detailTextLabel?.text = list[indexPath.row].content
        cell.accessoryType = list[indexPath.row].isComplete ? .checkmark : .none
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !list[indexPath.row].isComplete else { return }
        list[indexPath.row].isComplete = true
        let dialog = UIAlertController(title: "Todo List", message: "일을 완료했습니다!!!!!", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        dialog.addAction(action)
        self.present(dialog, animated: true, completion: nil)
        tableView.reloadData()
    }
}

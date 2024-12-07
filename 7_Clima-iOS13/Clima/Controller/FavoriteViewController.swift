import UIKit

class FavoriteViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "tableViewCell")
        }
    }

    // 地域名と都市名のデータ
    let regionCityData: [(region: String, cityList: [(ja: String, en: String)])] = [
        ("EU", [
            ("ベルリン", "Berlin"),
            ("アムステルダム", "Amsterdam"),
            ("ロンドン", "London")
        ]),
        ("アジア", [
            ("東京", "Tokyo"),
            ("バンコク", "Bangkok")
        ]),
        ("オセアニア", [
            ("シドニー", "Sydney"),
            ("メルボルン", "Melbourne")
        ]),
        ("アフリカ", [
            ("ケープタウン", "Cape Town")
        ])
    ]

    // データリスト
    private var regionList: [(region: String, cityList: [(ja: String, en: String)], isExpanded: Bool)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "都市一覧"

        // 戻るボタンを作成
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(back)
        )
        self.navigationItem.leftBarButtonItem = backButton

        // regionListの初期化
        regionList = regionCityData.map {($0.region, $0.cityList, true)}
    }

    // 戻るボタンのアクション
    @objc
    func back() {
        navigationController?.popViewController(animated: true)
    }
}

// 地域
extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()

        // 地域名
        let titleLabel = UILabel()
        titleLabel.text = regionList[section].region
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)

        // 地域名の位置調整
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])

        // ジェスチャー
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapRegion(sender:)))
        headerView.addGestureRecognizer(gesture)
        headerView.tag = section
        headerView.contentView.backgroundColor = UIColor.lightGray

        return headerView
    }

    // 高さ
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }

    // 地域名をクリックしたときのアクション
    @objc func tapRegion(sender: UITapGestureRecognizer) {
        guard let section = sender.view?.tag else { return }
        regionList[section].isExpanded.toggle()
        // テーブルビューの更新
        tableView.beginUpdates()
        tableView.reloadSections([section], with: .automatic)
        tableView.endUpdates()
    }
}

// 都市
extension FavoriteViewController: UITableViewDataSource {
    // 各セクションで表示する行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if regionList[section].isExpanded {
            return regionList[section].cityList.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルのテキスト・スタイルを設定
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! TableViewCell // カスタムセルを利用
        let city = regionList[indexPath.section].cityList[indexPath.row]
        cell.cityName?.text = city.ja
        cell.selectionStyle = .none // 選択時のハイライトを消す
        cell.separatorInset = .zero // セパレーターを横幅いっぱいにする
        cell.layoutMargins = .zero // セパレーターを横幅いっぱいにする

        // ジェスチャー
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapCity(sender:)))
        cell.addGestureRecognizer(gesture)

        return cell
    }

    // 高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 32
    }

    // セクション数
    func numberOfSections(in tableView: UITableView) -> Int {
        return regionList.count
    }

    // タップした都市のページへ進むアクション
    @objc
    func tapCity(sender: UITapGestureRecognizer) {
        guard
            let cell = sender.view as? UITableViewCell,
            let tableView = cell.superview as? UITableView,
            let indexPath = tableView.indexPath(for: cell)
        else {
            return
        }
        let city = regionList[indexPath.section].cityList[indexPath.row]
        let viewController = RegionViewController(nibName: "RegionView", bundle: nil)
        viewController.cityName = city.en
        navigationController?.pushViewController(viewController, animated: true)
    }
}

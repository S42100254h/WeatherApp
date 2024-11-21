import UIKit

class FavoriteViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // 戻るボタンを作成
        let backButton = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(back)
        )
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    // 戻るボタンのアクション
    @objc
    func back() {
        navigationController?.popViewController(animated: true)
    }
}

import UIKit

class RegionViewController: UIViewController {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var weatherManager = WeatherDataManager()
    var cityName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = cityName
        cityLabel.text = cityName

        weatherManager.delegate = self
        if let cityName = cityName {
            weatherManager.fetchWeather(cityName)
            print("action: serach, city: \(cityName)")
        }

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

extension RegionViewController: WeatherManagerDelegate {
    func updateWeather(weatherModel: WeatherModel) {
        DispatchQueue.main.sync {
            temperatureLabel.text = weatherModel.temperatureString
            cityLabel.text = weatherModel.cityName
            self.conditionImageView.image = UIImage(systemName: weatherModel.conditionName)
        }
    }

    func failedWithError(error: Error){
        print(error)
    }
}

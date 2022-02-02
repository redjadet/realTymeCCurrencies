//
//  CurrencyDetailViewController.swift
//  Interview
//
//  Created by Przemyslaw Szurmak on 29/01/2022.
//

import UIKit

class CurrencyDetailViewModel{
    
    var selectedMarket: Markets?
    
    public init( selectedMarket: Markets?){
        self.selectedMarket = selectedMarket
    }
}

class CurrencyDetailViewController: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var coinNameLbl: UILabel!
    @IBOutlet weak var highestPriceLbl: UILabel!
    @IBOutlet weak var lowestPriceLbl: UILabel!
    @IBOutlet weak var lastUpdateTimeLbl: UILabel!
    @IBOutlet weak var coinImageView: UIImageView!
    
    //MARK: - Variables
    var viewModel:CurrencyDetailViewModel!
    
    // MARK: - Init methods
    
    public init(viewModel : CurrencyDetailViewModel? = nil){
        super.init(nibName: nil, bundle: nil)
        if let vm = viewModel{
            self.viewModel = vm
        }else{
            self.viewModel = CurrencyDetailViewModel(selectedMarket: nil)
        }
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
        self.viewModel = CurrencyDetailViewModel(selectedMarket: nil)
    }
    
    public func setViewModel(viewModel : CurrencyDetailViewModel){
        self.viewModel = viewModel
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: Setup Views
    
    func setupView(){
        if let market = viewModel.selectedMarket{
            self.coinNameLbl.text = market.symbol?.uppercased()
            self.coinImageView.loadRemoteImageFrom(urlString: market.image ?? "")
            self.highestPriceLbl.text = String(format: "%.2f", market.high24H ?? 0.0) + " \(NetworkServices.getSelectedCurreny())"
            self.lowestPriceLbl.text = String(format: "%.2f", market.low24H ?? 0.0) + " \(NetworkServices.getSelectedCurreny())"
            if let lastUpdated = market.lastUpdated{
                self.lastUpdateTimeLbl.text = lastUpdated.convertDateFormatter()
            }
            self.title = market.name
        }
    }
}

//MARK: - StoryboardInstantiable
extension CurrencyDetailViewController: StoryboardInstantiable {
    static var storyboardName: String { return "Main" }
    static var storyboardIdentifier: String? { return "CurrencyDetailViewController" }
}

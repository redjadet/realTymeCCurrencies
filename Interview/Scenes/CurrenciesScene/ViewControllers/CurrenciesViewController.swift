//
//  ViewController.swift
//  Interview
//
//  Created by Przemyslaw Szurmak on 29/01/2022.
//

import UIKit

class CurrenciesViewModel {
    //MARK: Constants
    let refreshInterval = 10.0
    
    //MARK: - Variables
    var currencies: Currencies?{
        didSet{
            if let currencies = currencies {
                self.viewController?.configureFiatSelector(currencies)
            }
        }
    }
    
    var markets: [Markets]?
    weak var viewController: CurrenciesViewController?
    
    //MARK: - Init method
    
    public init(vc: CurrenciesViewController? = nil){
        viewController = vc
    }
    
    //MARK: - Network Operations
    func fetchAllFiatCurrencies(){
        
        NetworkServices.shared.getCurrencies { [weak self] currencies, errorMessage in
            
            guard let self = self else{
                return
            }
            
            if let model = currencies{
                self.currencies = model
            }else{
                print("Error: \(String(describing: errorMessage))")
            }
        }
    }
    
    func fetchMarkets(){
        NetworkServices.shared.getMarkets { [weak self] markets, errorMessage in
            
            guard let self = self else{
                return
            }
            
            self.markets = markets
            self.viewController?.prepareDataSource(errorMsg: errorMessage)
        }
    }
    
    func changeSelectedCurrency(currencyId: String?){
        NetworkServices.changeSelectedCurrency(selectedCurrenyId: currencyId)
        self.fetchMarkets()
    }
    
    //MARK: -
}

class CurrenciesViewController: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fiatCurrencyButton: UIButton!
    @IBOutlet weak var emptyView: EmptyView!
    
    //MARK: - Variables
    
    typealias TableDataSource = UITableViewDiffableDataSource<Int, Markets>
    
    var viewModel:CurrenciesViewModel!
    var diffableDataSource: TableDataSource!
    
    // MARK: - Init methods
    
    public init(viewModel : CurrenciesViewModel? = nil){
        super.init(nibName: nil, bundle: nil)
        if let vm = viewModel{
            self.viewModel = vm
        }else{
            self.viewModel = CurrenciesViewModel(vc: self)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.viewModel = CurrenciesViewModel(vc: self)
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cryptocurriencies"
        
        setupTableView()
        setPlaceholderMenu()
        
        //Start network requests
        self.viewModel.fetchAllFiatCurrencies()
        self.viewModel.fetchMarkets()
        
        //Start refresh timer
        startRefreshTimer()
    }
    
    //MARK: - TableViewPrepareDataSource
    
    func prepareDataSource(errorMsg: String?){
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Markets>()
        
        snapshot.appendSections([0])
        
        if let markets = self.viewModel.markets{
            self.tableView.isHidden = false
            snapshot.appendItems(markets, toSection: 0)
        }else{
            self.tableView.isHidden = true
            self.emptyView.emptyLabel.text = errorMsg
            snapshot.deleteAllItems()
        }
        
        self.emptyView.isHidden = !self.tableView.isHidden
        
        self.diffableDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func setupTableView(){
        self.diffableDataSource = TableDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, model) -> CurrenciesTableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrenciesTableViewCell", for: indexPath) as! CurrenciesTableViewCell
            cell.coinNameLbl.text = model.name
            if let currentPrice = model.currentPrice{
                cell.coinValueLbl.text = String(format: "%.2f", currentPrice) + " \(NetworkServices.getSelectedCurreny())"
            }
            if let imageUrl = model.image{
                cell.coinImageView.loadRemoteImageFrom(urlString: imageUrl, index: indexPath.row)
            }
            return cell
        })
    }
    
    //MARK: - Refresh Timer
    func startRefreshTimer(){
        _ = Timer.scheduledTimer(withTimeInterval: viewModel.refreshInterval, repeats: true) { timer in
            self.viewModel.fetchMarkets()
        }
    }
}

//MARK: - Currency Menu Operations

extension CurrenciesViewController {
    
    func setPlaceholderMenu(){
        let currenciesItems = UIMenu(title: "", options: .displayInline, children: [
            UIAction(title: "USD", handler: { _ in self.viewModel.changeSelectedCurrency(currencyId: "USD") }),
            UIAction(title: "PLN", handler: { _ in self.viewModel.changeSelectedCurrency(currencyId: "PLN") })
        ])
        
        let menu = UIMenu(title: "Fiat currencies", children: [currenciesItems])
        
        fiatCurrencyButton.menu = menu
        fiatCurrencyButton.showsMenuAsPrimaryAction = true
        fiatCurrencyButton.changesSelectionAsPrimaryAction = true
    }
    
    fileprivate func configureFiatSelector(_ currencies: Currencies){
        
        var childrens = [UIAction]()
        
        if let data = currencies.data{
            data.forEach { currency in
                let action = UIAction(title: currency.name ?? currency.id ?? ""){ [weak self] action in
                    self?.viewModel.changeSelectedCurrency(currencyId: currency.id ?? currency.name ?? "")
                }
                childrens.append(action)
            }
        }
        
        let currenciesItems = UIMenu(title: "", options: .displayInline, children: childrens)
        
        let menu = UIMenu(title: "Fiat currencies", children: [currenciesItems])
        
        fiatCurrencyButton.menu = menu
        fiatCurrencyButton.showsMenuAsPrimaryAction = true
        fiatCurrencyButton.changesSelectionAsPrimaryAction = true
    }
}

//MARK: - TableViewDelegate

extension CurrenciesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let market = viewModel.markets?[safeIndex:indexPath.row] else { return }
        
        let vm = CurrencyDetailViewModel(selectedMarket: market)
        let detailVC = CurrencyDetailViewController.instantiate()
        detailVC.setViewModel(viewModel: vm)
        
        if let navVC = self.navigationController, !navVC.viewControllers.contains(where: { tempDetail in
            tempDetail is CurrencyDetailViewController
        }){
            navVC.pushViewController(detailVC, animated: true)
        }else{
            print("Push is cancelled in \(self)")
        }
    }
}

//MARK: - StoryboardInstantiable
extension CurrenciesViewController: StoryboardInstantiable {
    static var storyboardName: String { return "Main" }
    static var storyboardIdentifier: String? { return "CurrenciesViewController" }
}


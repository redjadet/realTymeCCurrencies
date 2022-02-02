import Foundation

class NetworkServices {
    
    static let shared = NetworkServices()
    
    private init(){}
    
    private let defaultSession = URLSession(configuration: .default)
    private var currencyDataTask: URLSessionDataTask?
    private var marketsDataTask: URLSessionDataTask?
    
    private static var selectedCurrency = "AED"
    
    private let allCurrenciesUrl = "https://api.coinbase.com/v2/currencies"
    private let cryptoApiUrl = "https://api.coingecko.com/api/v3/coins/markets"
    
    //
    // MARK: - Type Aliases
    //
    
    typealias CurrenciesQueryResult = (Currencies?, String?) -> Void
    typealias MarketsQueryResult = ([Markets]?, String?) -> Void
    
    //MARK: - Public methods
    
    static func getSelectedCurreny() -> String{
        return NetworkServices.selectedCurrency
    }
    
    static func changeSelectedCurrency(selectedCurrenyId: String?){
        if let selectedCur = selectedCurrenyId{
            NetworkServices.selectedCurrency = selectedCur
        }
    }
    
    //MARK: -  Get currencies
    
    func getCurrencies(completion: @escaping CurrenciesQueryResult) {
        
        currencyDataTask?.cancel()
        
        var errorMessage: String?
        var responseModel: Currencies?
        
        if let urlComponents = URLComponents(string: allCurrenciesUrl) {
            
            guard let url = urlComponents.url else {
                return
            }
            
            currencyDataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
                defer {
                    self?.currencyDataTask = nil
                }
                
                if let error = error {
                    errorMessage = "DataTask error: " + error.localizedDescription + "\n"
                    DispatchQueue.main.async {
                        completion(nil, errorMessage)
                    }
                } else if
                    let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    
                    self?.parseCodable(data: data, responseObject: &responseModel)
                    
                    DispatchQueue.main.async {
                        completion(responseModel, errorMessage)
                    }
                }else {
                    let response = response as? HTTPURLResponse
                    errorMessage = "Http status code is " + String(response?.statusCode ?? 999)
                    DispatchQueue.main.async {
                        completion(nil, errorMessage)
                    }
                }
            }
            
            currencyDataTask?.resume()
        }
    }
    
    //MARK: -  Get markets
    
    func getMarkets(selectedCurrency:String = NetworkServices.selectedCurrency, completion: @escaping MarketsQueryResult){
        
        marketsDataTask?.cancel()
        
        var errorMessage: String?
        var responseModel: [Markets]?
        
        if var urlComponents = URLComponents(string: cryptoApiUrl) {
            urlComponents.query = "vs_currency=\(selectedCurrency)&order=market_cap_desc&per_page=30&page=1"
            
            guard let url = urlComponents.url else {
                return
            }
            
            marketsDataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
                defer {
                    self?.marketsDataTask = nil
                }
                
                if let error = error {
                    errorMessage = "DataTask error: " + error.localizedDescription + "\n"
                    DispatchQueue.main.async {
                        completion(nil, errorMessage)
                    }
                } else if
                    let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    
                    self?.parseCodable(data: data, responseObject: &responseModel)
                    
                    DispatchQueue.main.async {
                        completion(responseModel, errorMessage)
                    }
                }else {
                    let response = response as? HTTPURLResponse
                    errorMessage = "Http status code is " + String(response?.statusCode ?? 999)
                    DispatchQueue.main.async {
                        completion(nil, errorMessage)
                    }
                }
            }
            
            marketsDataTask?.resume()
        }
    }
    
    //
    // MARK: - Internal Methods
    //
    
    private func parseCodable<T: Codable>(data: Data, responseObject: inout T){
        let decoder = JSONDecoder()
        do {
            responseObject = try decoder.decode(T.self, from: data)
        } catch let err{
            print("decode error: \(err)")
        }
    }
}

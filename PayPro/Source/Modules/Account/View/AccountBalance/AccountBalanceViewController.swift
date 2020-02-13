//
//  AccountViewController.swift
//  Infinit
//
//  Created by Infinit on 9/7/18.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import UIKit

class AccountBalanceViewController: ParentViewController {
    
    var allTokens: [RetrieveTokenListOutputData] = []
    var filteredAllTokens: [RetrieveTokenListOutputData] = []
    
    var presenter: AccountBalancePresenterProtocol?
    
    @IBOutlet weak var balanceStackView: UIStackView!
    @IBOutlet weak var balanceTableView: UITableView!
    @IBOutlet weak var balanceSearchBar: UISearchBar!
    @IBOutlet weak var balanceAndTransactionSegmentedControl: UISegmentedControl!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    init () {
        super.init(nibName: "AccountBalanceViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onSegmentedControlValueChanged (_ sender: UISegmentedControl) {
        presenter?.onTransactionsSegmentedControlPressed()
    }
}

extension AccountBalanceViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addStatusBarHeightIfIosLessThan11(topConstraint: topConstraint)
        addTabBarHeightIfIosLessThan11(bottomConstraint: bottomConstraint, inverse: false)
        configureView()
        configureTableView()
        showLoadingIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.onAccountBalanceLoaded()
        reloadTokensWhenAddTokenPressed()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.balanceSearchBar?.resignFirstResponder()
    }
    
    private func configureView() {
        self.title = NSLocalizedString("account.title", comment: "")
        
        balanceSearchBar.delegate = self
        balanceSearchBar.placeholder = NSLocalizedString("account.balance.searchBar.placeholder", comment: "")
        let attributes = [NSAttributedString.Key.foregroundColor: CustomColors.grayLabels]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
        
        let balanceInSegmentedControl = NSLocalizedString("account.segmentedControl.balance", comment: "")
        let transactionInSegmentedControl = NSLocalizedString("account.segmentedControl.transactionHistory", comment: "")
        balanceAndTransactionSegmentedControl.setTitle(balanceInSegmentedControl, forSegmentAt: 0)
        balanceAndTransactionSegmentedControl.setTitle(transactionInSegmentedControl, forSegmentAt: 1)
        balanceAndTransactionSegmentedControl.addTarget(self, action: #selector(onSegmentedControlValueChanged), for: .valueChanged)
    }
    
    private func configureTableView() {
        balanceTableView.dataSource = self
        balanceTableView.delegate = self
        balanceTableView.register(UINib(nibName: "AddTokenButtonCell", bundle: nil), forCellReuseIdentifier: "AddNewTokenCell")
        balanceTableView.register(UINib(nibName: "TokenInformationCell", bundle: nil ), forCellReuseIdentifier: "tokenInformationCell")
        balanceTableView.tableFooterView = UIView()
        balanceTableView.rowHeight = 44
    }
}

extension AccountBalanceViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAllTokens.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = balanceTableView.dequeueReusableCell(withIdentifier: "AddNewTokenCell") as? AddTokenButtonCell {
                cell.addTokenLabel.text = NSLocalizedString("account.balance.addTokenLabel", comment: "")
                return  cell
            }
        } else {
            if let cell = balanceTableView.dequeueReusableCell(withIdentifier: "tokenInformationCell") as? TokenInformationCell {
                let smartContactAddress = filteredAllTokens[indexPath.row - 1].descripcion
                let tokenSymbol = filteredAllTokens[indexPath.row - 1].symbol
                let decimals = filteredAllTokens[indexPath.row - 1].balance
                
                cell.smartContactAddressLabel.text = smartContactAddress! + " (\(tokenSymbol ?? ""))"
                cell.tokenDecimalsLabel.text = decimals
                cell.tokenSymbolLabel.text = "\(tokenSymbol ?? "")"
                
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            presenter?.balanceAddTokenButtonPressed (from: self)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension AccountBalanceViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredAllTokens = searchText.isEmpty ? allTokens : allTokens.filter { (token: RetrieveTokenListOutputData) -> Bool in
            let tokenSmartContactAddress = token.descripcion
            return tokenSmartContactAddress?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        self.balanceTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.balanceSearchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.balanceSearchBar.showsCancelButton = false
        self.balanceSearchBar.text = ""
        filteredAllTokens = allTokens
        balanceTableView.reloadData()
        self.balanceSearchBar.resignFirstResponder()
    }
}

extension AccountBalanceViewController: AccountBalanceViewProtocol {
    
    func showTokenList(tokens: [RetrieveTokenListOutputData]) {
        allTokens = tokens
        filteredAllTokens = tokens
        self.balanceTableView.reloadData()
        hideLoadingIndicator()
    }
    
    func showErrorMessage(message: String) {
        hideLoadingIndicator()
        
        let alertTitle = NSLocalizedString("account.balance.ErrorTitle", comment: "")
        let alertMessage = message
        let okButtonText = NSLocalizedString("account.balance.ErrorOkButton", comment: "")
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: okButtonText, style: UIAlertAction.Style.default, handler: { action in self.printAddTokenError(message: message) }))
        alert.view.tintColor = CustomColors.grayLabels
        self.present(alert, animated: true, completion: nil)
    }
    
    func printAddTokenError(message: String) {
        print("error: \(message)")
    }
}

extension AccountBalanceViewController {
    func reloadTokensWhenAddTokenPressed() {
        self.balanceSearchBar.showsCancelButton = false
        self.balanceSearchBar.text = ""
        filteredAllTokens = allTokens
        balanceTableView.reloadData()
        self.balanceSearchBar?.resignFirstResponder()
    }
}

class AddTokenButtonCell: UITableViewCell {
    
    @IBOutlet weak var plusImage: UIImageView!
    @IBOutlet weak var addTokenLabel: UILabel!
    
}

class TokenInformationCell: UITableViewCell {
    
    @IBOutlet weak var smartContactAddressLabel: UILabel!
    @IBOutlet weak var tokenDecimalsLabel: UILabel!
    @IBOutlet weak var tokenSymbolLabel: UILabel!
    
}

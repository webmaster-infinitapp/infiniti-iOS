//
//  AccountTransactionHistoryViewController.swift
//  Infinit
//
//  Created by Infinit on 9/7/18.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import UIKit

class AccountTransactionHistoryViewController: ParentViewController {
    
    var presenter: AccountTransactionHistoryPresenterProtocol?
    
    var transactions: [TransactionHistoryOutput] = []
    
    @IBOutlet weak var balanceAndTransactionsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    init () {
        super.init(nibName: "AccountTransactionHistoryViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onSegmentedControlValueChanged (_ sender: UISegmentedControl) {
        presenter?.onBalanceSegmentedControlPressed()
    }
}

extension AccountTransactionHistoryViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addStatusBarHeightIfIosLessThan11(topConstraint: topConstraint)
        addTabBarHeightIfIosLessThan11(bottomConstraint: bottomConstraint, inverse: true)
        configureView()
        configureTableView()
        presenter?.onTransactionHistoryRequested()
        showLoadingIndicator()
    }
    
    private func configureView() {
        self.title = NSLocalizedString("account.title", comment: "")
        self.navigationItem.title = NSLocalizedString("account.segmentedControl.transactionHistory", comment: "")
        
        let balanceInSegmentedControl = NSLocalizedString("account.segmentedControl.balance", comment: "")
        let transactionInSegmentedControl = NSLocalizedString("account.segmentedControl.transactionHistory", comment: "")
        balanceAndTransactionsSegmentedControl.setTitle(balanceInSegmentedControl, forSegmentAt: 0)
        balanceAndTransactionsSegmentedControl.setTitle(transactionInSegmentedControl, forSegmentAt: 1)
        balanceAndTransactionsSegmentedControl.addTarget(self, action: #selector(onSegmentedControlValueChanged), for: .valueChanged)
    }
    
    private func configureTableView() {
        historyTableView.dataSource = self
        historyTableView.delegate = self
        historyTableView.register(UINib.init(nibName: "TransactionsCell", bundle: nil), forCellReuseIdentifier: "TransactionsCell")
    }
}

extension AccountTransactionHistoryViewController: AccountTransactionHistoryViewProtocol {
    
    func showTransactions(transactions: [TransactionHistoryOutput]) {
        self.transactions.append(contentsOf: transactions)
        historyTableView.reloadData()
        hideLoadingIndicator()
    }
    
    func showErrorMessage(message: String) {
        hideLoadingIndicator()
        
        let alertTitle = NSLocalizedString("account.transactions.ErrorTitle", comment: "")
        let alertMessage = message
        let okButtonText = NSLocalizedString("account.transactions.ErrorOkButton", comment: "")
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: okButtonText, style: UIAlertAction.Style.default, handler: { action in self.printAddTokenError(message: message) }))
        alert.view.tintColor = CustomColors.grayLabels
        self.present(alert, animated: true, completion: nil)
    }
    
    func printAddTokenError(message: String) {
        print("error: \(message)")
    }
}

extension AccountTransactionHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionsCell", for: indexPath) as? TransactionsCell
        if let ether = transactions[indexPath.row].ether {
            cell?.amount.text = "\(ether)"
        }
        cell?.symbol.text = transactions[indexPath.row].token
        if let message = transactions[indexPath.row].mensaje, message != "" {
            cell?.message.text = message
            cell?.message.isHidden = false
            cell?.noMessage.isHidden = true
        } else {
            cell?.message.isHidden = true
            cell?.noMessage.isHidden = false
        }
        cell?.beneficiaryAddress.text = transactions[indexPath.row].destino
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.onTransactionCellPressed(item: transactions[indexPath.row])
    }
}

class TransactionsCell: UITableViewCell {
    
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var noMessage: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var beneficiaryAddress: UILabel!
    
    override func awakeFromNib() {
        noMessage.text = NSLocalizedString("account.transactions.noMessage", comment: "")
    }
}

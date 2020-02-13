//
//  TransactionDetailsViewController.swift
//  Infinit
//
//  Created by Infinit on 08/11/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import UIKit

class TransactionDetailsViewController: ParentViewController {
    
    var presenter: AccountTransactionDetailsPresenterProtocol?
    
    var detail: TransactionDetailOutput?
    
    @IBOutlet weak var transactionDetailTableView: UITableView!
    @IBOutlet var transactionDetailHeaderCell: UITableViewCell!
    @IBOutlet var transactionDetailInformationCell: UITableViewCell!
    
    @IBOutlet var transactionDetailView: UIView!
    
    init () {
        super.init(nibName: "TransactionDetailsViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TransactionDetailsViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureTableView()
        self.navigationController?.navigationBar.tintColor = CustomColors.grayLabels
        showLoadingIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.onAccountTransactionDetailLoaded()
    }
    
    private func configureView() {
        self.title = NSLocalizedString("account.transactionDetails.title", comment: "")
    }
    
    private func configureTableView() {
        transactionDetailTableView.dataSource = self
        transactionDetailTableView.delegate = self
        transactionDetailTableView.register(UINib(nibName: "TransactionDetailHeaderCell", bundle: nil), forCellReuseIdentifier: "TransactionDetailHeaderCell")
        transactionDetailTableView.register(UINib(nibName: "TransactionDetailInformationCell", bundle: nil), forCellReuseIdentifier: "TransactionDetailInformationCell")
        transactionDetailTableView.tableFooterView = UIView()
        transactionDetailTableView.rowHeight = 50
    }
}

extension TransactionDetailsViewController: AccountTransactionDetailsViewProtocol {
    func showDetails(itemDetails: TransactionDetailOutput) {
        detail = itemDetails
        self.transactionDetailTableView.reloadData()
        hideLoadingIndicator()
    }
    
    func showErrorMessage(message: String) {
        hideLoadingIndicator()
        
        let alertTitle = NSLocalizedString("account.transactionDetails.ErrorTitle", comment: "")
        let alertMessage = message
        let okButtonText = NSLocalizedString("account.transactionDetails.ErrorOkButton", comment: "")
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: okButtonText, style: UIAlertAction.Style.default, handler: { action in self.printAddTokenError(message: message) }))
        alert.view.tintColor = CustomColors.grayLabels
        self.present(alert, animated: true, completion: nil)
    }
    
    func printAddTokenError(message: String) {
        print("error: \(message)")
    }
}

extension TransactionDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 16
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            if let cell = transactionDetailTableView.dequeueReusableCell(withIdentifier: "TransactionDetailHeaderCell") as? TransactionDetailHeaderCell {

                switch indexPath.row {
                case 0:
                    cell.headerLabel.text = NSLocalizedString("account.transactionDetails.headerCell.amountAndSymbol", comment: "")
                case 2:
                    cell.headerLabel.text = NSLocalizedString("account.transactionDetails.headerCell.beneficiaryWalletAddress", comment: "")
                case 4:
                    cell.headerLabel.text = NSLocalizedString("account.transactionDetails.headerCell.message", comment: "")
                case 6:
                    cell.headerLabel.text = NSLocalizedString("account.transactionDetails.headerCell.date", comment: "")
                case 8:
                    cell.headerLabel.text = NSLocalizedString("account.transactionDetails.headerCell.status", comment: "")
                case 10:
                    cell.headerLabel.text = NSLocalizedString("account.transactionDetails.headerCell.numberOfConfirmations", comment: "")
                case 12:
                    cell.headerLabel.text = NSLocalizedString("account.transactionDetails.headerCell.gasFee", comment: "")
                case 14:
                    cell.headerLabel.text = NSLocalizedString("account.transactionDetails.headerCell.transactionHash", comment: "")
                default:
                    cell.headerLabel.text = ""
                }
                
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
            }
        } else {
            if let cell = transactionDetailTableView.dequeueReusableCell(withIdentifier: "TransactionDetailInformationCell") as? TransactionDetailInformationCell {

                switch indexPath.row {
                case 1:
                    if let amount = detail?.cantidad {
                        if let symbol = detail?.moneda {
                    cell.informationLabel.text = "\(amount)" + " " + "\(symbol)"
                        }
                    }
                case 3:
                    if let beneficiaryAddress = detail?.destino {
                    cell.informationLabel.text = beneficiaryAddress
                    }
                case 5:
                    if let message = detail?.mensaje {
                        if !(detail?.mensaje == "") {
                             cell.informationLabel.text = message
                        } else {
                            cell.informationLabel.text = NSLocalizedString("account.transactionDetails.noMessage", comment: "")
                            cell.informationLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                        }
                    }
                case 7:
                    if let date = detail?.fecha {
                        let convertedDate = Date(timeIntervalSince1970: (Double(date) / 1000.0))
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "HH:mm:ss, dd MMMM yyyy"
                        cell.informationLabel.text = dateFormatter.string(from: convertedDate)
                    }
                case 9:
                    if let status = detail?.estado {
                        if status == "SUCCESS" || status == "Success" {
                            cell.informationLabel.text = status
                            cell.informationLabel.textColor = #colorLiteral(red: 0.4666666667, green: 0.8274509804, blue: 0.3254901961, alpha: 1)
                        } else if status == "FAILED" || status == "Failed" {
                            cell.informationLabel.text = status
                            cell.informationLabel.textColor = #colorLiteral(red: 0.9764705882, green: 0.3725490196, blue: 0.3843137255, alpha: 1)
                        } else {
                            cell.informationLabel.text = status
                        }
                    }
                case 11:
                    if let confirmations = detail?.confirmaciones {
                        cell.informationLabel.text = "\(confirmations)"
                    }
                case 13:
                    if let txFee = detail?.txFee {
                        cell.informationLabel.text = "\(txFee)" + " " + "ETH"
                    }
                case 15:
                    if let transaction = detail?.transaccion {
                        let text = NSMutableAttributedString(string: transaction + "  ")
                        let attachmentString = createCopyToClipboardString()
                        text.append(attachmentString)
                        cell.informationLabel.attributedText = text
                    }
                default:
                    cell.informationLabel.text = ""
                }
                
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                
                if indexPath.row == 15 {
                     cell.selectionStyle = UITableViewCell.SelectionStyle.gray
                }
                return cell
            }
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let transactionHash = detail?.transaccion {
            if indexPath.row == 15 {
                presenter?.copyToClipboardLabelPressed(transactionHash: transactionHash, inUIView: transactionDetailView)
            }
        }
    }
    
    func createCopyToClipboardString() -> NSAttributedString {
        let copyIconAttachement = NSTextAttachment()
        copyIconAttachement.image = UIImage(named: "copyIcon")
        copyIconAttachement.bounds = CGRect(x: 0, y: -5.0, width: 16, height: 16)
        
        let attachementString = NSAttributedString(attachment: copyIconAttachement)
        
        return attachementString
    }
}

class TransactionDetailHeaderCell: UITableViewCell {

    @IBOutlet weak var headerLabel: UILabel!
}

class TransactionDetailInformationCell: UITableViewCell {

    @IBOutlet weak var informationLabel: UILabel!
}

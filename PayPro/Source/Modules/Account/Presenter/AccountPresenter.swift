//
//  AccountPresenter.swift
//  Infinit
//
//  Created by Infinit on 9/7/18.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import UIKit

class AccountPresenter {
    
    weak var balanceView: AccountBalanceViewProtocol?
    weak var transactionView: AccountTransactionHistoryViewProtocol?
    weak var addTokenView: AccountAddTokenViewProtocol?
    weak var transactionDetailsView: AccountTransactionDetailsViewProtocol?
    var transactionDetailItem: TransactionHistoryOutput?
    
    var router: AccountRouterProtocol?
    var interactor: AccountInteractorProtocol?
}

extension AccountPresenter: AccountBalancePresenterProtocol {
    
    func onAccountBalanceLoaded() {
        interactor?.requestTokens()
    }
    
    func onTransactionsSegmentedControlPressed() {
        if let parentTabBarController = (balanceView as? UIViewController)?.parent?.parent as? UITabBarController {
            router?.showTransactionHistoryViewController(params: nil, tabBarController: parentTabBarController)
        }
    }
    
    func balanceAddTokenButtonPressed(from: UIViewController) {
        router?.pushAddTokenViewController(from: balanceView!, params: nil)
    }
}

extension AccountPresenter: AccountTransactionHistoryPresenterProtocol {
    
    func onTransactionHistoryRequested() {
        interactor?.requestTransactionHistory()
    }
    
    func onBalanceSegmentedControlPressed() {
        if let parentTabBarController = (transactionView as? UIViewController)?.parent?.parent as? UITabBarController {
            router?.showAccountBalanceViewController(params: nil, tabBarController: parentTabBarController)
        }
    }
    
    func onTransactionCellPressed(item: TransactionHistoryOutput) {
        transactionDetailItem = item
        router?.pushTransactionDetailsViewController(from: transactionView!, params: nil)
    }
}

extension AccountPresenter: AccountAddTokenPresenterProtocol {
    
    func newTokenAddTokenButtonPressed(smartContractAddress: String, tokenName: String, tokenSymbol: String, decimals: String, password: String) {
        if smartContractAddress != "" &&  tokenName != "" && tokenSymbol != "" && decimals != "" {
            interactor?.requestAddToken(smartContractAddress: smartContractAddress, tokenName: tokenName, tokenSymbol: tokenSymbol, decimals: decimals, password: password)
        } else {
            onTextFieldsEmptyError(NSLocalizedString("account.addToken.ErrorDescription.textFieldsNotFilled", comment: ""))
        }
    }
}

extension AccountPresenter: AccountTransactionDetailsPresenterProtocol {

    func onAccountTransactionDetailLoaded() {
        if let hasTransaccion = transactionDetailItem?.hasTransaccion {
            interactor?.requestTransactionDetail (transactionItem: hasTransaccion)
        }
    }
    
    func copyToClipboardLabelPressed(transactionHash: String, inUIView view: UIView) {
        let transactionHash = transactionHash
        UIPasteboard.general.string = transactionHash
        view.showToast(toastMessage: NSLocalizedString("general.copyToClipboard", comment: ""))
    }
}

extension AccountPresenter: AccountInteractorOutputProtocol {
    
    func onRetrieveTokenSuccess(tokens: [RetrieveTokenListOutputData]) {
        balanceView?.showTokenList(tokens: tokens)
        //
    }
    
    func onAddTokenSuccess() {
        router?.popView(from: addTokenView!)
    }
    
    func onRetrieveTransactionsSuccess(transactions: [TransactionHistoryOutput]) {
        transactionView?.showTransactions(transactions: transactions)
    }
    
    func onRetrieveTransactionDetailSuccess(transaction: TransactionDetailOutput) {
        transactionDetailsView?.showDetails(itemDetails: transaction)
    }
    
    func onRetrieveTokensError(_ message: String) {
        balanceView?.showErrorMessage(message: message)
    }
    
    func onAddTokenError(_ message: String) {
        addTokenView?.showErrorMessage(message: message)
    }
    
    func onRetrieveTransactionsError(_ error: String) {
        transactionView?.showErrorMessage(message: error)
    }
    
    private func onTextFieldsEmptyError(_ message: String) {
        addTokenView?.showErrorMessage(message: message)
    }
    
    func onRetrieveTransactionDetailError(_ error: String) {
        transactionDetailsView?.showErrorMessage(message: error)
    }
    
    func onTokenExpired() {
        if let topController = UIApplication.topViewController() {
            topController.hideLoadingIndicator()
            
            let alertTitle = NSLocalizedString("register.sessionExpiredTitle", comment: "")
            let alertMessage = NSLocalizedString("general.sessionExpiredError", comment: "")
            let okButtonText = NSLocalizedString("register.registerErrorOkButton", comment: "")
            
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: okButtonText, style: UIAlertAction.Style.default, handler: { action in
                (UIApplication.shared.delegate as? AppDelegate)!.presentRootViewController()
            }))
            alert.view.tintColor = CustomColors.grayLabels
            topController.present(alert, animated: true, completion: nil)
        }
    }
}

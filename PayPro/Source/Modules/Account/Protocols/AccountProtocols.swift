//
//  AccountProtocols.swift
//  Infinit
//
//  Created by Infinit on 25/10/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

protocol AccountBalanceViewProtocol: class {
    var presenter: AccountBalancePresenterProtocol? { get set }
    
    func showErrorMessage(message: String)
    func showTokenList(tokens: [RetrieveTokenListOutputData])
}

protocol AccountBalancePresenterProtocol: class {
    var balanceView: AccountBalanceViewProtocol? { get set }
    var interactor: AccountInteractorProtocol? { get set }
    var router: AccountRouterProtocol? { get set }
    
    func onAccountBalanceLoaded()
    func onTransactionsSegmentedControlPressed()
    func balanceAddTokenButtonPressed(from: UIViewController)
}

protocol AccountTransactionHistoryViewProtocol: class {
    var presenter: AccountTransactionHistoryPresenterProtocol? { get set }
    
    func showErrorMessage(message: String)
    func showTransactions(transactions: [TransactionHistoryOutput])
}

protocol AccountTransactionHistoryPresenterProtocol: class {
    var transactionView: AccountTransactionHistoryViewProtocol? { get set }
    var interactor: AccountInteractorProtocol? { get set }
    var router: AccountRouterProtocol? { get set }
    
    func onTransactionHistoryRequested()
    func onBalanceSegmentedControlPressed()
    func onTransactionCellPressed(item: TransactionHistoryOutput)
}

protocol AccountAddTokenViewProtocol: class {
    var presenter: AccountAddTokenPresenterProtocol? { get set }
    
    func showErrorMessage(message: String)
}

protocol AccountAddTokenPresenterProtocol: class {
    var addTokenView: AccountAddTokenViewProtocol? { get set }
    var interactor: AccountInteractorProtocol? { get set }
    var router: AccountRouterProtocol? { get set }
    
    func newTokenAddTokenButtonPressed(smartContractAddress: String, tokenName: String, tokenSymbol: String, decimals: String, password: String)
}

protocol AccountTransactionDetailsViewProtocol: class {
    var presenter: AccountTransactionDetailsPresenterProtocol? { get set }
    
    func showDetails(itemDetails: TransactionDetailOutput)
    func showErrorMessage(message: String)
}

protocol AccountTransactionDetailsPresenterProtocol: class {
    var transactionDetailsView: AccountTransactionDetailsViewProtocol? { get set }
    var interactor: AccountInteractorProtocol? { get set }
    var router: AccountRouterProtocol? { get set }
    
    func onAccountTransactionDetailLoaded()
    func copyToClipboardLabelPressed(transactionHash: String, inUIView view: UIView)
}

protocol AccountInteractorProtocol: class {
    var presenter: AccountInteractorOutputProtocol? { get set }
    var dataSource: AccountDataSourceProtocol? { get set }
    
    func requestTokens()
    func requestTransactionHistory()
    func requestAddToken(smartContractAddress: String, tokenName: String, tokenSymbol: String, decimals: String, password: String)
    func requestTransactionDetail(transactionItem: String)
}

protocol AccountInteractorOutputProtocol: class {
    func onRetrieveTokenSuccess(tokens: [RetrieveTokenListOutputData])
    func onAddTokenSuccess()
    func onRetrieveTransactionsSuccess(transactions: [TransactionHistoryOutput])
    func onRetrieveTokensError(_ message: String)
    func onAddTokenError(_ message: String)
    func onRetrieveTransactionsError(_ error: String)
    func onRetrieveTransactionDetailSuccess(transaction: TransactionDetailOutput)
    func onRetrieveTransactionDetailError(_ error: String)
    func onTokenExpired()
}

protocol AccountDataSourceProtocol: class {
    func retrieveTokenList(handle: @escaping ServiceHandler)
    func retrieveTransactionHistory(handle: @escaping ServiceHandler)
    func requestAddToken(with parameters: Parameters, handle: @escaping ServiceHandler)
    func retrieveTransactionDetail(transactionItem: String, handle: @escaping ServiceHandler)
}

protocol AccountRouterProtocol: class {
    func pushAddTokenViewController(from origin: AccountBalanceViewProtocol, params: Codable?)
    func pushTransactionDetailsViewController(from origin: AccountTransactionHistoryViewProtocol, params: Codable?)
    func showAccountBalanceViewController(params: Codable?, tabBarController: UITabBarController)
    func showTransactionHistoryViewController(params: Codable?, tabBarController: UITabBarController)
    func popView(from origin: AccountAddTokenViewProtocol)
}

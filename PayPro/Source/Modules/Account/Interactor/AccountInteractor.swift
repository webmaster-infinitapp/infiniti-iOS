//
//  AccountInteractor.swift
//  Infinit
//
//  Created by Infinit on 06/11/2018.
//  Copyright © 2018 Infinit. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class AccountInteractor: AccountInteractorProtocol {
    
    var presenter: AccountInteractorOutputProtocol?
    var dataSource: AccountDataSourceProtocol?
    
    func requestTokens() {
        dataSource?.retrieveTokenList(handle: { (onSuccess, data, error) in
            if onSuccess {
                do {
                    let tokens = try JSONDecoder().decode([RetrieveTokenListOutputData].self, from: data!)
                    self.presenter?.onRetrieveTokenSuccess(tokens: tokens)
                } catch {
                    self.presenter?.onRetrieveTokensError(NSLocalizedString("account.balance.ErrorDescription", comment: ""))
                }
            } else {
                error == SpecificErrors.expiredToken ? self.presenter?.onTokenExpired() : self.presenter?.onRetrieveTokensError(error!)
            }
        })
    }
    
    func requestAddToken(smartContractAddress: String, tokenName: String, tokenSymbol: String, decimals: String, password: String) {
        dataSource?.requestAddToken(with: AddNewTokenAppInput(smartContractAddress: smartContractAddress, tokenName: tokenName, tokenSymbol: tokenSymbol, decimals: decimals, password: password).getAsParameters()!, handle: { (onSuccess, data, error) in
            if onSuccess {
                do {
                    _ = try JSONDecoder().decode(ServerResponse.self, from: data!)
                    self.presenter?.onAddTokenSuccess()
                } catch {
                    self.presenter?.onAddTokenError(NSLocalizedString("account.addToken.ErrorDescription.notBeingAbleToAdd", comment: ""))
                }
            } else {
                error == SpecificErrors.expiredToken ? self.presenter?.onTokenExpired() : self.presenter?.onAddTokenError(error!)
            }
        })
    }
    
    func requestTransactionHistory() {
        dataSource?.retrieveTransactionHistory(handle: { (onSuccess, data, error) in
            if onSuccess {
                do {
                    var transactions: [TransactionHistoryOutput] = []
                    if data!.isEmpty == false {
                        transactions = try JSONDecoder().decode([TransactionHistoryOutput].self, from: data!)
                    }
                    self.presenter?.onRetrieveTransactionsSuccess(transactions: transactions)
                } catch {
                    self.presenter?.onRetrieveTransactionsError(NSLocalizedString("account.transactions.ErrorDescription", comment: ""))
                }
            } else {
                error == SpecificErrors.expiredToken ? self.presenter?.onTokenExpired() : self.presenter?.onRetrieveTransactionsError(error!)
            }
        })
    }
    
    func requestTransactionDetail(transactionItem: String) {
        dataSource?.retrieveTransactionDetail(transactionItem: transactionItem, handle: { (onSuccess, data, error) in
            if onSuccess {
                do {
                    let transactionDetail = try JSONDecoder().decode(TransactionDetailOutput.self, from: data!)
                    self.presenter?.onRetrieveTransactionDetailSuccess(transaction: transactionDetail)
                } catch {
                    self.presenter?.onRetrieveTransactionDetailError(NSLocalizedString("account.transactionDetails.ErrorDescription", comment: ""))
                }
            } else {
                error == SpecificErrors.expiredToken ? self.presenter?.onTokenExpired() : self.presenter?.onRetrieveTransactionDetailError(error!)
            }
        })
    }
}

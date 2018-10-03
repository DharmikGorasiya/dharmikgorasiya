//
//  ViewController.swift
//  InAppPurchaseDemo
//
//  Created by Dharmik Gorasiya on 19/06/18.
//  Copyright © 2018 Developer. All rights reserved.
//

import UIKit
import StoreKit
class ViewController: UIViewController {
    
    @IBOutlet weak var lblInstruction1: UILabel!
    @IBOutlet weak var lblInstruction2: UILabel!
    @IBOutlet weak var btnPurchase1: UIButton!
    @IBOutlet weak var btnPurchase2: UIButton!
    
    let FIVE_CREDIT = "com.ws.slap.5Credit"
    let TEN_CREDIT = "com.ws.slap.10Credit"
    var productID = ""
    var productsRequest = SKProductsRequest()
    var iapProducts = [SKProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefault()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Private Method
    
    func setDefault()
    {
        fetchAvailableProducts()
    }
    
    func alert(title:String,message:String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    //MARK: - Button Action
    
    @IBAction func btnPurchase1_Tapped(_ sender: Any) {
        purchaseMyProduct(product: iapProducts[0])
    }
    
    @IBAction func btnPurchase2_Tapped(_ sender: Any) {
        purchaseMyProduct(product: iapProducts[1])
    }
}

extension ViewController:SKProductsRequestDelegate,
    SKPaymentTransactionObserver
{
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        //NON-Consumable
        alert(title: "Success", message: "You've successfully restored your purchase!")
    }
    
    // MARK: - FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts()  {
        let productIdentifiers = NSSet(objects:TEN_CREDIT,FIVE_CREDIT)
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    
    // MARK: - REQUEST IAP PRODUCTS
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        if (response.products.count > 0) {
            iapProducts = response.products
            
            // 1st IAP Product (Consumable) ------------------------------------
            let tenCoinsProduct = response.products[0] as SKProduct
            let numberFormatter = NumberFormatter()
            numberFormatter.formatterBehavior = .behavior10_4
            numberFormatter.numberStyle = .currency
            numberFormatter.locale = tenCoinsProduct.priceLocale
            
            
            let price1Str = numberFormatter.string(from: tenCoinsProduct.price)
            lblInstruction1.text = tenCoinsProduct.localizedDescription + "\nfor just \(price1Str!)"
            btnPurchase1.setTitle(tenCoinsProduct.localizedDescription, for: .normal)
            
            // 2nd IAP Product (Consumable) ------------------------------------------------
            
            let fiveCoinsProduct = response.products[1] as SKProduct
            numberFormatter.locale = fiveCoinsProduct.priceLocale
            let price2Str = numberFormatter.string(from: fiveCoinsProduct.price)
            lblInstruction2.text = fiveCoinsProduct.localizedDescription + "\nfor just \(price2Str!)"
            btnPurchase2.setTitle(fiveCoinsProduct.localizedDescription, for: .normal)
        }
    }
    
    // MARK: - MAKE PURCHASE OF A PRODUCT
    
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    func purchaseMyProduct(product: SKProduct) {
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            print("PRODUCT TO PURCHASE: \(product.productIdentifier)")
            productID = product.productIdentifier
        } else {
            alert(title: "Alert", message: "Purchases are disabled in your device!")
        }
    }
    
    // MARK:- IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                    
                case .purchased:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    
                    if productID == FIVE_CREDIT {
                        alert(title: "Success", message: "You've successfully bought 5 credits!")
                    }
                    else if productID == TEN_CREDIT
                    {
                        alert(title: "Success", message: "You've successfully bought 10 credits!")
                    }
                    break
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    print(trans.error)
                    let alert = UIAlertController(title: "Item could not be purchased", message: "\(trans.error ?? "" as! Error)", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    break
                case .restored:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                    
                default: break
                }}}
    }
    
    
}


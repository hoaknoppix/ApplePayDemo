//
//  ViewController.swift
//  ApplePayDemo
//
//  Created by hoaqt on 1/3/19.
//

import UIKit
import PassKit

extension ViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        completion(PKPaymentAuthorizationResult(status: PKPaymentAuthorizationStatus.success, errors: nil))
        do {
            let json = try? JSONSerialization.jsonObject(with: payment.token.paymentData, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:AnyObject]
            let data = json!["data"] as! String
            print("data")
            print(data)
            let ephemeralPublicKey = (json!["header"] as! [String: String])["ephemeralPublicKey"]! as String
            print("ephemeralPublicKey")
            print(ephemeralPublicKey)
            let data1 = try JSONEncoder().encode(payment.token.paymentData)
            print(String(data: data1, encoding: .utf8)!)
        } catch let jsonError {
            print(jsonError)
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var applePayButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func touchApplePayButton(_ sender: Any) {
        let request = PKPaymentRequest()
        request.countryCode = "US"
        request.currencyCode = "USD"
        let macBook = PKPaymentSummaryItem()
        macBook.amount = 100.99
        macBook.label = "MacBook"
        macBook.type = PKPaymentSummaryItemType.final
        request.paymentSummaryItems.append(macBook)
        request.supportedNetworks.append(PKPaymentNetwork.masterCard)
        request.supportedNetworks.append(PKPaymentNetwork.maestro)
        request.merchantCapabilities.insert(PKMerchantCapability.capabilityDebit)
        request.merchantCapabilities.insert(PKMerchantCapability.capabilityCredit)
        request.merchantCapabilities.insert(PKMerchantCapability.capability3DS)
        request.merchantCapabilities.insert(PKMerchantCapability.capabilityEMV)
        request.merchantIdentifier = "merchant.com.heidelpay"
        let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)!
        applePayController.delegate = self
        self.present(applePayController, animated: true, completion: nil)
    }
    
}


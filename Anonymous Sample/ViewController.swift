//
//  ViewController.swift
//  Anonymous Sample
//
//  Created by Ahmed Sharf on 08/02/2023.
//

import UIKit
import FawryPaySDK

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .default
    }
    
    let serverURL = "https://atfawry.fawrystaging.com/"
    let merchantCode = "+/IAAY2nothN6tNlekupwA=="
    let secureKey = "4b815c12-891c-42ab-b8de-45bd6bd02c3d"
    let customerProfileId = "7117"
    
    @IBAction func paymentPressed(_ sender: UIButton) {
        let customerInfo = LaunchCustomerModel(customerName: "Name",
                                               customerEmail: "email@gmail.com",
                                               customerMobile: "+0100000000",
                                               customerProfileId: customerProfileId)
        
        let merchantInfo = LaunchMerchantModel(merchantCode: merchantCode,
                                               merchantRefNum: FrameworkHelper.shared?.getMerchantReferenceNumber(),
                                               secureKey: secureKey)
        
        let chargeInfo = ChargeItemsParamsModel(itemId: "101",
                                                charge_description: "item description",
                                                price: 200,
                                                quantity: 1)
        
        //total taxes of the items if not included in the item price
        let taxesInfo = ChargeItemsParamsModel(itemId: "taxes",
                                               charge_description: "",
                                               price: 28,
                                               quantity: 1)
        
        
        let launchModel = FawryLaunchModel(customer: customerInfo,
                                           merchant: merchantInfo,
                                           chargeItems: [chargeInfo, taxesInfo],
                                           signature: nil,
                                           allowVoucher: false,
                                           paymentWithCardToken: false,
                                           paymentMethod: .all)
        
        launchModel.skipCustomerInput = true
        launchModel.skipReceipt = false
        FrameworkHelper.shared?.launchAnonymousSDK(on: self,
                                                   launchModel: launchModel,
                                                   baseURL: serverURL,
                                                   appLanguage: AppLanguage.English,
                                                   enable3Ds: true,
                                                   authCaptureModePayment: false,
                                                   completionBlock: { (status) in
            print("Payment Method: completionBlock \(status)")
        }, onPreCompletionHandler: { (error) in
            print("Payment Method: onPreCompletionHandler \(error?.message)")
        }, errorBlock: { (error) in
            print("Payment Method: errorBlock with CODE:\(error?.errorCode) and MSG:\(error?.message)")
        }, onPaymentCompletedHandler: { (chargeResponse) in
            print("Payment Method: onPaymentCompletedHandler chargeResponse \(chargeResponse.debugDescription)")
            if let response = chargeResponse as? PaymentChargeResponse{
                print(response.merchantRefNumber)
                print(response.orderStatus)
            }
            if let er = chargeResponse as? FawryError{
                print(er.message)
            }
        }, onSuccessHandler: { (response) in
            let chargeResponse = response as? PaymentChargeResponse
            print("Payment Method: onSuccessHandler: \(chargeResponse?.merchantRefNumber)")
            print("Payment Method: onSuccessHandler: \(chargeResponse?.orderStatus)")
        })
    }
    
    @IBAction func manageCardsPressed(_ sender: Any) {
        let customerInfo = LaunchCustomerModel(customerName: "Name",
                                               customerEmail: "email@gmail.com",
                                               customerMobile: "+0100000000",
                                               customerProfileId: customerProfileId)
        
        let merchantInfo = LaunchMerchantModel(merchantCode: merchantCode,
                                               merchantRefNum: FrameworkHelper.shared?.getMerchantReferenceNumber(),
                                               secureKey: secureKey)
        let launchModel = FawryLaunchModel(customer: customerInfo,
                                           merchant: merchantInfo,
                                           chargeItems: nil,
                                           signature: nil)
        
        FrameworkHelper.shared?.launchCardManager(on: self,
                                                  launchModel: launchModel,
                                                  baseURL: serverURL,
                                                  appLanguage: AppLanguage.Arabic,
                                                  currency: Currency.egp,
                                                  enable3Ds: false, errorBlock: { error in
            print("manageCards1", error?.message)
        }, onAddedNewCard: { card in
            print("manageCards2", card.token)
        }, dismissBlock: {
            print("manageCards3", "User dismissed")
        })
    }
}

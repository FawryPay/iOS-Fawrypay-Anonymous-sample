//
//  ViewController.swift
//  Anonymous Sample
//
//  Created by Sameh on 08/04/2025.
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
    
    let customerInfo = LaunchCustomerModel(customerName:  "Name",
                                           customerEmail: "email@gmail.com",
                                           customerMobile: "+0100000000",
                                           customerProfileId: "7117")
    
    let chargeInfo = ChargeItemsParamsModel.init(itemId: "item description",
                                                 charge_description: "example description",
                                                 price: 100,
                                                 quantity: 1)
    var merchantInfo: LaunchMerchantModel!

    @IBAction func paymentPressed(_ sender: UIButton) {
        merchantInfo = LaunchMerchantModel(merchantCode: merchantCode,
                                           merchantRefNum: AnonymousFrameWorkHelper.sharedInstance.getMerchantReferenceNumber(),
                                           secureKey: secureKey)
        let checkoutModel = LaunchCheckoutModel(scheme: "myfawry")
        let applePayModel = LaunchApplePayModel(merchantID: "merchant.NUMUMARKET")
        let launchModel = FawryLaunchModel(customer: customerInfo,
                                           merchant: merchantInfo,
                                           chargeItems: [chargeInfo],
                                           signature: nil,
                                           allowVoucher: true,
                                           paymentWithCardToken: false,
                                           skipReceipt: false,
                                           skipCustomerInput: true,
                                           paymentMethod: .all,
                                           checkoutModel: checkoutModel,
                                           applePayModel: applePayModel,
                                           enableToknization: true)
      
        AnonymousFrameWorkHelper.sharedInstance.launchAnonymousSDK(on: self,
                                                                   launchModel: launchModel,
                                                                   baseURL: serverURL,
                                                                   appLanguage: AppLanguage.English,
                                                                   enable3Ds: true,
                                                                   authCaptureModePayment: false,
                                                                   cairoBold: UIFont(name: "Cairo-Bold", size: 16),
                                                                   cairoSemiBold: UIFont(name: "Cairo-SemiBold", size: 16),
                                                                   cairoRegular: UIFont(name: "Cairo-Regular", size: 16),
                                                                   fawryProBold: UIFont(name: "FawryPro-Bold", size: 16),
                                                                   completionBlock:
                                                                    { (status) in
            print("Payment Method: completionBlock \(String(describing: status))")
        }, onPreCompletionHandler: { (error) in
            print("Payment Method: onPreCompletionHandler \(String(describing: error?.message))")
        }, errorBlock: { (error) in
            print(error?.errorCode ?? "")
            print(error?.message ?? "")
            print("Payment Method: errorBlock \(String(describing: error?.message))")
        }, onPaymentCompletedHandler: { (chargeResponse) in
            print("Payment Method: onPaymentCompletedHandler chargeResponse \(chargeResponse.debugDescription)")
            if let response = chargeResponse as? PaymentChargeResponse{
                print(response.merchantRefNumber ?? "")
                print(response.orderStatus ?? "")
            }
            if let er = chargeResponse as? FawryError{
                print(er.message ?? "")
            }
        }, onSuccessHandler: { (response) in
            let merchantRefNumber = (response as? PaymentChargeResponse)?.merchantRefNumber ?? ""
            print("Payment Method: onSuccessHandler: \(merchantRefNumber)")
            let paymentMethod = (response as? PaymentChargeResponse)?.paymentMethod ?? ""
            print("payemnt Method Name \(paymentMethod)")
        })
    }
    
    @IBAction func manageCardsPressed(_ sender: Any) {
        merchantInfo = LaunchMerchantModel(merchantCode: merchantCode,
                                           merchantRefNum: AnonymousFrameWorkHelper.sharedInstance.getMerchantReferenceNumber(),
                                           secureKey: secureKey)
        let launchModel = FawryLaunchModel(customer: customerInfo,
                                           merchant: merchantInfo,
                                           chargeItems: nil,
                                           signature: nil,
                                            allowVoucher: false,
                                            paymentWithCardToken: false)
        
        AnonymousFrameWorkHelper.sharedInstance.launchCardManagerSDK(on: self,
                                                                     launchModel: launchModel,
                                                                     baseURL: serverURL,
                                                                     appLanguage: AppLanguage.English,
                                                                     currency: Currency.egp,
                                                                     cairoBold: UIFont(name: "Cairo-Bold", size: 16),
                                                                     cairoSemiBold: UIFont(name: "Cairo-SemiBold", size: 16),
                                                                     cairoRegular: UIFont(name: "Cairo-Regular", size: 16),
                                                                     fawryProBold: UIFont(name: "FawryPro-Bold", size: 16),
                                                                     enable3Ds: false, errorBlock: { error in
            print("manageCards1", error?.message ?? "")
        }, onAddedNewCard: { success in
            print("manageCards2", success ?? "")
        }, dismissBlock: {
            print("manageCards3", "User dismissed")
        })
    }
}

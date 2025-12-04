# 

# **FawryPay iOS SDK**

Accept popular payment methods with a single client-side implementation.

## **Before You Start**

Use this integration if you want your iOS application to:

-   Accepts cards and other payment methods.
-   Saves and displays cards for reuse.

Make sure you have an active FawryPay account, or [**create an account**](https://atfawry.fawrystaging.com/merchant/register).

### **How iOS SDK Looks Like**

<p align="center">
  <img src="https://github.com/user-attachments/assets/96e7b726-08b4-4af7-8e8e-491945ba7b39" alt="Home" width="300" />
  <img src="https://github.com/user-attachments/assets/d1809465-65f1-430e-ab92-ed78eb5234cb" alt="Card Manager 1" width="300" />
  <img src="https://github.com/user-attachments/assets/5827d86d-cb4d-4f72-9c48-19ced4ba3b35" alt="Receipt" width="300" />
</p>





[**Download**](https://github.com/FawryPay/iOS-Fawrypay-Anonymous-sample) and test our sample application.

### **How it works**

<img src="https://raw.githubusercontent.com/FawryPay/iOS-Fawrypay-Anonymous-sample/main/Docs/4.jpg" width="900"/>

------------------------------------------------------------------------

On this page we will walk you through iOS SDK integration steps:

1.  Installing FawryPaySDK Pod.
2.  Initialize and Configure FawryPay iOS SDK.
3.  Override the SDK colors.
4.  Present Payment options.
5.  Return payment processing information and inform your client with the payment result.

## **Step 1: Installing FawryPaySDK Pod**

This document illustrates how our gateway can be integrated within your iOS application in simple and easy steps. Please follow the steps in order to integrate the FawryPay iOS SDK in your application.

1.  Create a pod file in your application if it doesn't exist. Using this [Cocoapod Guide](https://guides.cocoapods.org/using/using-cocoapods.html)
2.  Add in your pod file and make sure you are using our (2.0.4) [Latest Version](https://github.com/FawryPay/iOS-Fawrypay-Anonymous-sample/tags)

<!-- -->

    pod 'FawryPaySDK'

3.  Add the following code at the end of the pod file :<br>

<!-- -->

    post_install do |installer|  
        installer.pods_project.targets.each do |target|    
            target.build_configurations.each do |config|      
                config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'    
            end  
        end
    end

4.  Open terminal navigated to your project root folder
5.  Run pod install
## **OR Install SPM**  
https://github.com/FawryPay/FawryPaySPM.git  

add package dependecies version (1.0.0)
## **Step 2: Initialize FawryPay IOS SDK**

1.  Import FawryPay SDK in your Swift file.

``` swift
import FawryPaySDK
```

2.  Create an instance of
    -   LaunchCustomerModel
    -   LaunchMerchantModel
    -   ChargeItemsParamsModel
    -   FawryLaunchModel
    -   Accounts model
    -   checkoutModel

and pass the required parameters (Required andoptional parameters are determined below).

<img src="https://github.com/user-attachments/assets/df1f838d-282b-4701-85a7-61844e4f3372" width="500" />

LaunchCustomerModel

| **PARAMETER**     | **TYPE** | **REQUIRED** | **DESCRIPTION**                                 | **EXAMPLE**                                        |
|---------------|---------------|---------------|---------------|---------------|
| customerName      | String   | optional     | \-                                              | Name Name                                          |
| customerEmail     | String   | optional     | \-                                              | [email\@email.com](mailto:email@email.com){.email} |
| customerMobile    | String   | optional     | \-                                              | +0100000000                                        |
| customerProfileId | String   | optional     | mandatory in case of payments using saved cards or enable card tokanization | 1234                                               |

LaunchMerchantModel

| **PARAMETER**  | **TYPE** | **REQUIRED** | **DESCRIPTION**                                                                                                                                                                | **EXAMPLE**                         |
|---------------|---------------|---------------|---------------|---------------|
| merchantCode   | String   | required     | Merchant ID provided during FawryPay account setup.                                                                                                                            | +/IPO2sghiethhN6tMC==               |
| merchantRefNum | String   | required     | Merchant's transaction reference number is random 10 alphanumeric digits.You can call FrameworkHelper.shared?.getMerchantReferenceNumber() to generate it rather than pass it. | A1YU7MKI09                          |
| secureKey      | String   | required     | provided by support                                                                                                                                                            | 4b8jw3j2-8gjhfrc-4wc4-scde-453dek3d |

ChargeItemsParamsModel

| **PARAMETER**      | **TYPE** | **REQUIRED** | **DESCRIPTION** | **EXAMPLE**         |
|---------------|---------------|---------------|---------------|---------------|
| itemId             | String   | required     | \-              | 3w8io               |
| charge_description | String   | optional     | \-              | This is description |
| price              | Double   | required     | \-              | 200.00              |
| quantity           | Int      | required     | \-              | 1                   |
| account            |[Accounts] | optional     | \-              |-|

Accounts model

| **PARAMETER**      | **TYPE** | **REQUIRED** | **DESCRIPTION** | **EXAMPLE**         |
|---------------|---------------|---------------|---------------|---------------|
| accountCode             | String   | required     | \-              |              |
| amount | Double   | required     | \-              |  |


FawryLaunchModel

| **PARAMETER**        | **TYPE**                 | **REQUIRED**                     | **DESCRIPTION**                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | **EXAMPLE**                 |
|---------------|---------------|---------------|---------------|---------------|
| customer             | LaunchCustomerModel      | optional                         | Customer information.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | \-                          |
| merchant             | LaunchMerchantModel      | required                         | Merchant information.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | \-                          |
| chargeItems          | [ChargeItemsParamsModel] | required                         | Array of items which the user will buy, this array must be of type ChargeItemsParamsModel                                                                                                                                                                                                                                                                                                                                                                                                                               | \-                          |
| signature            | String                   | optional                         | You can create your own signature by concatenate the following elements on the same order and hash the result using **SHA-256** as explained:"merchantCode + merchantRefNum + customerProfileId (if exists, otherwise insert"") + itemId + quantity + Price (in tow decimal format like '10.00') + Secure hash keyIn case of the order contains multiple items the list will be **sorted** by itemId and concatenated one by one for example itemId1+ Item1quantity + Item1price + itemId2 + Item2quantity + Item2price | \-                          |
| allowVoucher         | Bool                     | optional - default value = false | True if your account supports voucher code                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | \-                          |
| paymentWithCardToken | Bool                     | required                         | If true, the user will pay with a card token ( one of the saved cards or add new card to be saved )If false, the user will pay with card details without saving                                                                                                                                                                                                                                                                                                                                                         | \-                          |
| paymentMethod        | Payment_Method           | Optional - default value = .all  | If the user needs to show only one payment method.                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | .all.payAtFawry.card.wallet |
| checkoutModel        | LaunchCheckoutModel           | Required   | if you need use myfawry as payment method.     | \-               
| enableToknization        | Bool           | optional    | if you need remember card change to true .    

**Notes:**

-   **you can pass either signature or secureKey (in this case we will create the signature internally), knowing that if the 2 parameters are passed the secureKey will be ignored and the signature will be used.**

-   You can use below code snippet to show the receipt after payment is done or skip the user input screen while providing mobile and email instead of getting input from the user by setting the configurations **skipCustomerInput** and **skipReceipt** under FawryLaunchModel (Both configurations have a default value of **true** ).

    -   **fawryLaunchModelObject. skipCustomerInput = true**

    -   **fawryLaunchModelObject. skipReceipt = false**

3.  Calling Mode:
<img width="885" alt="Screenshot 2025-04-26 at 5 39 14 PM" src="https://github.com/user-attachments/assets/dcca4442-a1cb-42e1-b2c0-02ece407f48d" />


a.  Payment Mode: Call launchAnonymousSDK from the shared instance of FrameworkHelper and the payment screen will launch.



| **PARAMETER**          | **TYPE**         | **REQUIRED**                     | **DESCRIPTION**                                                                                        | **EXAMPLE**                                                                    |
|---------------|---------------|---------------|---------------|---------------|
| on                     | UIViewController | required                         | The view controller which will be the starting point of the SDK.                                       | self                                                                           |
| launchModel            | FawryLaunchModel | required                         | Has info that needed to launch the SDK                                                                 | Example in step 3                                                              |
| baseURL                | String           | required                         | Provided by the support team.Use staging URL for testing and switch for production to go live.         | <https://atfawry.fawrystaging.com> (staging)<https://atfawry.com> (production) |
| appLanguage            | String           | required                         | SDK language which will affect SDK's interface languages.                                              | AppLanguage.English                                                            |
| enable3Ds              | Bool             | optional - default value = false | to allow 3D secure payment make it "true"                                                              | true                                                                           |
| authCaptureModePayment | Bool             | optional - default value = false | depends on refund configuration: will be true when refund is enabled and false when refund is disabled | false                                                                          |

b.  Card Manager Mode: Call launchCardManager from the shared instance of FrameworkHelper and the payment screen will launch.
<img width="929" alt="Screenshot 2025-04-27 at 10 26 41 AM" src="https://github.com/user-attachments/assets/c5008ebb-7dc8-4358-82d6-853192b92a88" />


## **Step 3: Override the SDK colors**

1.  Add a plist file to your project named "Style".
2.  Add keys named:

-   primaryColorHex
-   secondaryColorHex
-   tertiaryColorHex
-   headerColorHex

3.  Give the keys values of your preferred hex color codes

<img src="https://github.com/user-attachments/assets/89790fb4-51bd-4675-a8c1-72ccce933ca8" width="500" alt="Screenshot" />

Example:
<img src="https://github.com/user-attachments/assets/5b10196e-4215-4e01-947e-f5e6de153c8c" width="500" />


## **Payment Flows:**

**We have 2 payment flows:**

1.  Payment with card details, in which we take the card details (card number, cvv, expiry date) in the payment screen and then we handle the payment.
2.  Payment with card token, in which we have 2 screens, first one manages cards which includes (add, delete, retrieve) for cards and the cards are saved and connected to the customerProfileId parameter that you pass in the initialization. And the second screen is the normal payment screen.

To choose which flow you want to start with there is a **paymentWithCardToken** flag in the initialization of the **FawryLaunchModel**.

**So if this flag is true you will need to pass** **customerProfileId** **to be able to complete a payment with its corresponding cards and if the** **customerProfileId** **doesn't have saved cards, when the user choose to pay with credit card we would ask him to click a button to navigate him to add card screen and after adding it successfully he will be redirected automatically to the payment screen to continue the payment flow. And in case the user wanted to delete or check which cards he saved or add a new card without opening the payment screen he can start the flow called launchCardManager as determined in step 2.**

## **Callbacks Explanation:**

-   **launchAnonymousSDK:**\
    There are 5 callbacks:
    -   **completionBlock: { FawrySDKStatusCode? in }**\
        called when flow launched successfully.

    -   **onPreCompletionHandler: { FawryError? in }**\
        called when flow NOT launched.

    -   **errorBlock: { FawryError? in }**

        -   if you enabled the receipt and payment failed, this callback will be called after clicking the done button in the receipt.

        -   if you disabled the receipt and payment failed, this callback will be called upon the finish of the payment screen.

    -   **onPaymentCompletedHandler: { Any ? in }**\
        will be called only whether the payment passed or not. And it's called upon receiving the response of the payment either success or fail.

    -   **onSuccessHandler: {Any ? in }**

        -   if you enabled the receipt and payment succeeded, this callback will be called after clicking the done button in the receipt.

        -   if you disabled the receipt and payment succeeded, this callback will be called upon the finish of the payment screen and the success of the payment.
            
-   **launchCardManager:**\
    There are 3 callbacks:
    -   **errorBlock: { FawryError? in }**\
        if an error happened.

    -   **onAddedNewCard: { SavedCard in }**\
        when adding cards successfully.

    -   **dismissBlock: { }**\
        unused in this flow

//
//  loginViewController.swift
//  TableTech
//
//  Created by Apple on 05/04/21.
//

import UIKit
import GoogleSignIn
import AuthenticationServices
import FBSDKLoginKit
import SwiftKeychainWrapper


class loginViewController: UIViewController {

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    @IBOutlet weak var appleLoginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        // Do any additional setup after loading the view.
        self.createAppleLoginButton()
    }
    
    
  
    
    
}


extension loginViewController {
    
    @IBAction func clickOnLoginBtn(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "homeViewController") as! homeViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickOnSignUpBtn(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "registrationViewController") as! registrationViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    @IBAction func googleLogin(_ sender : UIButton)
    {
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func clickOnFbLogin(_ sender: UIButton)
    {
        facebookSignup()
    }

}

extension loginViewController : GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!)
    {
        if let _ = error {
            print("errrrr = \(error.localizedDescription)")
        } else {
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let  email = user.profile.email
            
            print("\(givenName), \(familyName), \(email)")
        }
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        // customLoader.hide()
        self.present(viewController, animated: false, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
}

extension loginViewController : ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding  {
    
    func createAppleLoginButton(){
        
        self.appleLoginBtn.addTarget(self, action: #selector(handleLogInWithAppleIDButtonPress), for: .touchUpInside)

    }
    
    @objc private func handleLogInWithAppleIDButtonPress() {
        
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
    }
        
    
    private func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(), ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }


    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization)
    {
        //need to save details in firsttime
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let _ = appleIDCredential.user

            if let email = appleIDCredential.email {

                let fullName = appleIDCredential.fullName
                let Firstname = (fullName?.givenName)!
                let Lastname = (fullName?.familyName)!
                
                print("firts time")

                KeychainWrapper.standard.set(appleIDCredential, forKey: "appleCred")
                self.getCredentialsFomLoginAndCallApi(strFrstname: Firstname, strLastname: Lastname, strEmail: email)

            }

            else{
                
                if let appleCred = KeychainWrapper.standard.object(forKey: "appleCred") as? ASAuthorizationAppleIDCredential{
                    
                    let email = appleCred.email
                    let fullName = appleCred.fullName
                    let Firstname = (fullName?.givenName)!
                    let Lastname = (fullName?.familyName)!

                    self.getCredentialsFomLoginAndCallApi(strFrstname: Firstname, strLastname: Lastname, strEmail: email)
                }
                       
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error)
    {
        // Handle error.
    }
    
    func getCredentialsFomLoginAndCallApi(strFrstname: String?, strLastname: String?, strEmail: String?){
        

        let home = self.storyboard?.instantiateViewController(identifier: "homeViewController") as! homeViewController
        self.navigationController?.pushViewController(home, animated: true)

        
    }
    
    


}
extension loginViewController {
    
    func facebookSignup()
    {
        let fbLoginManager : LoginManager = LoginManager()
        
        fbLoginManager.logIn(permissions: ["email"], from: self, handler: { (result, error) -> Void in
            
            if (error == nil) {
                let fbloginresult : LoginManagerLoginResult = result!
                if(fbloginresult.isCancelled) {
                    //Show Cancel alert
                } else if(fbloginresult.grantedPermissions.contains("email")) {
                    self.returnUserData()
                }
                else {
                    print("fbbbbb = \(fbloginresult)")
                }
            }
        })
    }
    
    func returnUserData() {
        let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields":"id, name, picture.type(large), email"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil) {
                // Process error
                // print("\n\n Error: \(String(describing: error))")
            } else {
                let resultDic = result as! NSDictionary
                print("\n\n  fetched user: \(String(describing: resultDic))")
                
                var fname = ""
                var lname = ""
                
                if let name = resultDic.value(forKey:"name")! as? String{
                    let fullNameArr = name.components(separatedBy: " ")
                    fname = fullNameArr[0]
                    lname = fullNameArr[1]
                }
                let email = resultDic.value(forKey:"email")! as! String
                
            }
        })
    }
}



import Flutter
import UIKit
import GoogleMaps
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    GMSServices.provideAPIKey("AIzaSyCY0jKI9_p_dM-_arLQ4hWqLXktWo1OqT0")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  func application(_ app: UIApplication,
                   open url: URL,
                   options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    return GIDSignIn.sharedInstance.handle(url)
  }
  private func signIn(result: @escaping FlutterResult) {
      guard let clientID = FirebaseApp.app()?.options.clientID else {
        result("Error: Firebase client ID not found")
        return
      }

      let config = GIDConfiguration(clientID: clientID)
      GIDSignIn.sharedInstance().signIn(withPresenting: self) { [weak self] signInResult, error in
        guard error == nil else {
          result("Error: \(error!.localizedDescription)")
          return
        }

        guard let user = signInResult?.user, let idToken = user.authentication.idToken else {
          result("Error: Failed to retrieve user or ID token")
          return
        }

        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.authentication.accessToken)
        self?.authenticate(with: credential, result: result)
      }
    }

    private func authenticate(with credential: AuthCredential, result: @escaping FlutterResult) {
      Auth.auth().signIn(with: credential) { authResult, error in
        if let error = error {
          result("Error: \(error.localizedDescription)")
          return
        }
        result("Success: User authenticated")
      }
    }

    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
  }
}

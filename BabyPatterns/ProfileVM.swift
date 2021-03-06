import Common
import Framework_BabyPatterns
import Library
import UIKit

class ProfileVM: Loggable {
    let shouldPrintDebugLog = true

    // TODO: consider returning a URL to use Data methods instead of having to cast to NSData
    private var profileImageURLPath: String? {
        guard let userID = profile?.userID else { return nil }
        let documentDirectory = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])"
        let path = documentDirectory + "/user/profilePhoto/"
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path,
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)

            } catch let error {
                log("Problem creating image path: \(error.localizedDescription)", object: self, type: .error)
                return nil
            }
        }
        return path + userID
    }

    var profile: Profile?

    func loadProfile(completionHandler: @escaping () -> Void) {
        DatabaseFacade().configureDatabase(requestType: .profile, responseHandler: { responseArray in
            guard let data = responseArray.last else { completionHandler(); return }
            guard let babyName = data.json[K.JsonFields.BabyName] as? String else { completionHandler(); return }
            guard let parentName = data.json[K.JsonFields.ParentName] as? String else { completionHandler(); return }
            guard let email = data.json[K.JsonFields.Email] as? String else { completionHandler(); return }
            guard let userID = data.json[K.JsonFields.UserID] as? String else { completionHandler(); return }
            guard let babyDOB = Date(timeInterval: data.json[K.JsonFields.BabyDOB]) else {
                completionHandler()
                return
            }

            let maxSupply = data.json[K.JsonFields.DesiredMaxSupply] as? Int
            let desiredMaxSupplyAmount = maxSupply ?? K.Defaults.DefaultDesiredMaxSupply
            let maxSupplyAmount = SupplyAmount(value: desiredMaxSupplyAmount)

            self.profile = Profile(babyName: babyName,
                                   parentName: parentName,
                                   babyDOB: babyDOB,
                                   email: email,
                                   userID: userID,
                                   serverKey: data.serverKey,
                                   desiredMaxSupply: maxSupplyAmount)

            guard let imagePath = self.profileImageURLPath, FileManager.default.fileExists(atPath: imagePath) else {
                completionHandler()
                return
            }
            guard let imageData = NSData(contentsOfFile: imagePath), let image = UIImage(data: imageData as Data) else {
                completionHandler()
                return
            }

            self.profile?.profilePicture = image

            completionHandler()
        })

        //        StorageFacade().download(requestType: .profilePhoto, callback: { (data, error) in
        //            guard let data = data else {
        //                if let e = error {
        // Logger.log(message: e.localizedDescription,
        //    object: self,
        //  type: .error,
        //  shouldPrintDebugLog: self.shouldPrintDebugString)
        //                }
        //                return
        //            }
        //            if let image = UIImage(data: data) {
        //                self.profile?.profilePicture = image
        //            }
        //        })
    }

    func updateProfilePhoto(image: UIImage) {
        profile?.profilePicture = image
        let data = image.pngData()
        StorageFacade().uploadData(data: data!, requestType: .profilePhoto)

        guard let d = data, let path = profileImageURLPath else { return }
        (d as NSData).write(toFile: path, atomically: false)
    }

    func sendToServer() {
        guard let p = profile else {
            log("No profile to send to server...", object: self, type: .warning)
            return
        }
        profile?.serverKey = DatabaseFacade().uploadJSON(p.json(), requestType: .profile)
    }

    func profileUpdated() {
        guard let p = profile, let serverKey = p.serverKey else {
            log("Couldn't update profile. Either no profile or no server key...", object: self, type: .error)
            return }
        DatabaseFacade().updateJSON(p.json(), serverKey: serverKey, requestType: .profile)
    }
}

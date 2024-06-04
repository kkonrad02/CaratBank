import SwiftUI

class Authenticator{
    @State private var ipAddress: String = "46.41.143.149"
    @State private var serverPort: String = "80"
    
    init(){}
    
    public func saveUser(user: User, save: Bool){
        let data = [
            "save": save,
            "name": user.name,
            "lastname": user.lastname,
            "username": user.username,
            "requireConfirmation": user.requireConfirmation
        ] as? [String: Any]
        
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: data as Any, options: .prettyPrinted)
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileUrl = documentsDirectory.appendingPathComponent("savedUser.json")
            
            try jsonData.write(to: fileUrl)
        }catch{
            print("Error while creating json file: \(error.localizedDescription)")
        }
    }
    
    public func loadUser(completion: @escaping(User?) -> Void){
        do{
            let documentsDirecotry = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileUrl = documentsDirecotry.appendingPathComponent("savedUser.json")
            let jsonData = try Data(contentsOf: fileUrl)
            
            let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
            if let jsonDirectory = json as? [String: Any]{
                if let saved = jsonDirectory["save"] as? Bool, saved{
                    let user = User(
                        name: jsonDirectory["name"] as? String ?? "",
                        lastname: jsonDirectory["lastname"] as? String ?? "",
                        username: jsonDirectory["username"] as? String ?? "",
                        requireConfirmation: jsonDirectory["requireConfirmation"] as? Bool ?? false
                    )
                    
                    completion(user)
                }
            }
        }catch{
            print("Error while reading json: \(error.localizedDescription)")
        }
    }
    
    public func getIfSavedUser() -> Bool{
        do{
            let documentsDirecotry = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileUrl = documentsDirecotry.appendingPathComponent("savedUser.json")
            let jsonData = try Data(contentsOf: fileUrl)
            
            let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
            if let jsonDirectory = json as? [String: Any]{
                let saved = jsonDirectory["save"] as? Bool
                return saved ?? false
            }
        }catch{
            print("Error while reading json: \(error.localizedDescription)")
        }
        
        return false
    }
    
    public func storeToken(deviceToken: String, username: String){
        guard let url = URL(string: "http://\(self.ipAddress):\(self.serverPort)/api/token/storeToken") else{
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("c1a076947bc7fd89124673bad3ad6a8b", forHTTPHeaderField: "secret_access_token")
        
        let parameters: [String: Any] = [
            "deviceToken": deviceToken,
            "username": username
        ]
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        }catch{
            print("Error while serializing data: \(error.localizedDescription)")
        }
        
        URLSession.shared.dataTask(with: request){ data, _, error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else{
                print("No data found.")
                return
            }
            
            do{
                let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if let success = response?["success"] as? Bool, success{
                    //
                }else if let error = response?["error"] as? String{
                    print(error)
                }else{
                    print("Unknown error.")
                }
            }catch{
                print("Error while parsing data: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    public func sendNotification(message: String){
        guard let url = URL(string: "http://\(self.ipAddress):\(self.serverPort)/api/notification/sendNotification") else{
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("c1a076947bc7fd89124673bad3ad6a8b", forHTTPHeaderField: "secret_access_token")
        
        let parameters: [String: Any] = [
            "message": message
        ]
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        }catch{
            return
        }
        
        URLSession.shared.dataTask(with: request){ data, _, error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else{
                print("Brak danych.")
                return
            }
            
            do{
                let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if let success = response?["success"] as? Bool, success{
                    print("Wysłano powiadomienie.")
                }else if let error = response?["error"] as? String{
                    print(error)
                }else{
                    print("Nieznany błąd.")
                }
            }catch{
                print("Błąd podczas parsowania JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    public func signUp(user: User, completion: @escaping(String?) -> Void){
        guard let url = URL(string: "http://\(self.ipAddress):\(self.serverPort)/api/auth/signUp") else{
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("c1a076947bc7fd89124673bad3ad6a8b", forHTTPHeaderField: "secret_access_token")
        
        let parameters: [String: Any] = [
            "name": user.name,
            "lastname": user.lastname,
            "username": user.username,
            "password": user.password as Any,
            "passwordConfirm": user.passwordConfirm as Any
        ]
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        }catch{
            completion("Error while serializing data: \(error.localizedDescription)")
            return
        }
        
        URLSession.shared.dataTask(with: request){ data, _, error in
            if let error = error{
                completion(error.localizedDescription)
                return
            }
            
            guard let data = data else{
                completion("Brak danych.")
                return
            }
            
            do{
                let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if let success = response?["success"] as? Bool, success{
                    self.saveUser(user: user, save: true)
                    completion(nil)
                }else if let error = response?["error"] as? String{
                    completion(error)
                }else{
                    completion("Nieznany błąd.")
                }
            }catch{
                completion("Błąd parsowania JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    public func signIn(username: String, password: String, completion: @escaping(String?, User?) -> Void){
        guard let url = URL(string: "http://\(self.ipAddress):\(self.serverPort)/api/auth/signIn") else{
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("c1a076947bc7fd89124673bad3ad6a8b", forHTTPHeaderField: "secret_access_token")
        
        let parameters: [String: Any] = [
            "username": username,
            "password": password
        ]
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        }catch{
            completion("Error while serializing data: \(error.localizedDescription)", nil)
            return
        }
        
        URLSession.shared.dataTask(with: request){ data, _, error in
            if let error = error{
                completion(error.localizedDescription, nil)
                return
            }
            
            guard let data = data else{
                completion("Brak danych.", nil)
                return
            }
            
            do{
                let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if let success = response?["success"] as? Bool, success{
                    if let responseUser = response?["user"] as? [String: Any]{
                        let user = User(
                            name: responseUser["name"] as? String ?? "",
                            lastname: responseUser["lastname"] as? String ?? "",
                            username: responseUser["username"] as? String ?? "",
                            requireConfirmation: responseUser["requireConfirmation"] as? Bool ?? false
                        )
                        completion(nil, user)
                    }
                }else if let error = response?["error"] as? String{
                    completion(error, nil)
                }else{
                    completion("Nieznany błąd.", nil)
                }
            }catch{
                completion("Błąd parsowania JSON: \(error.localizedDescription)", nil)
            }
        }.resume()
    }
    
    public func getUserInfo(username: String, completion: @escaping(String?, User?) -> Void){
        if(username.isEmpty){
            completion("Proszę uzupełnić pola.", nil)
        }else{
            guard let url = URL(string: "http://\(self.ipAddress):\(self.serverPort)/api/user/getUserInfo") else{
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("c1a076947bc7fd89124673bad3ad6a8b", forHTTPHeaderField: "secret_access_token")
            
            
            let parameters: [String: Any] = [
                "username": username
            ]
            
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            }catch{
                return
            }
            
            URLSession.shared.dataTask(with: request){ data, _, error in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
                
                guard let data = data else{
                    print("Brak danych.")
                    return
                }
                
                do{
                    let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    
                    if let success = response?["success"] as? Bool, success{
                        if let responseUser = response?["user"] as? [String: Any]{
                            let newUser = User(
                                name: responseUser["name"] as? String ?? "",
                                lastname: responseUser["lastname"] as? String ?? "",
                                username: responseUser["username"] as? String ?? "",
                                requireConfirmation: responseUser["requireConfirmation"] as? Bool ?? false)
                            completion(nil, newUser)
                        }else{
                            completion("Błąd podczas pobierania informacji.", nil)
                        }
                    }else if let error = response?["error"] as? String{
                        completion(error, nil)
                    }else{
                        completion("Nieznany błąd.", nil)
                    }
                }catch{
                    completion("Błąd podczas parsowania JSON: \(error.localizedDescription)", nil)
                }
            }.resume()
        }
    }
    
    public func getUserHistory(username: String, completion: @escaping(String?, [HistoryItem]?) -> Void){
        guard let url = URL(string: "http://\(self.ipAddress):\(self.serverPort)/api/history/getUserHistory") else{
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("c1a076947bc7fd89124673bad3ad6a8b", forHTTPHeaderField: "secret_access_token")
        
        let parameters: [String: Any] = [
            "username": username
        ]
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        }catch{
            return
        }
        
        URLSession.shared.dataTask(with: request){ data, _, error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else{
                print("Brak danych.")
                return
            }
            
            do{
                let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if let success = response?["success"] as? Bool, success{
                    if let history = response?["history"] as? [[String: Any]]{
                        var returnItems: [HistoryItem] = []
                        
                        for item in history{
                            returnItems.append(HistoryItem(
                                title: item["title"] as? String ?? "",
                                date: item["date"] as? String ?? "",
                                amount: item["amount"] as? String ?? "",
                                currency: item["currency"] as? String ?? ""))
                        }
                        
                        completion(nil, returnItems)
                    }
                }else if let error = response?["error"] as? String{
                    completion(error, nil)
                }else{
                    completion("Nieznany błąd.", nil)
                }
            }catch{
                completion("Błąd podczas parsowania JSON: \(error.localizedDescription)", nil)
            }
        }.resume()
    }
    
    public func getAccountInfo(username: String, completion: @escaping(String?, Account?) -> Void){
        guard let url = URL(string: "http://\(self.ipAddress):\(self.serverPort)/api/account/getAccountInfo") else{
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("c1a076947bc7fd89124673bad3ad6a8b", forHTTPHeaderField: "secret_access_token")
        
        let parameters: [String: Any] = [
            "username": username
        ]
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        }catch{
            completion("Błąd podczas serializacji danych: \(error.localizedDescription)", nil)
            return
        }
        
        URLSession.shared.dataTask(with: request){ data, _, error in
            if let error = error{
                completion(error.localizedDescription, nil)
                return
            }
            
            guard let data = data else{
                completion("Brak danych.", nil)
                return
            }
            
            do{
                let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if let success = response?["success"] as? Bool, success{
                    if let responseAccount = response?["account"] as? [String: Any]{
                        let account = Account(
                            username: responseAccount["username"] as? String ?? "",
                            balance: responseAccount["balance"] as? Double ?? 0,
                            currency: responseAccount["currency"] as? String ?? "")
                        
                        completion(nil, account)
                    }
                }else if let error = response?["error"] as? String{
                    completion(error, nil)
                }else{
                    completion("Nieznany błąd.", nil)
                }
            }catch{
                completion("Błąd podczas parsowania JSON: \(error.localizedDescription)", nil)
            }
        }.resume()
    }
    
    public func withdrawMoney(username: String, amount: String, completion: @escaping(String?) -> Void){
        guard let url = URL(string: "http://\(self.ipAddress):\(self.serverPort)/api/money/withdrawMoney") else{
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("c1a076947bc7fd89124673bad3ad6a8b", forHTTPHeaderField: "secret_access_token")
        
        let parameters: [String: Any] = [
            "username": username,
            "amount": amount
        ]
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        }catch{
            return
        }
        
        URLSession.shared.dataTask(with: request){ data, _, error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else{
                print("Brak danych.")
                return
            }
            
            do{
                let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if let success = response?["success"] as? Bool, success{
                    completion(nil)
                }else if let error = response?["error"] as? String{
                    completion(error)
                }else{
                    completion("Nieznany błąd.")
                }
            }catch{
                completion("Błąd podczas parsowania JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    public func transferMoney(sender: String, reciever: String, amount: String, completion: @escaping(String?) -> Void){
        if(sender.isEmpty || reciever.isEmpty || amount.isEmpty){
            completion("Proszę uzupełnić pola.")
        }else{
            guard let url = URL(string: "http://\(self.ipAddress):\(self.serverPort)/api/money/transferMoney") else{
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("c1a076947bc7fd89124673bad3ad6a8b", forHTTPHeaderField: "secret_access_token")
            
            let parameters: [String: Any] = [
                "sender": sender,
                "reciever": reciever,
                "amount": amount
            ]
            
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            }catch{
                return
            }
            
            URLSession.shared.dataTask(with: request){ data, _, error in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
                
                guard let data = data else{
                    print("Brak danych.")
                    return
                }
                
                do{
                    let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    
                    if let success = response?["success"] as? Bool, success{
                        completion(nil)
                    }else if let error = response?["error"] as? String{
                        completion(error)
                    }else{
                        completion("Nieznany błąd.")
                    }
                }catch{
                    completion("Błąd podczas parsowania JSON: \(error.localizedDescription)")
                }
            }.resume()
        }
    }
    
    public func getConfirmations(username: String, completion: @escaping(String?, [ConfirmationItem]?) -> Void){
        guard let url = URL(string: "http://\(self.ipAddress):\(self.serverPort)/api/confirmation/getConfirmations") else{
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("c1a076947bc7fd89124673bad3ad6a8b", forHTTPHeaderField: "secret_access_token")
        
        let parameters: [String: Any] = [
            "username": username
        ]
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        }catch{
            return
        }
        
        URLSession.shared.dataTask(with: request){ data, _, error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else{
                print("Brak danych.")
                return
            }
            
            do{
                let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if let success = response?["success"] as? Bool, success{
                    if let confirmations = response?["statuses"] as? [[String: Any]]{
                        var returnItems: [ConfirmationItem] = []
                        
                        for item in confirmations{
                            returnItems.append(ConfirmationItem(
                                username: item["username"] as? String ?? "",
                                title: item["title"] as? String ?? "",
                                status: item["status"] as? String ?? ""))
                        }
                        
                        completion(nil, returnItems)
                    }else{
                        completion(nil, nil)
                    }
                }else if let error = response?["error"] as? String{
                    completion(error, nil)
                }else{
                    completion("Nieznany błąd.", nil)
                }
            }catch{
                completion("Błąd podczas parsowania JSON: \(error.localizedDescription)", nil)
            }
        }.resume()
    }
    
    public func changeConfirmation(username: String, option: String, completion: @escaping(String?) -> Void){
        if(username.isEmpty || option.isEmpty){
            completion("Proszę uzupełnić pola.")
        }else{
            guard let url = URL(string: "http://\(self.ipAddress):\(self.serverPort)/api/user/changeConfirmation") else{
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("c1a076947bc7fd89124673bad3ad6a8b", forHTTPHeaderField: "secret_access_token")
            
            let parameterOption = option == "Tak" ? true : false
            
            let parameters: [String: Any] = [
                "username": username,
                "requireOption": parameterOption
            ]
            
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            }catch{
                return
            }
            
            URLSession.shared.dataTask(with: request){ data, _, error in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
                
                guard let data = data else{
                    print("Brak danych.")
                    return
                }
                
                do{
                    let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    
                    if let success = response?["success"] as? Bool, success{
                        completion(nil)
                    }else if let error = response?["error"] as? String{
                        completion(error)
                    }else{
                        completion("Nieznany błąd.")
                    }
                }catch{
                    completion("Błąd podczas parsowania JSON: \(error.localizedDescription)")
                }
            }.resume()
        }
    }
    
    public func confirmConfirmation(username: String, title: String, status: String, completion: @escaping(String?) -> Void){
        if(username.isEmpty || title.isEmpty || status.isEmpty){
            completion("Proszę uzupełnić pola.")
        }else{
            guard let url = URL(string: "http://\(self.ipAddress):\(self.serverPort)/api/confirmation/confirm") else{
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("c1a076947bc7fd89124673bad3ad6a8b", forHTTPHeaderField: "secret_access_token")
            
            let parameters: [String: Any] = [
                "username": username,
                "title": title,
                "status": status
            ]
            
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            }catch{
                return
            }
            
            URLSession.shared.dataTask(with: request){ data, _, error in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
                
                guard let data = data else{
                    print("Brak danych.")
                    return
                }
                
                do{
                    let response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    
                    if let success = response?["success"] as? Bool, success{
                        completion(nil)
                    }else if let error = response?["error"] as? String{
                        completion(error)
                    }else{
                        completion("Nieznany błąd.")
                    }
                }catch{
                    completion("Błąd podczas parsowania JSON: \(error.localizedDescription)")
                }
            }.resume()
        }
    }
}

struct User: Equatable, Hashable{
    var name: String
    var lastname: String
    var username: String
    var password: String?
    var passwordConfirm: String?
    var requireConfirmation: Bool
}

struct Account{
    var username: String
    var balance: Double
    var currency: String
}

struct ConfirmationItem: Hashable{
    var username: String
    var title: String
    var status: String
}

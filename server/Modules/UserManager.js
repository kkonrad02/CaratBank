const fs = require('fs');
const crypto = require('crypto');
const money = require('./MoneyManager.js');
const history = require('./HistoryManager.js');

const hashPassword = (password) => {
    return crypto.createHash('md5').update(password).digest('hex');
}

const prepareFiles = () => {
    if(!fs.existsSync("./json/users.json")){
        const rawData = [
            {
                "name": "Root",
                "lastname": "Developer",
                "username": "root",
                "password": hashPassword("pswd123"),
                "requireConfirmation": true,
            },
            {
                "name": "Apple",
                "lastname": "Tester",
                "username": "appletester",
                "password": hashPassword("Pswd@123"),
                "requireConfirmation": true,
            }
        ];
        const jsonData = JSON.stringify(rawData, null, 2);
        fs.writeFileSync("./json/users.json", jsonData);
        history.addUser("root");
        history.addUser("appletester");
    }
}

const signIn = (username, password, callback) => {
    const rawData = fs.readFileSync("./json/users.json");
    const jsonData = JSON.parse(rawData);

    const foundUser = jsonData.find((user) => user.username == username);

    if(foundUser){
        if (foundUser.password == hashPassword(password)){
            var user = {
                "success": true,
                "user": {
                    "name": foundUser.name,
                    "lastname": foundUser.lastname,
                    "username": foundUser.username,
                    "requireConfirmation": foundUser.requireConfirmation
                },
            };

            callback(null, user);
        }else{
            callback("Nieprawidłowe hasło.", null);
        }
    }else{
        callback("Nie znaleziono takiego użytkownika.", null);
    }
}

const signUp = (name, lastname, username, password, passwordConfirm, callback) => {
    if(password == passwordConfirm){
        const rawData = fs.readFileSync("./json/users.json");
        const jsonData = JSON.parse(rawData);

        const userExists = jsonData.find((user) => user.username == username);

        if(userExists){
            callback(false, "Nazwa użytkownika jest już zajęta.");
        }else{
            const newUser = {
                "name": name,
                "lastname": lastname,
                "username": username,
                "password": hashPassword(password),
                "requireConfirmation": false,
            };

            jsonData.push(newUser);
            const resultData = JSON.stringify(jsonData, null, 2);
            fs.writeFileSync("./json/users.json", resultData);
            money.createAccount(username, (result) => {
                if (result){
                    callback(true, null);
                }else{
                    callback(false, "Błąd podczas tworzenia konta.");
                }
            });
        }
    }else{
        callback(false, "Hasła nie są takie same.");
    }
}

const getUserInfo = (username) => {
    const rawData = fs.readFileSync("./json/users.json");
    const jsonData = JSON.parse(rawData);

    const foundUser = jsonData.find((user) => user.username == username);

    if(foundUser){
        return {"success": true, "user": foundUser};
    }else{
        return {"error": "Nieznaleizono użytkownika."};
    }
}

module.exports = {
    prepareFiles,
    signIn,
    signUp,
    getUserInfo
}
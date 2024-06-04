const fs = require('fs');

const prepareFiles = () => {
    if(!fs.existsSync("./json/accounts.json")){
        const rawData = [{
            "username": "root",
            "balance": 100,
            "currency": "zł",
        }];
        const jsonData = JSON.stringify(rawData, null, 2);
        fs.writeFileSync("./json/accounts.json", jsonData);
    }
}

const createAccount = (username, callback) => {
    const rawData = fs.readFileSync("./json/accounts.json");
    const jsonData = JSON.parse(rawData);

    const accountExists = jsonData.find((user) => user.username == username);

    if(!accountExists){
        jsonData.push({
            "username": username,
            "balance": 0,
            "currency": "zł"
        });
        const resultData = JSON.stringify(jsonData, null, 2);
        fs.writeFileSync("./json/accounts.json", resultData);
        callback(true);
    }
};

const getAccountInfo = (username) => {
    const rawData = fs.readFileSync("./json/accounts.json");
    const jsonData = JSON.parse(rawData);

    const foundUser = jsonData.find((user) => user.username == username);

    if(foundUser){
        const resultData = {
            "success": true,
            "account": {
                "username": foundUser.username,
                "balance": foundUser.balance,
                "currency": foundUser.currency,
            }
        };

        return resultData;
    }else{
        return {"error": "Nieznaleziono użytkownika."};
    }
};

const withdrawMoney = (username, amount, callback) => {
    const rawData = fs.readFileSync("./json/accounts.json");
    const jsonData = JSON.parse(rawData);

    const foundUser = jsonData.find((user) => user.username == username);

    if (foundUser){
        var userBalance = foundUser.balance;
        var newBalance = ((amount * 1) + (userBalance * 1));
        foundUser.balance = newBalance;
        const resultData = JSON.stringify(jsonData, null, 2);
        fs.writeFileSync("./json/accounts.json", resultData);
        callback(true, null);
    }else{
        callback(false, "Nie znaleziono użytkownika.");
    }
};

const transferMoney = (sender, reciever, amount, callback) => {
    const rawData = fs.readFileSync("./json/accounts.json");
    const jsonData = JSON.parse(rawData);

    const foundSender = jsonData.find((user) => user.username == sender);

    if(foundSender){
        const foundReciever = jsonData.find((user) => user.username == reciever);

        if(foundReciever){
            const stringSenderBalance = foundSender.balance;
            const floatSenderBalance = parseFloat(stringSenderBalance).toFixed(2);
            const stringRecieverBalance = foundReciever.balance;
            const floatRecieverBalance = parseFloat(stringRecieverBalance).toFixed(2);

            if (amount <= floatSenderBalance){
                var newSenderBalance = ((floatSenderBalance * 1) - (amount * 1)); 
                foundSender.balance = parseFloat(newSenderBalance);
                var newRecieverBalance = ((floatRecieverBalance * 1) + (amount * 1));
                foundReciever.balance = parseFloat(newRecieverBalance);

                const resultData = JSON.stringify(jsonData, null, 2);
                fs.writeFileSync("./json/accounts.json", resultData);
                callback(true, null);
            }else{
                callback(false, "Nie masz wystarczająco środków na koncie.");
            }
        }else{
            callback(false, "Nie znaleziono takiego odbiorcy.");
        }
    }else{
        callback(false, "Nie znaleziono użytkownika.");
    }
}

module.exports = {
    prepareFiles,
    createAccount,
    getAccountInfo,
    withdrawMoney,
    transferMoney
}
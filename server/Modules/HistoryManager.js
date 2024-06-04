const fs = require('fs');

const getDate = () => {
    let date_ob = new Date();

    let date = ("0" + date_ob.getDate()).slice(-2);
    let month = ("0" + (date_ob.getMonth() + 1)).slice(-2);
    let year = date_ob.getFullYear();

    let hours = date_ob.getHours();
    let minutes = date_ob.getMinutes();
    let seconds = date_ob.getSeconds();

    return(date + "-" + month + "-" + year + " " + hours + ":" + minutes + ":" + seconds);
}

const prepareFiles = () => {
    if(!fs.existsSync("./json/history.json")){
        const rawData = [];
        const resultData = JSON.stringify(rawData);
        fs.writeFileSync("./json/history.json", resultData);
    }
};

const addUser = (username) => {
    if(!fs.existsSync('./json/history.json')){
        prepareFiles();
        addUser(username);
    }else{
        const rawData = fs.readFileSync("./json/history.json");
        const jsonData = JSON.parse(rawData);

        const foundUser = jsonData.find((user) => user.username == username);

        if(!foundUser){
            const newUser = {
                "username": username,
                "history": []
            };

            jsonData.push(newUser);
            const resultData = JSON.stringify(jsonData, null, 2);
            fs.writeFileSync("./json/history.json", resultData);
        }
    }
};

const addWithdraw = (username, amount, currency) => {
    const rawData = fs.readFileSync("./json/history.json");
    const jsonData = JSON.parse(rawData);

    const foundUser = jsonData.find((user) => user.username == username);

    if(foundUser){
        const newItem = {
            "title": "Wpłata na konto",
            "date": getDate(),
            "amount": amount,
            "currency": currency
        };

        foundUser.history.push(newItem);
        const resultData = JSON.stringify(jsonData, null, 2);
        fs.writeFileSync("./json/history.json", resultData);
    }
};

const addHistoryItem = (username, amount, title, currency) => {
    const rawData = fs.readFileSync("./json/history.json");
    const jsonData = JSON.parse(rawData);

    const foundUser = jsonData.find((user) => user.username == username);

    if(foundUser){
        const newItem = {
            "title": title,
            "date": getDate(),
            "amount": amount,
            "currency": currency
        };

        foundUser.history.push(newItem);
        const resultData = JSON.stringify(jsonData, null, 2);
        fs.writeFileSync("./json/history.json", resultData);
    }
};

const getUserHistory = (username, callback) => {
    const rawData = fs.readFileSync("./json/history.json");
    const jsonData = JSON.parse(rawData);

    const foundUser = jsonData.find((user) => user.username == username);

    if(!foundUser){
        callback(null, "Nie znaleziono użytkownika.");
    }else{
        const history = foundUser.history;
        callback(history, null);
    }
};

module.exports = {
    prepareFiles,
    addUser,
    addWithdraw,
    getUserHistory,
    addHistoryItem
}
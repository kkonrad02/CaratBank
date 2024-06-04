const fs = require('fs');

const prepareFiles = () => {
    if(!fs.existsSync("./json/confirmations.json")){
        fs.writeFileSync("./json/confirmations.json", JSON.stringify([]));
    }
};

const addConfirmation = (username, title, callback) => {
    const rawData = fs.readFileSync("./json/confirmations.json");
    const jsonData = JSON.parse(rawData);

    const foundItem = jsonData.find((item) => ((item.username == username) && (item.title == title)));

    if(foundItem){
        callback(false, "Jedno potwierdzenie czeka w kolejce...");
    }else{
        const newItem = {
            "username": username,
            "title": title,
            "status": "Oczekuje"
        };
    
        jsonData.push(newItem);
        const resultData = JSON.stringify(jsonData, null, 2);
        fs.writeFileSync("./json/confirmations.json", resultData);
        callback(true, null);
    }
};

const checkStatus = (username, title, callback) => {
    const rawData = fs.readFileSync("./json/confirmations.json");
    const jsonData = JSON.parse(rawData);

    const foundUser = jsonData.find((item) => ((item.username == username) && (item.title == title)));

    if(foundUser){
        const status = foundUser.status;

        if(status == "Oczekuje"){
            callback(false, null);
        }else if(status == "declined"){
            const newData = jsonData.filter((item) => !((item.username == username) && (item.title == title)));
            const resultData = JSON.stringify(newData, null, 2);
            fs.writeFileSync("./json/confirmations.json", resultData);
            callback(true, false)
        }else if(status == "confirmed"){
            const newData = jsonData.filter((item) => !((item.username == username) && (item.title == title)));
            const resultData = JSON.stringify(newData, null, 2);
            fs.writeFileSync("./json/confirmations.json", resultData);
            callback(true, true);
        }
    }else{
        callback(false, null);
    }
};

const confirmStatus = (username, title, status, callback) => {
    const rawData = fs.readFileSync("./json/confirmations.json");
    const jsonData = JSON.parse(rawData);

    const foundStatus = jsonData.find((item) => ((item.username == username) && (item.title == title)));

    if(foundStatus){
        foundStatus.status = status;
        const resultData = JSON.stringify(jsonData, null, 2);
        fs.writeFileSync('./json/confirmations.json', resultData);
        callback(true, null);
    }else{
        callback(false, "Nie znaleziono użytkownika");
    }
} 

const getStatuses = (username) => {
    const rawData = fs.readFileSync("./json/confirmations.json");
    const jsonData = JSON.parse(rawData);

    const foundStatuses = jsonData.filter((item) => item.username == username);

    return foundStatuses;
}

const checkIfRequireConfirmation = (username) => {
    const rawData = fs.readFileSync("./json/users.json");
    const jsonData = JSON.parse(rawData);

    const foundUser = jsonData.find((user) => user.username == username);

    if(foundUser){
        return foundUser.requireConfirmation;
    }else{
        return false;
    }
};

const changeRequireStatus = (username, requireOption) => {
    const rawData = fs.readFileSync("./json/users.json");
    const jsonData = JSON.parse(rawData);

    const foundUser = jsonData.find((user) => user.username == username);

    if(foundUser){
        foundUser.requireConfirmation = requireOption;
        const resultData = JSON.stringify(jsonData, null, 2);
        fs.writeFileSync("./json/users.json", resultData);
    }
};

module.exports = {
    prepareFiles,
    addConfirmation,
    checkStatus,
    confirmStatus,
    getStatuses,
    checkIfRequireConfirmation,
    changeRequireStatus
};
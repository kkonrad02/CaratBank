const fs = require('fs');

const prepareFiles = () => {
    if (!fs.existsSync("./json/tokens.json")){
        const rawData = [];
        const parsedData = JSON.stringify(rawData);

        fs.writeFileSync("./json/tokens.json", parsedData);
    }
};

const storeToken = (deviceToken, username) => {
    const rawData = fs.readFileSync("./json/tokens.json");
    const jsonData = JSON.parse(rawData);

    const tokenExists = jsonData.find((token) => token.token == deviceToken);

    if(!tokenExists){
        jsonData.push({
            "token": deviceToken,
            "username": username,
        });

        const resultData = JSON.stringify(jsonData);
        fs.writeFileSync("./json/tokens.json", resultData);
    }else{
        tokenExists.username = username;
        const resultData = JSON.stringify(jsonData, null, 2);
        fs.writeFileSync("./json/tokens.json", resultData);
    }
};

const getTokens = () => {
    const rawData = fs.readFileSync('./json/tokens.json');
    const jsonData = JSON.parse(rawData);

    return jsonData;
};

module.exports = {
    prepareFiles,
    storeToken,
    getTokens,
}
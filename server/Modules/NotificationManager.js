const apn = require('apn');
const token = require('./TokenManager.js');
const fs = require('fs');

const sendNotification = (deviceToken, message) => {
    var options = {
        token: {
            key: "./certificates/P8/AuthKey_9P59A5QAXQ.p8",
            keyId: "9P59A5QAXQ",
            teamId: "LPN7TY37A3",
        },
        production: false,
    };

    var apnProvider = new apn.Provider(options);
    var note = new apn.Notification();

    note.sound = "ping.aiif";
    note.alert = message;
    note.topic = "com.kkonrad02.CaratBank";

    apnProvider.send(note, deviceToken).then((result) => {
        console.log(result.failed);
        console.log("[NotificationManager] Notification has been sent.");
    });
};

const sendNotificationToAllUsers = (message) => {
    const tokens = token.getTokens();
    
    tokens.forEach(token => {
        sendNotification(token["token"], message);
    });
};

const sendNotificationToUsername = (username, message) => {
    const rawData = fs.readFileSync("./json/tokens.json");
    const jsonData = JSON.parse(rawData);

    const foundUser = jsonData.filter((user) => user.username == username);

    if(foundUser){
        foundUser.forEach((user) => {
            var token = user.token;
    
            sendNotification(token, message);
        })
    }else{
        console.log("[NotificationManager] Username not found.");
    }
};

module.exports = {
    sendNotification,
    sendNotificationToAllUsers,
    sendNotificationToUsername
}
const express = require('express');
const token = require('../Modules/TokenManager.js');
const notification = require('../Modules/NotificationManager.js');
const user = require('../Modules/UserManager.js');
const money = require('../Modules/MoneyManager.js');
const history = require("../Modules/HistoryManager.js");
const confirmation = require("../Modules/ConfirmationManager.js");
const router = express.Router();
require('dotenv').config();

const api_token = process.env.API_TOKEN;

router.post('/api/token/storeToken', (req, res) => {
    if(req.headers.secret_access_token != api_token){
        res.json({"error": "Unauthorized access."});
    }else{
        const deviceToken = req.body.deviceToken;
        const username = req.body.username;
        if(!deviceToken || !username){
            res.json({"error": "Invalid request parameters."});
        }else{
            token.storeToken(deviceToken, username);
            res.json({"success": true});
        }
    }
});

router.post('/api/auth/signin', (req, res) => {
    if(req.headers.secret_access_token != api_token){
        res.json({"error": "Unauthorized access."});
    }else{
        const username = req.body.username;
        const password = req.body.password;

        if(username && password){
            user.signIn(username, password, (error, user) => {
                if (error){
                    res.json({"error": error});
                }else{
                    res.json(user);
                }
            });
        }else{
            res.json({"error": "Proszę uzupełnić pola."});
        }
    }
});

router.post('/api/auth/signUp', (req, res) => {
    if(req.headers.secret_access_token != api_token){
        res.json({"error": "Unauthorized access."});
    }else{
        const name = req.body.name;
        const lastname = req.body.lastname;
        const username = req.body.username;
        const password = req.body.password;
        const passwordConfirm = req.body.passwordConfirm;

        if (name && lastname && username && password && passwordConfirm){
            user.signUp(name, lastname, username, password, passwordConfirm, (success, error) => {
                if (success){
                    history.addUser(username);
                    notification.sendNotificationToAllUsers(`Właśnie ${name} dołącza do naszego zespołu! 🥳`);
                    res.json({"success": true});
                }else{
                    res.json({"error": error});
                }
            });
        }else{
            res.json({"error": "Proszę uzupełnić pola."});
        }
    }
});

router.post('/api/user/getUserInfo', (req, res) => {
    if(req.headers.secret_access_token != api_token){
        res.json({"error": "Unauthorized access."});
    }else{
        const username = req.body.username;

        if(username){
            const authResult = user.getUserInfo(username);
            res.json(authResult);
        }else{
            res.json({"error": "Invalid request parameters."});
        }
    }
});

router.post('/api/history/getUserHistory', (req, res) => {
    if(req.headers.secret_access_token != api_token){
        res.json({"error": "Unauthorized access."});
    }else{
        const username = req.body.username;

        if(username){
            history.getUserHistory(username, (history, error) => {
                if(history){
                    res.json({
                        "success": true,
                        "history": history.reverse()
                    });
                }else{
                    res.json({"error": error});
                }
            });
        }else{
            res.json({"error": "Proszę uzupełnić pola."});
        }
    }
});

router.post('/api/account/getAccountInfo', (req, res) => {
    if(req.headers.secret_access_token != api_token){
        res.json({"error": "Unauthorized access."});
    }else{
        const username = req.body.username;

        if(username){
            const result = money.getAccountInfo(username);

            res.json(result);
        }else{
            res.json({"error": "Proszę uzupełnić pola."});
        }
    }
});

router.post('/api/money/withdrawMoney', (req, res) => {
    if(req.headers.secret_access_token != api_token){
        res.json({"error": "Unauthorized access."});
    }else{
        const username = req.body.username;
        const amount = req.body.amount;


        if(username && amount){
            const replacedAmount = amount.replace(",", ".");
            const floatRegex = /^\d+(\.\d{1,2})?$/;
            if(!isNaN(replacedAmount)){
                if(floatRegex.test(replacedAmount)){
                    var amountFloat = parseFloat(replacedAmount).toFixed(2);
                    money.withdrawMoney(username, amountFloat, (success, alert) => {
                        if(success){
                            history.addWithdraw(username, String(amountFloat), "zł");
                            res.json({"success": true});
                        }else{
                            res.json({"error": alert});
                        }
                    });
                }else{
                    res.json({"error": "Proszę podać maksymalnie dwie cyfry po przecinku!"});
                }
            }else{
                res.json({"error": "Proszę podać poprawną liczbę."});
            }
        }else{
            res.json({"error": "Proszę uzupełnić pola."});
        }
    }
});

router.post('/api/money/transferMoney', (req, res) => {
    if(req.headers.secret_access_token != api_token){
        res.json({"error": "Unauthorized access."});
    }else{
        const sender = req.body.sender;
        const reciever = req.body.reciever;
        const amount = req.body.amount;

        if(sender && reciever && amount){
            const replacedAmount = amount.replace(",", ".");
            const floatRegex = /^\d+(\.\d{1,2})?$/;
            if(!isNaN(replacedAmount)){
                if(floatRegex.test(replacedAmount)){
                    var amountFloat = parseFloat(replacedAmount).toFixed(2);
                    
                    money.transferMoney(sender, reciever, amountFloat, (success, error) => {
                        if (success){
                            history.addHistoryItem(sender, "-" + String(amountFloat), "Przelew na konto", "zł");
                            history.addHistoryItem(reciever, String(amountFloat), "Wpłata na konto", "zł");
                            notification.sendNotificationToUsername(reciever, "Dostałeś właśnie wpłatę na konto! 😄");
                            res.json({"success": true});
                        }else{
                            res.json({"error": error});
                        }
                    });
                }else{
                    res.json({"error": "Proszę podać maksymalnie dwie cyfry po przecinku!"});
                }
            }else{
                res.json({"error": "Proszę podać poprawną liczbę."});
            }
        }else{
            res.json({"error": "Proszę uzupełnić pola."});
        }
    }
});

router.post('/api/confirmation/getConfirmations', (req, res) => {
    if(req.headers.secret_access_token != api_token){
        res.json({"error": "Unauthorized access."});
    }else{
        const username = req.body.username;

        if(username){
            const result = confirmation.getStatuses(username);

            res.json({"success": true, "statuses": result});
        }else{
            res.json({"error": "Proszę uzupełnić pola."});
        }
    }
});

router.post('/api/confirmation/confirm', (req, res) => {
    if(req.headers.secret_access_token != api_token){
        res.json({"error": "Unauthorized access."});
    }else{
        const username = req.body.username;
        const title = req.body.title;
        const status = req.body.status;

        if(username && title && status){
            confirmation.confirmStatus(username, title, status, (success, error) => {
                if (success){
                    res.json({"success": true});
                }else{
                    res.json({"error": error});
                }
            });
        }else{
            res.json({"error": "Invalid request parameters."});
        }
    }
});

router.post('/api/user/changeConfirmation', (req, res) => {
    if(req.headers.secret_access_token != api_token){
        res.json({"error": "Unauthorized access."});
    }else{
        const username = req.body.username;
        const requireOption = req.body.requireOption;

        if(username && (requireOption == true || requireOption == false)){
            confirmation.changeRequireStatus(username, requireOption);
            res.json({"success": true});
        }else{
            res.json({"error": "Invalid request parameters."});
        }
    }
});

router.post('/api/notification/sendNotification', (req, res) => {
    if(req.headers.secret_access_token != api_token){
        res.json({"error": "Unauthorized access."});
    }else{
        const message = req.body.message;

        if(!message){
            res.json({"error": "Invalid request parameters."});
        }else{
            notification.sendNotificationToAllUsers(message);
        }
    }
});

module.exports = router;
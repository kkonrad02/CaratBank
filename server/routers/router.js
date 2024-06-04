const express = require('express');
const session = require('express-session');
const user = require('../Modules/UserManager.js');
const confirmation = require("../Modules/ConfirmationManager.js");
const notification = require("../Modules/NotificationManager.js");
const money = require("../Modules/MoneyManager.js");
const router = express.Router();

router.use(session({
    secret: 'secret',
    resave: true,
    saveUninitialized: true
}));

router.get('/', (req, res) => {
    res.render('index');
    // req.session.loggedIn = true;
    // req.session.user = {"name": "Konrad", "lastname": "Krawczyk", "username": "kkonrad02"};
    // res.redirect('/home');
});

router.get('/signin', (req, res) => {
    if(req.session.notification){
        const notification = req.session.notification;
        req.session.notification = null;
        res.render('signin', {
            notification: notification
        });
    }else{
        res.render('signin');
    }
});

router.get('/home', (req, res) => {
    const loggedIn = req.session.loggedIn;
    const user = req.session.user;
    const account = req.session.account;
    console.log(account)

    if(!loggedIn){
        res.redirect('/auth/logout');
    }else{
        res.render('home', {
            user: user,
            account: account
        });
    }
});

router.post('/auth/signin', (req, res) => {
    const username = req.body.username;
    const password = req.body.password;

    if(username && password){
        user.signIn(username, password, (error, user) => {
            if(user){
                req.session.user = user.user;
                if(confirmation.checkIfRequireConfirmation(username)){
                    res.redirect('/auth/confirmAuthentication');
                }else{
                    const account = money.getAccountInfo(username).account;
                    req.session.loggedIn = true;
                    req.session.account = account;
                    res.redirect('/home');
                }
            }else{
                req.session.notification = error;
                res.redirect('/signin');
            }
        });
    }else{
        req.session.notification = "Proszę uzupełnić pola!";
        res.redirect('/signin')
    }
});

router.get('/auth/confirmAuthentication', (req, res) => {
    res.render('confirmSignin');
});

router.get('/auth/addConfirmation', (req, res) => {
    var username = req.session.user.username;
    confirmation.addConfirmation(username, "Logowanie na stronie", (success, error) => {
        if(success){
            req.session.signinSuccess= true;
            req.session.confirmationTitle = "Logowanie na stronie"
            notification.sendNotificationToUsername(username, "Masz nowe potwierdzenie.");
            res.redirect('/auth/checkConfirmation');
        }else{
            req.session.notification = error;
            res.redirect('/signin');
        }
    });
});

router.get('/auth/checkConfirmation', (req, res) => {
    if(req.session.signinSuccess){
        req.session.signinSuccess = null;
        const confirmationTitle = req.session.confirmationTitle;
        const user = req.session.user;

        const checkLogged = () => {
            confirmation.checkStatus(user.username, confirmationTitle, (confirmed, status) => {
                if (confirmed) {
                    req.session.confirmationTitle = null;
                    clearInterval(interval);
                    if (status) {
                        const account = money.getAccountInfo(user.username).account;
                        req.session.account = account;
                        req.session.loggedIn = true;
                        res.redirect('/home');
                    } else {
                        req.session.user = null;
                        req.session.notification = "Odrzucono logowanie.";
                        res.redirect('/signin');
                    }
                }
            });
        };
        const interval = setInterval(checkLogged, 1000);
    }
});

router.get('/auth/logout', (req, res) => {
    req.session.destroy();
    res.redirect('/');
});

module.exports = router;
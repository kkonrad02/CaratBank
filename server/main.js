const express = require('express');
const session = require('express-session');
const path = require('path');
const apiRouter = require('./routers/apiRouter.js');
const router = require('./routers/router.js');
const token = require('./Modules/TokenManager.js');
const user = require('./Modules/UserManager.js');
const money = require('./Modules/MoneyManager.js');
const history = require("./Modules/HistoryManager.js");
const confirmation = require('./Modules/ConfirmationManager.js');
const exphbs = require('express-handlebars');
require('dotenv').config();

const app = express();
const serverPort = process.env.SERVER_PORT;

app.set('view engine', 'hbs');
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(session({
    secret: "secret",
    resave: true,
    saveUninitialized: true
}));
app.use(express.static(path.join(__dirname, 'assets')));

app.all('/api/*', apiRouter);
app.all('*', router);

app.listen(serverPort, () => {
    token.prepareFiles();
    user.prepareFiles();
    money.prepareFiles();
    history.prepareFiles();
    confirmation.prepareFiles();
    console.log(`[CaratBank] Server has started at port: ${serverPort}`);
});
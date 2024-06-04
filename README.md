<h1>Carat Bank</h1>
<h2>O Aplikacji</h2>
<p>Aplikacja na zasadzie działaniu apliakcji bankowej. Została stworzona w celach nauki o API. Postawiona jest również strona aplikacji na adresie 46.41.143.149. Za pomocą aplikacji można utworzyć konto, wpłacić fikcyjne pieniądze, 
  wysyłać przelewy czy autoryzować działania wykonywane na stronie internetowej.</p>
<h2>O serwerze</h2>
<p>Serwer został postawiony przy użyciu NodeJS i takich bibliotek jak:</p>
<ol>
  <li>APN</li>
  <li>Crypto</li>
  <li>DotEnv</li>
  <li>Nodemon</li>
  <li>Express</li>
  <li>Express-Session</li>
  <li>Express-Handlebars</li>
</ol>
<p>W celu włączenia serwera lokalnie wymagane jest ponowne zainstalowanie bibliotek w głównym folderze serwera. Wykonamy to z komendą:</p>
<pre>npm i apn crypto dotenv nodemon express express-session express-handlebars</pre>
<p>Oraz trzeba wprowadzić adres IP maszyny na którym jest uruchamiany serwer lokalnie w pliku aplikacji <pre>Components/Authenticator.swift/ipAddress</pre></p>

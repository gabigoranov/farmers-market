<h1>Market API</h1>
<ul>
  <li>Документация на API за проекта Електронен Фермерски Пазар.</li>
  <li>Направено на .NET Core Web API с програмния език C#.</li>
  <li>Използвани са технологий като SQLSERVER за база данни и EFC за комуникация с нея.</li>
  <li>Използва се Firebase за място за съхранение на снимки и за изпращане на нотификации.</li>
</ul>


<h1>Съдържание</h1>

<img src="https://github.com/user-attachments/assets/e5162818-92f2-4a55-88b2-34cebc608376" />

<h1>Инсталация</h1>
<p>За да се инсталира е нужен Visual Studio, Rider или друга среда за разработка, която поддържа .NET Core и SQLSERVER база данни, хостната или локална.</p>
<h2>Стъпки:</h2>
<ul>
    <li>Изтеглете проекта</li>
    <li>Отворете проекта в средата ви за разработка</li>
    <li>Въведете линк към база данни в appsettings.json файла</li>
    <li>Стартирайте приложението</li>
</ul>


<h1>Започване</h1>
<ul>
  <li>След стартиране на приложението ще видите Swagger, инструмент улесняващ използването на приложението.</li>
  <li>Всяка функция е разделена в различни контролери.</li>
  Повече за функционирането на подобни APIта може да намерите тук https://dotnet.microsoft.com/en-us/apps/aspnet/apis</li>
  <li>При нужда за конфигуриране на моделите се обърнете към папката Data/Models/</li>
</ul>
<h1>Използване</h1>

<h1>Документация на UsersController</h1>
<p>Тази документация предоставя преглед на <code>UsersController</code> в MarketAPI. Този контролер обработва операции, свързани с потребителите, включително вход, извличане на потребители, добавяне на потребители, редактиране на потребители и изтриване на потребители.</p>
<h2>Основен маршрут</h2>
<p><strong>Маршрут:</strong> <code>api/Users</code></p>
<h2>Вход</h2>
<p><strong>Крайна точка:</strong> <code>GET api/Users/login</code></p>
<p><strong>Описание:</strong> Удостоверява потребител по имейл и парола, връщайки данни за потребителя, ако е успешен.</p>
<p><strong>Параметри:</strong></p>
<ul>
    <li><code>email</code> (string): Имейл на потребителя.</li>
    <li><code>password</code> (string): Парола на потребителя.</li>
</ul>
<p><strong>Отговори:</strong></p>
<ul>
    <li><code>200 OK</code>: Връща данните за потребителя (или Продавач, или Потребител).</li>
    <li><code>400 BadRequest</code>: Потребител с предоставените имейл и парола не съществува.</li>
</ul>
<h2>Получаване на потребител по ID</h2>
<p><strong>Крайна точка:</strong> <code>GET api/Users/getWithId</code></p>
<p><strong>Описание:</strong> Извлича потребител по неговото ID, връщайки данни за потребителя, ако бъде намерен.</p>
<p><strong>Параметри:</strong></p>
<ul>
    <li><code>id</code> (Guid): ID на потребителя.</li>
</ul>
<p><strong>Отговори:</strong></p>
<ul>
    <li><code>200 OK</code>: Връща данните за потребителя (или Продавач, или Потребител).</li>
    <li><code>400 BadRequest</code>: Потребител с предоставеното ID не съществува.</li>
</ul>
<h2>Добавяне на потребител</h2>
<p><strong>Крайна точка:</strong> <code>POST api/Users/add</code></p>
<p><strong>Описание:</strong> Добавя нов потребител в базата данни.</p>
<p><strong>Тяло на заявката:</strong></p>
<ul>
    <li>Обект <code>User</code>: Съдържа данните за потребителя.
        <ul>
            <li><code>FirstName</code> (string): Първото име на потребителя.</li>
            <li><code>LastName</code> (string): Фамилното име на потребителя.</li>
            <li><code>Email</code> (string): Имейл на потребителя.</li>
            <li><code>PhoneNumber</code> (string): Телефонен номер на потребителя.</li>
            <li><code>Age</code> (int): Възраст на потребителя.</li>
            <li><code>Description</code> (string): Описание на потребителя.</li>
            <li><code>Password</code> (string): Парола на потребителя.</li>
            <li><code>Rating</code> (double): Рейтинг на потребителя (по подразбиране 0.0).</li>
            <li><code>Town</code> (string): Град на потребителя.</li>
            <li><code>isSeller</code> (bool): Показва дали потребителят е продавач.</li>
        </ul>
    </li>
</ul>
<p><strong>Отговори:</strong></p>
<ul>
    <li><code>200 OK</code>: Връща съобщение, че потребителят е успешно добавен.</li>
    <li><code>400 BadRequest</code>: Потребител с предоставения имейл вече съществува в базата данни.</li>
</ul>
<h2>Редактиране на потребител</h2>
<p><strong>Крайна точка:</strong> <code>POST api/Users/edit</code></p>
<p><strong>Описание:</strong> Редактира данните на съществуващ потребител.</p>
<p><strong>Тяло на заявката:</strong></p>
<ul>
    <li>Обект <code>User</code>: Съдържа актуализираните данни на потребителя.
        <ul>
            <li><code>Id</code> (Guid): ID на потребителя.</li>
            <li><code>FirstName</code> (string): Първото име на потребителя.</li>
            <li><code>LastName</code> (string): Фамилното име на потребителя.</li>
            <li><code>Email</code> (string): Имейл на потребителя.</li>
            <li><code>PhoneNumber</code> (string): Телефонен номер на потребителя.</li>
            <li><code>Age</code> (int): Възраст на потребителя.</li>
            <li><code>Description</code> (string): Описание на потребителя.</li>
        </ul>
    </li>
</ul>
<p><strong>Отговори:</strong></p>
<ul>
    <li><code>200 OK</code>: Връща съобщение, че потребителят е успешно редактиран.</li>
    <li><code>400 BadRequest</code>: Предоставените данни за потребителя са невалидни.</li>
</ul>
<h2>Изтриване на потребител</h2>
<p><strong>Крайна точка:</strong> <code>DELETE api/Users/delete</code></p>
<p><strong>Описание:</strong> Изтрива потребител от базата данни.</p>
<p><strong>Параметри:</strong></p>
<ul>
    <li><code>id</code> (Guid): ID на потребителя за изтриване.</li>
</ul>
<p><strong>Отговори:</strong></p>
<ul>
    <li><code>200 OK</code>: Връща съобщение, че потребителят е успешно изтрит.</li>
    <li><code>400 BadRequest</code>: Невалидно ID на потребителя.</li>
</ul>


 <h1>Документация на OffersController</h1> <p>Тази документация предоставя преглед на <code>OffersController</code> в MarketAPI. Този контролер обработва операции, свързани с офертите, включително извличане на всички оферти, търсене, добавяне, редактиране и изтриване на оферти.</p> <h2>Основен маршрут</h2> <p><strong>Маршрут:</strong> <code>api/Offers</code></p> <h2>Извличане на всички оферти</h2> <p><strong>Крайна точка:</strong> <code>GET api/Offers/getAll</code></p> <p><strong>Описание:</strong> Извлича всички оферти от базата данни.</p> <p><strong>Отговори:</strong></p> <ul> <li><code>200 OK</code>: Връща списък с всички оферти.</li> </ul> <h2>Търсене на оферти</h2> <p><strong>Крайна точка:</strong> <code>GET api/Offers/search</code></p> <p><strong>Описание:</strong> Търси оферти по въведен текст и предпочитан град.</p> <p><strong>Параметри:</strong></p> <ul> <li><code>input</code> (string): Въведен текст за търсене.</li> <li><code>prefferedTown</code> (string): Предпочитан град за търсене.</li> </ul> <p><strong>Отговори:</strong></p> <ul> <li><code>200 OK</code>: Връща списък с намерените оферти.</li> </ul> <h2>Търсене на оферти по категория</h2> <p><strong>Крайна точка:</strong> <code>GET api/Offers/categorySearch</code></p> <p><strong>Описание:</strong> Търси оферти по категория и предпочитан град.</p> <p><strong>Параметри:</strong></p> <ul> <li><code>prefferedTown</code> (string): Предпочитан град за търсене.</li> <li><code>category</code> (string): Категория за търсене.</li> </ul> <p><strong>Отговори:</strong></p> <ul> <li><code>200 OK</code>: Връща списък с намерените оферти.</li> </ul> <h2>Добавяне на оферта</h2> <p><strong>Крайна точка:</strong> <code>POST api/Offers/add</code></p> <p><strong>Описание:</strong> Добавя нова оферта в базата данни.</p> <p><strong>Тяло на заявката:</strong></p> <ul> <li>Обект <code>OfferViewModel</code>: Съдържа данните за офертата. <ul> <li><code>Title</code> (string): Заглавие на офертата.</li> <li><code>Description</code> (string): Описание на офертата.</li> <li><code>PricePerKG</code> (double): Цена на килограм.</li> <li><code>StockId</code> (int): ID на наличностите.</li> <li><code>OwnerId</code> (int): ID на собственика.</li> <li><code>Town</code> (string): Град.</li> </ul> </li> </ul> <p><strong>Отговори:</strong></p> <ul> <li><code>200 OK</code>: Връща съобщение, че офертата е успешно добавена.</li> </ul> <h2>Добавяне на тип оферта</h2> <p><strong>Крайна точка:</strong> <code>POST api/Offers/addOfferType</code></p> <p><strong>Описание:</strong> Добавя нов тип оферта в базата данни.</p> <p><strong>Тяло на заявката:</strong></p> <ul> <li>Обект <code>OfferType</code>: Съдържа данните за типа оферта.</li> </ul> <p><strong>Отговори:</strong></p> <ul> <li><code>200 OK</code>: Връща съобщение, че типът оферта е успешно добавен.</li> </ul> <h2>Редактиране на оферта</h2> <p><strong>Крайна точка:</strong> <code>POST api/Offers/edit</code></p> <p><strong>Описание:</strong> Редактира съществуваща оферта.</p> <p><strong>Тяло на заявката:</strong></p> <ul> <li>Обект <code>OfferViewModel</code>: Съдържа актуализираните данни на офертата.</li> </ul> <p><strong>Отговори:</strong></p> <ul> <li><code>200 OK</code>: Връща съобщение, че офертата е успешно редактирана.</li> <li><code>400 BadRequest</code>: Предоставените данни за офертата са невалидни.</li> </ul> <h2>Изтриване на оферта</h2> <p><strong>Крайна точка:</strong> <code>DELETE api/Offers/delete</code></p> <p><strong>Описание:</strong>
  
<h1>Документация на OrdersController</h1> <p>Тази документация предоставя преглед на <code>OrdersController</code> в MarketAPI. Този контролер обработва операции, свързани с поръчките, включително извличане на поръчки, добавяне на поръчки, приемане, отказване и доставка на поръчки.</p> <h2>Основен маршрут</h2> <p><strong>Маршрут:</strong> <code>api/Orders</code></p> <h2>Извличане на всички поръчки</h2> <p><strong>Крайна точка:</strong> <code>GET api/Orders/getall</code></p> <p><strong>Описание:</strong> Извлича всички поръчки от базата данни. Използва се само за тестове.</p> <p><strong>Отговори:</strong></p> <ul> <li><code>200 OK</code>: Връща списък с всички поръчки.</li> </ul> <h2>Добавяне на поръчка</h2> <p><strong>Крайна точка:</strong> <code>POST api/Orders/add</code></p> <p><strong>Описание:</strong> Добавя нова поръчка в базата данни.</p> <p><strong>Тяло на заявката:</strong></p> <ul> <li>Обект <code>OrderViewModel</code>: Съдържа данните за поръчката. <ul> <li><code>Address</code> (string): Адрес на поръчката.</li> <li><code>SellerId</code> (int): ID на продавача.</li> <li><code>Title</code> (string): Заглавие на поръчката.</li> <li><code>BuyerId</code> (int): ID на купувача.</li> <li><code>Price</code> (decimal): Цена на поръчката.</li> <li><code>OfferId</code> (int): ID на офертата.</li> <li><code>OfferTypeId</code> (int): ID на типа оферта.</li> </ul> </li> </ul> <p><strong>Отговори:</strong></p> <ul> <li><code>200 OK</code>: Връща съобщение, че поръчката е успешно добавена.</li> <li><code>400 BadRequest</code>: Състоянието на модела е невалидно.</li> </ul> <h2>Приемане на поръчка</h2> <p><strong>Крайна точка:</strong> <code>GET api/Orders/accept</code></p> <p><strong>Описание:</strong> Продавачът приема поръчката и намалява количеството в склада.</p> <p><strong>Параметри:</strong></p> <ul> <li><code>id</code> (int): ID на поръчката.</li> </ul> <p><strong>Отговори:</strong></p> <ul> <li><code>200 OK</code>: Връща съобщение, че поръчката е успешно приета.</li> </ul> <h2>Отказване на поръчка</h2> <p><strong>Крайна точка:</strong> <code>GET api/Orders/decline</code></p> <p><strong>Описание:</strong> Продавачът отказва поръчката и намалява количеството в склада.</p> <p><strong>Параметри:</strong></p> <ul> <li><code>id</code> (int): ID на поръчката.</li> </ul> <p><strong>Отговори:</strong></p> <ul> <li><code>200 OK</code>: Връща съобщение, че поръчката е успешно отказана.</li> </ul> <h2>Доставка на поръчка</h2> <p><strong>Крайна точка:</strong> <code>GET api/Orders/deliver</code></p> <p><strong>Описание:</strong> Маркира поръчката като доставена и изпраща нотификация на потребителя.</p> <p><strong>Параметри:</strong></p> <ul> <li><code>id</code> (int): ID на поръчката.</li> </ul> <p><strong>Отговори:</strong></p> <ul> <li><code>200 OK</code>: Връща съобщение, че поръчката е успешно доставена.</li> </ul>

<h1>Документация на PurchasesController</h1> <p>Тази документация предоставя преглед на <code>PurchasesController</code> в MarketAPI. Този контролер обработва операции, свързани с покупки, включително извличане на покупки, добавяне на покупки, приемане, отказване и доставка на покупки.</p> <h2>Основен маршрут</h2> <p><strong>Маршрут:</strong> <code>api/Purchases</code></p> <h2>Извличане на всички покупки</h2> <p><strong>Крайна точка:</strong> <code>GET api/Purchases/getall</code></p> <p><strong>Описание:</strong> Извлича всички покупки от базата данни. Използва се само за тестове.</p> <p><strong>Отговори:</strong></p> <ul> <li><code>200 OK</code>: Връща списък с всички покупки.</li> </ul> <h2>Добавяне на покупка</h2> <p><strong>Крайна точка:</strong> <code>POST api/Purchases/add</code></p> <p><strong>Описание:</strong> Добавя нова покупка в базата данни.</p> <p><strong>Тяло на заявката:</strong></p> <ul> <li>Обект <code>PurchaseViewModel</code>: Съдържа данните за покупката. <ul> <li><code>Address</code> (string): Адрес на покупката.</li> <li><code>BuyerId</code> (int): ID на купувача.</li> <li><code>Price</code> (decimal): Цена на покупката.</li> <li><code>Orders</code> (List&lt;OrderViewModel&gt;): Списък с поръчки, включени в покупката.</li> </ul> </li> </ul> <p><strong>Отговори:</strong></p> <ul> <li><code>200 OK</code>: Връща съобщение, че покупката е успешно добавена.</li> <li><code>400 BadRequest</code>: Състоянието на модела е невалидно.</li> </ul> <h2>Приемане на покупка</h2> <p><strong>Крайна точка:</strong> <code>GET api/Purchases/accept</code></p> <p><strong>Описание:</strong> Продавачът приема покупката и намалява количеството в склада.</p> <p><strong>Параметри:</strong></p> <ul> <li><code>id</code> (int): ID на покупката.</li> </ul> <p><strong>Отговори:</strong></p> <ul> <li><code>200 OK</code>: Връща съобщение, че покупката е успешно приета.</li> </ul> <h2>Отказване на покупка</h2> <p><strong>Крайна точка:</strong> <code>GET api/Purchases/decline</code></p> <p><strong>Описание:</strong> Продавачът отказва покупката и изтрива записа от базата данни.</p> <p><strong>Параметри:</strong></p> <ul> <li><code>id</code> (int): ID на покупката.</li> </ul> <p><strong>Отговори:</strong></p> <ul> <li><code>200 OK</code>: Връща съобщение, че покупката е успешно отказана.</li> </ul> <h2>Доставка на покупка</h2> <p><strong>Крайна точка:</strong> <code>GET api/Purchases/deliver</code></p> <p><strong>Описание:</strong> Маркира покупката като доставена.</p> <p><strong>Параметри:</strong></p> <ul> <li><code>id</code> (int): ID на покупката.</li> </ul> <p><strong>Отговори:</strong></p> <ul> <li><code>200 OK</code>: Връща съобщение, че покупката е успешно доставена.</li> </ul>

<h1>Документация на ReviewsController</h1> <p>Тази документация предоставя преглед на <code>ReviewsController</code> в MarketAPI. Този контролер обработва операции, свързани с отзиви, включително добавяне и изтриване на отзиви.</p> <h2>Основен маршрут</h2> <p><strong>Маршрут:</strong> <code>api/Reviews</code></p> <h2>Добавяне на отзив</h2> <p><strong>Крайна точка:</strong> <code>POST api/Reviews/add</code></p> <p><strong>Описание:</strong> Добавя нов отзив в базата данни.</p> <p><strong>Тяло на заявката:</strong></p> <ul> <li>Обект <code>ReviewViewModel</code>: Съдържа данните за отзива. <ul> <li><code>OfferId</code> (int): ID на офертата.</li> <li><code>FirstName</code> (string): Първото име на потребителя.</li> <li><code>LastName</code> (string): Фамилното име на потребителя.</li> <li><code>Description</code> (string): Описание на отзива.</li> <li><code>Rating</code> (double): Оценка на отзива.</li> </ul> </li> </ul> <p><strong>Отговори:</strong></p> <ul> <li><code>200 OK</code>: Връща съобщение, че отзивът е успешно добавен.</li> <li><code>400 BadRequest</code>: Възникнала е грешка при добавянето на отзива.</li> </ul> <h2>Изтриване на отзив</h2> <p><strong>Крайна точка:</strong> <code>DELETE api/Reviews/delete</code></p> <p><strong>Описание:</strong> Изтрива отзив от базата данни.</p> <p><strong>Параметри:</strong></p> <ul> <li><code>id</code> (int): ID на отзива.</li> </ul> <p><strong>Отговори:</strong></p> <ul> <li><code>200 OK</code>: Връща съобщение, че отзивът е успешно изтрит.</li> <li><code>400 BadRequest</code>: Възникнала е грешка при изтриването на отзива.</li> </ul>

<h1>Документация на StocksController</h1> <p>Тази документация предоставя преглед на <code>StocksController</code> в MarketAPI. Този контролер обработва операции, свързани със стоките, включително добавяне, извличане, увеличаване, намаляване и изтриване на стоки.</p> <h2>Основен маршрут</h2> <p><strong>Маршрут:</strong> <code>api/Stocks</code></p> <h2>Добавяне на стока</h2> <p><strong>Крайна точка:</strong> <code>POST api/Stocks/add</code></p> <p><strong>Описание:</strong> Добавя нова стока в базата данни.</p> <p><strong>Тяло на заявката:</strong></p> <ul> <li>Обект <code>StockViewModel</code>: Съдържа данните за стоката. <ul> <li><code>Title</code> (string): Заглавие на стоката.</li> <li><code>Quantity</code> (double): Количество на стоката.</li> <li><code>OfferTypeId</code> (int): ID на типа оферта.</li> <li><code>SellerId</code> (Guid): ID на продавача.</li> </ul> </li> </ul> <p><strong>Отговори:</strong></p> <ul> <li><code>200 OK</code>: Връща съобщение, че стоката е успешно добавена.</li> </ul> <h2>Извличане на стоки</h2> <p><strong>Крайна точка:</strong> <code>GET api/Stocks/get</code></p> <p><strong>Описание:</strong> Извлича всички стоки на потребител (продавач).</p> <p><strong>Параметри:</strong></p> <ul> <li><code>sellerId</code> (Guid): ID на продавача.</li> </ul> <p><strong>Отговори:</strong></p> <ul> <li><code>200 OK</code>: Връща списък със стоките на продавача.</li> </ul> <h2>Увеличаване на количество на стока</h2> <p><strong>Крайна точка:</strong> <code>GET api/Stocks/up</code></p> <p><strong>Описание:</strong> Увеличава количеството на дадена стока.</p> <p><strong>Параметри:</strong></p> <ul> <li><code>id</code> (int): ID на стоката.</li> <li><code>quantity</code> (double): Количеството, с което да се увеличи стоката.</li> </ul> <p><strong>Отговори:</strong></p> <ul> <li><code>200 OK</code>: Връща съобщение, че количеството на стоката е успешно увеличено.</li> </ul> <h2>Намаляване на количество на стока</h2> <p><strong>Крайна точка:</strong> <code>GET api/Stocks/down</code></p> <p><strong>Описание:</strong> Намалява количеството на дадена стока.</p> <p><strong>Параметри:</strong></p> <ul> <li><code>id</code> (int): ID на стоката.</li> <li><code>quantity</code> (double): Количеството, с което да се намали стоката.</li> </ul> <p><strong>Отговори:</strong></p> <ul> <li><code>200 OK</code>: Връща съобщение, че количеството на стоката е успешно намалено.</li> </ul> <h2>Изтриване на стока</h2> <p><strong>Крайна точка:</strong> <code>DELETE api/Stocks/delete</code></p> <p><strong>Описание:</strong> Изтрива стока от базата данни.</p> <p><strong>Параметри:</strong></p> <ul> <li><code>stockId</code> (int): ID на стоката.</li> </ul> <p><strong>Отговори:</strong></p> <ul> <li><code>200 OK</code>: Връща съобщение, че стоката е успешно изтрита.</li> </ul>

 
 

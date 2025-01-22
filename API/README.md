<?xml version="1.0"?>

<doc>

<assembly>

<name>MarketAPI</name>

</assembly>

<members>

<member name="T:MarketAPI.Controllers.AuthController">

<summary>

Provides endpoints for authentication-related actions such as login, registration, and token refresh.

</summary>

</member>

<member name="M:MarketAPI.Controllers.AuthController.#ctor(MarketAPI.Data.ApiContext,MarketAPI.Services.Users.IUsersService,MarketAPI.Services.Token.TokenService)">

<summary>

Initializes a new instance of the <see cref="T:MarketAPI.Controllers.AuthController"/> class.

</summary>

<param name="context">The application database context.</param>

<param name="userService">Service for managing user operations.</param>

<param name="tokenService">Service for handling token generation and management.</param>

</member>

<member name="M:MarketAPI.Controllers.AuthController.Login(MarketAPI.Models.AuthModel)">

<summary>

Authenticates a user and provides access tokens upon successful login.

</summary>

<param name="model">The user authentication details.</param>

<returns>

A response containing the authenticated user's details and tokens, or an error message if authentication fails.

</returns>

</member>

<member name="M:MarketAPI.Controllers.AuthController.Create(MarketAPI.Models.AddUserViewModel)">

<summary>

Registers a new user in the system.

</summary>

<param name="user">The details of the user to be created.</param>

<returns>

A success message if registration is successful, or an error message if validation fails.

</returns>

</member>

<member name="M:MarketAPI.Controllers.AuthController.Refresh(System.String)">

<summary>

Refreshes the access token using a valid refresh token.

</summary>

<param name="refreshToken">The refresh token to validate and use for generating a new access token.</param>

<returns>

A response containing the updated access token and its expiry, or an error message if the refresh token is invalid or expired.

</returns>

</member>

<member name="T:MarketAPI.Controllers.BillingController">

<summary>

Provides endpoints for managing billing details, including retrieval, creation, editing, and deletion.

</summary>

</member>

<member name="M:MarketAPI.Controllers.BillingController.#ctor(MarketAPI.Services.Billing.IBillingService)">

<summary>

Initializes a new instance of the <see cref="T:MarketAPI.Controllers.BillingController"/> class.

</summary>

<param name="billingService">Service for managing billing operations.</param>

</member>

<member name="M:MarketAPI.Controllers.BillingController.Get(System.Int32)">

<summary>

Retrieves the billing details for the specified ID.

</summary>

<param name="id">The ID of the billing details to retrieve.</param>

<returns>The billing details if found, or a NotFound response if the ID does not exist.</returns>

</member>

<member name="M:MarketAPI.Controllers.BillingController.Create(MarketAPI.Data.Models.BillingDetails)">

<summary>

Creates a new billing entry.

</summary>

<param name="model">The billing details to create.</param>

<returns>The ID of the newly created billing entry.</returns>

</member>

<member name="M:MarketAPI.Controllers.BillingController.Delete(System.Int32)">

<summary>

Deletes the billing details for the specified ID.

</summary>

<param name="id">The ID of the billing details to delete.</param>

<returns>A success message if deletion is successful, or a NotFound response if the ID does not exist.</returns>

</member>

<member name="M:MarketAPI.Controllers.BillingController.Edit(System.Int32,MarketAPI.Data.Models.BillingDetails)">

<summary>

Updates the billing details for the specified ID.

</summary>

<param name="id">The ID of the billing details to update.</param>

<param name="model">The updated billing details.</param>

<returns>A success message if the update is successful, or a NotFound response if the ID does not exist.</returns>

</member>

<member name="T:MarketAPI.Controllers.FirebaseController">

<summary>

Provides endpoints for managing Firebase tokens for users.

</summary>

</member>

<member name="M:MarketAPI.Controllers.FirebaseController.#ctor(MarketAPI.Data.ApiContext)">

<summary>

Initializes a new instance of the <see cref="T:MarketAPI.Controllers.FirebaseController"/> class.

</summary>

<param name="context">The database context.</param>

</member>

<member name="M:MarketAPI.Controllers.FirebaseController.SetFirebaseToken(System.Guid,System.String)">

<summary>

Sets or updates the Firebase token for a specific user.

</summary>

<param name="id">The unique identifier of the user.</param>

<param name="token">The Firebase token to associate with the user.</param>

<returns>

A response indicating whether the operation was successful:

- <c>200 OK</c>: If the token was successfully updated.
- <c>400 Bad Request</c>: If the token is null or empty.
- <c>404 Not Found</c>: If the user does not exist.

</returns>

</member>

<member name="T:MarketAPI.Controllers.InventoryController">

<summary>

Provides endpoints for managing inventory, including creating, updating, and deleting stock.

</summary>

</member>

<member name="M:MarketAPI.Controllers.InventoryController.#ctor(MarketAPI.Services.Inventory.IInventoryService)">

<summary>

Initializes a new instance of the <see cref="T:MarketAPI.Controllers.InventoryController"/> class.

</summary>

<param name="inventoryService">Service for managing inventory operations.</param>

</member>

<member name="M:MarketAPI.Controllers.InventoryController.Create(MarketAPI.Models.StockViewModel)">

<summary>

Creates new stock in the inventory.

</summary>

<param name="model">The stock details to create.</param>

<returns>

A response indicating whether the operation was successful.

</returns>

</member>

<member name="M:MarketAPI.Controllers.InventoryController.GetUserStocks(System.Guid)">

<summary>

Retrieves all stocks for a specific seller.

</summary>

<param name="id">The unique identifier of the seller.</param>

<returns>

A list of stock items associated with the seller.

</returns>

</member>

<member name="M:MarketAPI.Controllers.InventoryController.IncreaseQuantity(System.Int32,System.Double)">

<summary>

Increases the quantity of stock for a specific item.

</summary>

<param name="id">The unique identifier of the stock item.</param>

<param name="quantity">The amount to increase the stock by.</param>

<returns>

A response indicating whether the operation was successful.

</returns>

</member>

<member name="M:MarketAPI.Controllers.InventoryController.DecreaseQuantity(System.Int32,System.Double)">

<summary>

Decreases the quantity of stock for a specific item.

</summary>

<param name="id">The unique identifier of the stock item.</param>

<param name="quantity">The amount to decrease the stock by.</param>

<returns>

A response indicating whether the operation was successful.

</returns>

</member>

<member name="M:MarketAPI.Controllers.InventoryController.Delete(System.Int32)">

<summary>

Deletes a specific stock item from the inventory.

</summary>

<param name="id">The unique identifier of the stock item to delete.</param>

<returns>

A response indicating whether the operation was successful.

</returns>

</member>

<member name="T:MarketAPI.Controllers.OffersController">

<summary>

Provides endpoints for managing offers, including creation, retrieval, and deletion of offers.

</summary>

</member>

<member name="M:MarketAPI.Controllers.OffersController.#ctor(MarketAPI.Services.Offers.IOffersService,MarketAPI.Services.Users.IUsersService,MarketAPI.Services.Inventory.IInventoryService)">

<summary>

Initializes a new instance of the <see cref="T:MarketAPI.Controllers.OffersController"/> class.

</summary>

<param name="service">The service for managing offers.</param>

<param name="usersService">The service for managing users.</param>

<param name="inventoryService">The service for managing inventory.</param>

</member>

<member name="M:MarketAPI.Controllers.OffersController.Get">

<summary>

Retrieves all offers.

</summary>

<returns>

A list of all available offers.

</returns>

</member>

<member name="M:MarketAPI.Controllers.OffersController.Single(System.Int32)">

<summary>

Retrieves a specific offer by its unique identifier.

</summary>

<param name="id">The unique identifier of the offer.</param>

<returns>

A single offer matching the provided identifier.

</returns>

</member>

<member name="M:MarketAPI.Controllers.OffersController.Search(System.String,System.String)">

<summary>

Searches for offers based on the input search string and preferred town.

</summary>

<param name="input">The search query input.</param>

<param name="preferredTown">The town the user prefers for offers.</param>

<returns>

A list of offers matching the search query and town.

</returns>

</member>

<member name="M:MarketAPI.Controllers.OffersController.SearchByCategory(System.String,System.String)">

<summary>

Searches for offers based on a specific category and preferred town.

</summary>

<param name="category">The category of the offers to search for.</param>

<param name="preferredTown">The preferred town for the offers.</param>

<returns>

A list of offers that match the specified category and town.

</returns>

</member>

<member name="M:MarketAPI.Controllers.OffersController.Create(MarketAPI.Models.OfferViewModel)">

<summary>

Creates a new offer.

</summary>

<param name="model">The offer details.</param>

<returns>

The ID of the newly created offer.

</returns>

</member>

<member name="M:MarketAPI.Controllers.OffersController.CreateOfferType(MarketAPI.Data.Models.OfferType)">

<summary>

Creates a new offer type.

</summary>

<param name="offerType">The details of the offer type to create.</param>

<returns>

A success message indicating the offer type was added.

</returns>

</member>

<member name="M:MarketAPI.Controllers.OffersController.GetOfferTypes">

<summary>

Retrieves all offer types.

</summary>

<returns>

A list of all offer types.

</returns>

</member>

<member name="M:MarketAPI.Controllers.OffersController.Edit(System.Int32,MarketAPI.Models.OfferViewModel)">

<summary>

Edits an existing offer.

</summary>

<param name="id">The unique identifier of the offer to edit.</param>

<param name="offer">The updated offer details.</param>

<returns>

A success message indicating the offer was edited.

</returns>

</member>

<member name="M:MarketAPI.Controllers.OffersController.DeleteOffer(System.Int32)">

<summary>

Deletes a specific offer by its unique identifier.

</summary>

<param name="id">The unique identifier of the offer to delete.</param>

<returns>

A success message indicating the offer was deleted.

</returns>

</member>

<member name="T:MarketAPI.Controllers.OrdersController">

<summary>

Provides endpoints for managing orders, including creating, approving, declining, and delivering orders.

</summary>

</member>

<member name="M:MarketAPI.Controllers.OrdersController.#ctor(MarketAPI.Services.Orders.IOrdersService,MarketAPI.Services.Firebase.FirebaseService,MarketAPI.Services.Token.TokenService)">

<summary>

Initializes a new instance of the <see cref="T:MarketAPI.Controllers.OrdersController"/> class.

</summary>

<param name="ordersService">The service for managing orders.</param>

<param name="firebaseService">The service for interacting with Firebase notifications.</param>

<param name="tokenService">The service for managing tokens.</param>

</member>

<member name="M:MarketAPI.Controllers.OrdersController.Get">

<summary>

Retrieves all orders.

</summary>

<returns>

A list of all available orders.

</returns>

</member>

<member name="M:MarketAPI.Controllers.OrdersController.GetOrder(System.Int32)">

<summary>

Retrieves a specific order by its unique identifier.

</summary>

<param name="id">The unique identifier of the order.</param>

<returns>

A single order matching the provided identifier.

</returns>

</member>

<member name="M:MarketAPI.Controllers.OrdersController.Create(MarketAPI.Models.RequiredOrderViewModel)">

<summary>

Creates a new order.

</summary>

<param name="model">The order details.</param>

<returns>

A success message indicating the order was added successfully.

</returns>

</member>

<member name="M:MarketAPI.Controllers.OrdersController.Approve(System.Int32)">

<summary>

Approves an order, which decreases the stock and notifies the user.

</summary>

<param name="id">The unique identifier of the order to approve.</param>

<returns>

A success message indicating the order was approved.

</returns>

</member>

<member name="M:MarketAPI.Controllers.OrdersController.Decline(System.Int32)">

<summary>

Declines an order and notifies the user.

</summary>

<param name="id">The unique identifier of the order to decline.</param>

<returns>

A success message indicating the order was declined.

</returns>

</member>

<member name="M:MarketAPI.Controllers.OrdersController.Deliver(System.Int32)">

<summary>

Marks an order as delivered and notifies the user.

</summary>

<param name="id">The unique identifier of the order to mark as delivered.</param>

<returns>

A success message indicating the order was delivered.

</returns>

</member>

<member name="T:MarketAPI.Controllers.PurchasesController">

<summary>

Provides endpoints for managing purchases, including creating new purchases and retrieving existing ones.

</summary>

</member>

<member name="M:MarketAPI.Controllers.PurchasesController.#ctor(MarketAPI.Services.Purchases.IPurchaseService)">

<summary>

Initializes a new instance of the <see cref="T:MarketAPI.Controllers.PurchasesController"/> class.

</summary>

<param name="purchaseService">The service for managing purchases.</param>

</member>

<member name="M:MarketAPI.Controllers.PurchasesController.Get">

<summary>

Retrieves all purchases.

</summary>

<returns>

A list of all available purchases.

</returns>

</member>

<member name="M:MarketAPI.Controllers.PurchasesController.Create(MarketAPI.Models.PurchaseViewModel)">

<summary>

Creates a new purchase.

</summary>

<param name="model">The purchase details.</param>

<returns>

A success message indicating the purchase was added successfully.

</returns>

</member>

<member name="T:MarketAPI.Controllers.ReviewsController">

<summary>

Provides endpoints for managing reviews, including creating, deleting, and retrieving reviews for offers and sellers.

</summary>

</member>

<member name="M:MarketAPI.Controllers.ReviewsController.#ctor(MarketAPI.Data.ApiContext,MarketAPI.Services.Reviews.IReviewService)">

<summary>

Initializes a new instance of the <see cref="T:MarketAPI.Controllers.ReviewsController"/> class.

</summary>

<param name="context">The database context.</param>

<param name="service">The review service for handling review-related operations.</param>

</member>

<member name="M:MarketAPI.Controllers.ReviewsController.Get(System.Int32)">

<summary>

Retrieves reviews for a specific offer.

</summary>

<param name="id">The ID of the offer.</param>

<returns>

A list of reviews for the specified offer.

</returns>

</member>

<member name="M:MarketAPI.Controllers.ReviewsController.Get(System.Guid)">

<summary>

Retrieves reviews for a specific seller.

</summary>

<param name="id">The ID of the seller.</param>

<returns>

A list of reviews for the specified seller.

</returns>

</member>

<member name="M:MarketAPI.Controllers.ReviewsController.Create(MarketAPI.Models.ReviewViewModel)">

<summary>

Creates a new review.

</summary>

<param name="model">The review details.</param>

<returns>

A success message indicating the review was added successfully.

</returns>

</member>

<member name="M:MarketAPI.Controllers.ReviewsController.Delete(System.Int32)">

<summary>

Deletes a specific review.

</summary>

<param name="id">The ID of the review to delete.</param>

<returns>

A success message indicating the review was deleted successfully.

</returns>

</member>

<member name="T:MarketAPI.Controllers.StatsController">

<summary>

Provides endpoints for fetching statistics related to orders for a seller.

</summary>

</member>

<member name="M:MarketAPI.Controllers.StatsController.#ctor(MarketAPI.Services.Orders.IOrdersService)">

<summary>

Initializes a new instance of the <see cref="T:MarketAPI.Controllers.StatsController"/> class.

</summary>

<param name="ordersService">The service used for managing orders and retrieving order data.</param>

</member>

<member name="M:MarketAPI.Controllers.StatsController.Orders(System.Guid)">

<summary>

Retrieves the orders for a specific seller.

</summary>

<param name="id">The ID of the seller.</param>

<returns>

A list of orders placed by the seller, or a not found message if the seller does not exist.

</returns>

</member>

<member name="T:MarketAPI.Controllers.UsersController">

<summary>

Provides endpoints for managing user information and retrieving user data.

</summary>

</member>

<member name="M:MarketAPI.Controllers.UsersController.#ctor(MarketAPI.Services.Users.IUsersService,MarketAPI.Services.Offers.IOffersService)">

<summary>

Initializes a new instance of the <see cref="T:MarketAPI.Controllers.UsersController"/> class.

</summary>

<param name="usersService">The service used for managing users.</param>

<param name="offerService">The service used for managing offers.</param>

</member>

<member name="M:MarketAPI.Controllers.UsersController.All(System.Collections.Generic.List{System.String})">

<summary>

Retrieves a list of users based on the provided list of user IDs.

</summary>

<param name="userIds">A list of user IDs to fetch users.</param>

<returns>A list of user DTOs.</returns>

</member>

<member name="M:MarketAPI.Controllers.UsersController.Get(System.Guid)">

<summary>

Retrieves the details of a specific user.

</summary>

<param name="id">The ID of the user to retrieve.</param>

<returns>The user details or a NotFound response if the user does not exist.</returns>

</member>

<member name="M:MarketAPI.Controllers.UsersController.GetSeller(System.Guid)">

<summary>

Retrieves the details of a specific seller.

</summary>

<param name="id">The ID of the seller to retrieve.</param>

<returns>The seller details or a NotFound response if the seller does not exist.</returns>

</member>

<member name="M:MarketAPI.Controllers.UsersController.Edit(System.Guid,MarketAPI.Models.AddUserViewModel)">

<summary>

Edits the details of a specific user.

</summary>

<param name="id">The ID of the user to edit.</param>

<param name="model">The model containing the new user details.</param>

<returns>A message indicating the result of the edit operation.</returns>

</member>

<member name="M:MarketAPI.Controllers.UsersController.Delete(System.Guid)">

<summary>

Deletes a specific user based on the user ID.

</summary>

<param name="id">The ID of the user to delete.</param>

<returns>A message indicating the result of the delete operation.</returns>

</member>

<member name="M:MarketAPI.Controllers.UsersController.History(System.Guid)">

<summary>

Retrieves the purchase history of a specific user.

</summary>

<param name="id">The ID of the user whose purchase history is to be fetched.</param>

<returns>A list of the user's past purchases or a NotFound response if no purchases are found.</returns>

</member>

<member name="M:MarketAPI.Controllers.UsersController.GetIncomingOrders(System.Guid)">

<summary>

Retrieves incoming orders for a specific seller.

</summary>

<param name="id">The ID of the seller whose incoming orders are to be fetched.</param>

<returns>A list of the seller's incoming orders or a NotFound response if no orders are found.</returns>

</member>

<member name="M:MarketAPI.Controllers.UsersController.GetUserOffers(System.Guid)">

<summary>

Retrieves the offers made by a specific seller.

</summary>

<param name="id">The ID of the seller whose offers are to be fetched.</param>

<returns>A list of the seller's offers or a NotFound response if no offers are found.</returns>

</member>

</members>

</doc>

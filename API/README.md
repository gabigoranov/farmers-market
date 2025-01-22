# MarketAPI Documentation

Welcome to the MarketAPI documentation! This API is built using .NET Core and provides various endpoints for managing users, authentication, billing, inventory, offers, orders, purchases, reviews, and statistics. Below is a detailed overview of the controllers and their functionalities.

## Table of Contents

- [Authentication](#authentication)
- [Billing](#billing)
- [Firebase Management](#firebase-management)
- [Inventory Management](#inventory-management)
- [Offers Management](#offers-management)
- [Orders Management](#orders-management)
- [Purchases Management](#purchases-management)
- [Reviews Management](#reviews-management)
- [Statistics](#statistics)
- [User  Management](#user-management)

## Authentication

### AuthController

Provides endpoints for authentication-related actions such as login, registration, and token refresh.

- **Constructor**: `AuthController(ApiContext context, IUsersService userService, TokenService tokenService)`
  - Initializes a new instance of the `AuthController` class.
  - **Parameters**:
    - `context`: The application database context.
    - `userService`: Service for managing user operations.
    - `tokenService`: Service for handling token generation and management.

- **Login**: `Login(AuthModel model)`
  - Authenticates a user and provides access tokens upon successful login.
  - **Parameters**: 
    - `model`: The user authentication details.
  - **Returns**: A response containing the authenticated user's details and tokens, or an error message if authentication fails.

- **Create**: `Create(AddUser ViewModel user)`
  - Registers a new user in the system.
  - **Parameters**: 
    - `user`: The details of the user to be created.
  - **Returns**: A success message if registration is successful, or an error message if validation fails.

- **Refresh**: `Refresh(string refreshToken)`
  - Refreshes the access token using a valid refresh token.
  - **Parameters**: 
    - `refreshToken`: The refresh token to validate and use for generating a new access token.
  - **Returns**: A response containing the updated access token and its expiry, or an error message if the refresh token is invalid or expired.

## Billing

### BillingController

Provides endpoints for managing billing details, including retrieval, creation, editing, and deletion.

- **Constructor**: `BillingController(IBillingService billingService)`
  - Initializes a new instance of the `BillingController` class.
  - **Parameters**:
    - `billingService`: Service for managing billing operations.

- **Get**: `Get(int id)`
  - Retrieves the billing details for the specified ID.
  - **Parameters**: 
    - `id`: The ID of the billing details to retrieve.
  - **Returns**: The billing details if found, or a NotFound response if the ID does not exist.

- **Create**: `Create(BillingDetails model)`
  - Creates a new billing entry.
  - **Parameters**: 
    - `model`: The billing details to create.
  - **Returns**: The ID of the newly created billing entry.

- **Delete**: `Delete(int id)`
  - Deletes the billing details for the specified ID.
  - **Parameters**: 
    - `id`: The ID of the billing details to delete.
  - **Returns**: A success message if deletion is successful, or a NotFound response if the ID does not exist.

- **Edit**: `Edit(int id, BillingDetails model)`
  - Updates the billing details for the specified ID.
  - **Parameters**: 
    - `id`: The ID of the billing details to update.
    - `model`: The updated billing details.
  - **Returns**: A success message if the update is successful, or a NotFound response if the ID does not exist.

## Firebase Management

### FirebaseController

Provides endpoints for managing Firebase tokens for users.

- **Constructor**: `FirebaseController(ApiContext context)`
  - Initializes a new instance of the `FirebaseController` class.
  - **Parameters**:
    - `context`: The database context.

- **SetFirebaseToken**: `SetFirebaseToken(Guid id, string token)`
  - Sets or updates the Firebase token for a specific user.
  - **Parameters**: 
    - `id`: The unique identifier of the user.
    - `token`: The Firebase token to associate with the user.
  - **Returns**: A response indicating whether the operation was successful:
    - `200 OK`: If the token was successfully updated.
    - `400 Bad Request`: If the token is null or empty.
    - `404 Not Found`: If the user does not exist.

## Inventory Management

### InventoryController

Provides endpoints for managing inventory, including creating, updating, and deleting stock.

- **Constructor**: `InventoryController(IInventoryService inventoryService)`
  - Initializes a new instance of the `InventoryController` class.
  - **Parameters**:
    - `inventoryService`: Service for managing inventory operations.

- **Create**: `Create(StockViewModel model)`
  - Creates new stock in the inventory.
  - **Parameters**: 
    - `model`: The stock details to create.
  - **Returns**: A response indicating whether the operation was successful.

- **GetUser Stocks**: `GetUser Stocks(Guid id)`
  - Retrieves all stocks for a specific seller.
  - **Parameters**: 
    - `id`: The unique identifier of the seller.
  - **Returns**: A list of stock items associated with the seller.

- **IncreaseQuantity**: `IncreaseQuantity(int id, double quantity)`
  - Increases the quantity of stock for a specific item.
  - **Parameters**: 
    - `id`: The unique identifier of the stock item.
    - `quantity`: The amount to increase the stock by.
  - **Returns**: A response indicating whether the operation was successful.

- **DecreaseQuantity**: `DecreaseQuantity(int id, double quantity)`
  - Decreases the quantity of stock for a specific item.
  - **Parameters**: 
    - `id`: The unique identifier of the stock item.
    - `quantity`: The amount to decrease the stock by.
  - **Returns**: A response indicating whether the operation was successful.

- **Delete**: `Delete(int id)`
  - Deletes a specific stock item from the inventory.
  - **Parameters**: 
    - `id`: The unique identifier of the stock item to delete.
  - **Returns**: A response indicating whether the operation was successful.

## Offers Management

### OffersController

Provides endpoints for managing offers, including creation, retrieval, and deletion of offers.

- **Constructor**: `OffersController(IOffersService service, IUsersService usersService, IInventoryService inventoryService)`
  - Initializes a new instance of the `OffersController` class.
  - **Parameters**:
    - `service`: The service for managing offers.
    - `usersService`: The service for managing users.
    - `inventoryService`: The service for managing inventory.

- **Get**: `Get()`
  - Retrieves all offers.
  - **Returns**: A list of all available offers.

- **Single**: `Single(int id)`
  - Retrieves a specific offer by its unique identifier.
  - **Parameters**: 
    - `id`: The unique identifier of the offer.
  - **Returns**: A single offer matching the provided identifier.

- **Search**: `Search(string input, string preferredTown)`
  - Searches for offers based on the input search string and preferred town.
  - **Parameters**: 
    - `input`: The search query input.
    - `preferredTown`: The town the user prefers for offers.
  - **Returns**: A list of offers matching the search query and town.

- **SearchByCategory**: `SearchByCategory(string category, string preferredTown)`
  - Searches for offers based on a specific category and preferred town.
  - **Parameters**: 
    - `category`: The category of the offers to search for.
    - `preferredTown`: The preferred town for the offers.
  - **Returns**: A list of offers that match the specified category and town.

- **Create**: `Create(OfferViewModel model)`
  - Creates a new offer.
  - **Parameters**: 
    - `model`: The offer details.
  - **Returns**: The ID of the newly created offer.

- **CreateOfferType**: `CreateOfferType(OfferType offerType)`
  - Creates a new offer type.
  - **Parameters**: 
    - `offerType`: The details of the offer type to create.
  - **Returns**: A success message indicating the offer type was added.

- **GetOfferTypes**: `GetOfferTypes()`
  - Retrieves all offer types.
  - **Returns**: A list of all offer types.

- **Edit**: `Edit(int id, OfferViewModel offer)`
  - Edits an existing offer.
  - **Parameters**: 
    - `id`: The unique identifier of the offer to edit.
    - `offer`: The updated offer details.
  - **Returns**: A success message indicating the offer was edited.

- **DeleteOffer**: `DeleteOffer(int id)`
  - Deletes a specific offer by its unique identifier.
  - **Parameters**: 
    - `id`: The unique identifier of the offer to delete.
  - **Returns**: A success message indicating the offer was deleted.

## Orders Management

### OrdersController

Provides endpoints for managing orders, including creating, approving, declining, and delivering orders.

- **Constructor**: `OrdersController(IOrdersService ordersService, FirebaseService firebaseService, TokenService tokenService)`
  - Initializes a new instance of the `OrdersController` class.
  - **Parameters**:
    - `ordersService`: The service for managing orders.
    - `firebaseService`: The service for interacting with Firebase notifications.
    - `tokenService`: The service for managing tokens.

- **Get**: `Get()`
  - Retrieves all orders.
  - **Returns**: A list of all available orders.

- **GetOrder**: `GetOrder(int id)`
  - Retrieves a specific order by its unique identifier.
  - **Parameters**: 
    - `id`: The unique identifier of the order.
  - **Returns**: A single order matching the provided identifier.

- **Create**: `Create(RequiredOrderViewModel model)`
  - Creates a new order.
  - **Parameters**: 
    - `model`: The order details.
  - **Returns**: A success message indicating the order was added successfully.

- **Approve**: `Approve(int id)`
  - Approves an order, which decreases the stock and notifies the user.
  - **Parameters**: 
    - `id`: The unique identifier of the order to approve.
  - **Returns**: A success message indicating the order was approved.

- **Decline**: `Decline(int id)`
  - Declines an order and notifies the user.
  - **Parameters**: 
    - `id`: The unique identifier of the order to decline.
  - **Returns**: A success message indicating the order was declined.

- **Deliver**: `Deliver(int id)`
  - Marks an order as delivered and notifies the user.
  - **Parameters**: 
    - `id`: The unique identifier of the order to mark as delivered.
  - **Returns**: A success message indicating the order was delivered.

## Purchases Management

### PurchasesController

Provides endpoints for managing purchases, including creating new purchases and retrieving existing ones.

- **Constructor**: `PurchasesController(IPurchaseService purchaseService)`
  - Initializes a new instance of the `PurchasesController` class.
  - **Parameters**:
    - `purchaseService`: The service for managing purchases.

- **Get**: `Get()`
  - Retrieves all purchases.
  - **Returns**: A list of all available purchases.

- **Create**: `Create(PurchaseViewModel model)`
  - Creates a new purchase.
  - **Parameters**: 
    - `model`: The purchase details.
  - **Returns**: A success message indicating the purchase was added successfully.

## Reviews Management

### ReviewsController

Provides endpoints for managing reviews, including creating, deleting, and retrieving reviews for offers and sellers.

- **Constructor**: `ReviewsController(ApiContext context, IReviewService service)`
  - Initializes a new instance of the `ReviewsController` class.
  - **Parameters**:
    - `context`: The database context.
    - `service`: The review service for handling review-related operations.

- **Get (Offer)**: `Get(int id)`
  - Retrieves reviews for a specific offer.
  - **Parameters**: 
    - `id`: The ID of the offer.
  - **Returns**: A list of reviews for the specified offer.

- **Get (Seller)**: `Get(Guid id)`
  - Retrieves reviews for a specific seller.
  - **Parameters**: 
    - `id`: The ID of the seller.
  - **Returns**: A list of reviews for the specified seller.

- **Create**: `Create(ReviewViewModel model)`
  - Creates a new review.
  - **Parameters**: 
    - `model`: The review details.
  - **Returns**: A success message indicating the review was added successfully.

- **Delete**: `Delete(int id)`
  - Deletes a specific review.
  - **Parameters**: 
    - `id`: The ID of the review to delete.
  - **Returns**: A success message indicating the review was deleted successfully.

## Statistics

### StatsController

Provides endpoints for fetching statistics related to orders for a seller.

- **Constructor**: `StatsController(IOrdersService ordersService)`
  - Initializes a new instance of the `StatsController` class.
  - **Parameters**:
    - `ordersService`: The service used for managing orders and retrieving order data.

- **Orders**: `Orders(Guid id)`
  - Retrieves the orders for a specific seller.
  - **Parameters**: 
    - `id`: The ID of the seller.
  - **Returns**: A list of orders placed by the seller, or a not found message if the seller does not exist.

## User Management

### UsersController

Provides endpoints for managing user information and retrieving user data.

- **Constructor**: `UsersController(IUsersService usersService, IOffersService offerService)`
  - Initializes a new instance of the `UsersController` class.
  - **Parameters**:
    - `usersService`: The service used for managing users.
    - `offerService`: The service used for managing offers.

- **All**: `All(List<string> userIds)`
  - Retrieves a list of users based on the provided list of user IDs.
  - **Parameters**: 
    - `userIds`: A list of user IDs to fetch users.
  - **Returns**: A list of user DTOs.

- **Get**: `Get(Guid id)`
  - Retrieves the details of a specific user.
  - **Parameters**: 
    - `id`: The ID of the user to retrieve.
  - **Returns**: The user details or a NotFound response if the user does not exist.

- **GetSeller**: `GetSeller(Guid id)`
  - Retrieves the details of a specific seller.
  - **Parameters**: 
    - `id`: The ID of the seller to retrieve.
  - **Returns**: The seller details or a NotFound response if the seller does not exist.

- **Edit**: `Edit(Guid id, AddUser ViewModel model)`
  - Edits the details of a specific user.
  - **Parameters**: 
    - `id`: The ID of the user to edit.
    - `model`: The model containing the new user details.
  - **Returns**: A message indicating the result of the edit operation.

- **Delete**: `Delete(Guid id)`
  - Deletes a specific user based on the user ID.
  - **Parameters**: 
    - `id`: The ID of the user to delete.
  - **Returns**: A message indicating the result of the delete operation.

- **History**: `History(Guid id)`
  - Retrieves the purchase history of a specific user.
  - **Parameters**: 
    - `id`: The ID of the user whose purchase history is to be fetched.
  - **Returns**: A list of the user's past purchases or a NotFound response if no purchases are found.

- **GetIncomingOrders**: `GetIncomingOrders(Guid id)`
  - Retrieves incoming orders for a specific seller.
  - **Parameters**: 
    - `id`: The ID of the seller whose incoming orders are to be fetched.
  - **Returns**: A list of the seller's incoming orders or a NotFound response if no orders are found.

- **GetUser Offers**: `GetUser Offers(Guid id)`
  - Retrieves the offers made by a specific seller.
  - **Parameters**: 
    - `id`: The ID of the seller whose offers are to be fetched.
  - **Returns**: A list of the seller's offers or a NotFound response if no offers are found.

---

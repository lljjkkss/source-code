
USE CalligraphyStore;
GO


--Stored Prodcedure Account
CREATE PROCEDURE CreateAccount
    @Email VARCHAR(255),
    @Name NVARCHAR(255),
    @PhoneNumber VARCHAR(10),
    @PassWord VARCHAR(255),
    @Role NVARCHAR(8),
    @CreatedBy INT
AS
BEGIN
    INSERT INTO Account (Email, Name, PhoneNumber, PassWord, Role, CreatedDate, CreatedBy)
    VALUES (@Email, @Name, @PhoneNumber, @Password, @Role, GETDATE(), @CreatedBy)
END
GO


CREATE PROCEDURE GetAccount
AS
BEGIN
	SELECT 
		Account.id, Membership.LevelName, Email, Name, PhoneNumber,
		Role, LastOrder, Account.CreatedBy, Account.CreatedDate
	FROM Account 
		LEFT JOIN Membership ON MembershipId = Membership.Id
	WHERE Account.IsDelete = 0;
END
GO

CREATE PROCEDURE GetAccountByEmail
    @Email VARCHAR(255)
AS
BEGIN
    SELECT Email, Account.id, Membership.LevelName, Name, PhoneNumber,
		Role, LastOrder, Account.CreatedBy, Account.CreatedDate
	FROM Account 
		LEFT JOIN Membership ON MembershipId = Membership.Id
	WHERE Email LIKE '%' + @Email + '%' AND Account.IsDelete = 0;
END
GO

CREATE PROCEDURE GetAccountById
    @Id INT
AS
BEGIN
    SELECT Account.id, Membership.LevelName, Email, Name, PhoneNumber,
		Role, LastOrder, Account.CreatedBy, Account.CreatedDate
	FROM Account 
		LEFT JOIN Membership ON MembershipId = Membership.Id
	WHERE Account.Id = @Id AND Account.IsDelete = 0;
END
GO

CREATE PROCEDURE UpdateAccount
    @Id INT,
	@Email VARCHAR(255),
    @Name NVARCHAR(255),
    @PhoneNumber VARCHAR(10),
    @PassWord VARCHAR(255),
    @Role NVARCHAR(8),
    @ModifiedBy INT
AS
BEGIN
    UPDATE Account
    SET 
		Email = @Email,
		Name = @Name,
        PhoneNumber = @PhoneNumber,
        PassWord = @PassWord,
        Role = @Role,
        LastModifiedBy = @ModifiedBy,
        LastModifiedDate = GETDATE()
    WHERE Id = @Id AND IsDelete = 0
END
GO

CREATE PROCEDURE DeleteAccount
    @Id INT,
    @ModifiedBy INT
AS
BEGIN
    UPDATE Account
    SET IsDelete = 1,
        LastModifiedBy = @ModifiedBy,
        LastModifiedDate = GETDATE()
    WHERE Id = @Id
END
GO


-- Stored Procedure CreateMembership
CREATE PROCEDURE CreateMembership
    @LevelName NVARCHAR(50),
    @MinSpend INT,
    @DowngradeAfterMonths INT,
    @Description NVARCHAR(255),
    @CreatedBy INT
AS
BEGIN
    INSERT INTO Membership (
        LevelName, MinSpend, DowngradeAfterMonths, Description, 
        CreatedBy, CreatedDate
    )
    VALUES (
        @LevelName, @MinSpend, @DowngradeAfterMonths, @Description, 
        @CreatedBy, GETDATE()
    )
END
GO

CREATE PROCEDURE GetMembership
AS
BEGIN
    SELECT Id, LevelName, MinSpend, DowngradeAfterMonths,
		Description, CreatedBy, CreatedDate
	FROM Membership

	WHERE IsDelete = 0
END
GO

CREATE PROCEDURE GetMembershipById
    @Id INT
AS
BEGIN
    SELECT Id, LevelName, MinSpend, DowngradeAfterMonths,
		Description, CreatedBy, CreatedDate
	FROM Membership

	WHERE Id = @Id AND IsDelete = 0
END
GO

CREATE PROCEDURE GetMembershipByLevelName
    @LevelName NVARCHAR(255)
AS
BEGIN
    SELECT LevelName, Id, MinSpend, DowngradeAfterMonths,
		Description, CreatedBy, CreatedDate
	FROM Membership

	WHERE LevelName LIKE '%' + @LevelName + '%' AND IsDelete = 0
END
GO

CREATE PROCEDURE UpdateMembership
    @Id INT,
    @LevelName NVARCHAR(50),
    @MinSpend INT,
    @DowngradeAfterMonths INT,
    @Description NVARCHAR(255),
    @ModifiedBy INT
AS
BEGIN
    UPDATE Membership
    SET 
        LevelName = @LevelName,
        MinSpend = @MinSpend,
        DowngradeAfterMonths = @DowngradeAfterMonths,
        Description = @Description,
        LastModifiedBy = @ModifiedBy,
        LastModifiedDate = GETDATE()
    WHERE Id = @Id AND IsDelete = 0
END
GO

CREATE PROCEDURE DeleteMembership
    @Id INT,
    @ModifiedBy INT
AS
BEGIN
    -- Kiểm tra nếu cấp bậc đang được sử dụng trong Account hoặc Promotion
    IF EXISTS (SELECT 1 FROM Account WHERE MembershipId = @Id AND IsDelete = 0)
        OR EXISTS (SELECT 1 FROM Promotion WHERE ApplicableMembership = (SELECT LevelName FROM Membership WHERE Id = @Id) AND IsDelete = 0)
        THROW 50002, N'Không thể xóa cấp bậc vì đang được sử dụng trong Account hoặc Promotion', 1;

    UPDATE Membership
    SET IsDelete = 1,
        LastModifiedBy = @ModifiedBy,
        LastModifiedDate = GETDATE()
    WHERE Id = @Id
END
GO


--Stored Procedure Category
CREATE PROCEDURE CreateCategory
    @Name NVARCHAR(255),
    @CreatedBy INT
AS
BEGIN
    INSERT INTO Category (Name, CreatedBy, CreatedDate)
    VALUES (@Name, @CreatedBy, GETDATE())
END
GO

CREATE PROCEDURE GetCategory
AS
BEGIN
	SELECT Id, Name, CreatedBy, CreatedDate FROM Category Where IsDelete = 0
END
GO

CREATE PROCEDURE GetCategoryById
    @Id INT
AS
BEGIN
    SELECT Id, Name, CreatedBy, CreatedDate FROM Category WHERE Id = @Id AND IsDelete = 0
END
GO

CREATE PROCEDURE GetCategoryByName
    @Name NVARCHAR(255)
AS
BEGIN
    SELECT Name, Id, CreatedBy, CreatedDate

	FROM Category

	WHERE Name LIKE '%' + @Name + '%' AND IsDelete = 0
END
GO

CREATE PROCEDURE UpdateCategory
    @Id INT,
    @Name NVARCHAR(255),
    @ModifiedBy INT
AS
BEGIN
    UPDATE Category
    SET Name = @Name,
        LastModifiedBy = @ModifiedBy,
        LastModifiedDate = GETDATE()
    WHERE Id = @Id AND IsDelete = 0
END
GO

CREATE PROCEDURE DeleteCategory
    @Id INT,
    @ModifiedBy INT
AS
BEGIN
    UPDATE Category
    SET IsDelete = 1,
        LastModifiedBy = @ModifiedBy,
        LastModifiedDate = GETDATE()
    WHERE Id = @Id
END
GO




--Stored Procedure Suppliers
CREATE PROCEDURE CreateSupplier
    @Name NVARCHAR(255),
    @Code VARCHAR(50),
    @Email VARCHAR(255),
    @PhoneNumber VARCHAR(10),
    @Address NVARCHAR(255),
    @Description NVARCHAR(500),
    @CreatedBy INT
AS
BEGIN
    INSERT INTO Supplier (Name, Code, Email, PhoneNumber, Address, Description, CreatedBy, CreatedDate)
    VALUES (@Name, @Code, @Email, @PhoneNumber, @Address, @Description, @CreatedBy, GETDATE())
END
GO

CREATE PROCEDURE GetSupplier
AS
BEGIN
    SELECT Id, Name, Code, Email, PhoneNumber,
		Address, Description, CreatedBy, CreatedDate
	FROM Supplier

	WHERE IsDelete = 0
END
GO

CREATE PROCEDURE GetSupplierById
    @Id INT
AS
BEGIN
    SELECT Id, Name, Code, Email, PhoneNumber,
		Address, Description, CreatedBy, CreatedDate
	FROM Supplier
	
	WHERE Id = @Id AND IsDelete = 0
END
GO

CREATE PROCEDURE GetSupplierByName
    @Name NVARCHAR(255)
AS
BEGIN
    SELECT Name, Id, Code, Email, PhoneNumber,
		Address, Description, CreatedBy, CreatedDate
	FROM Supplier

	WHERE Name LIKE '%' + @Name + '%' AND IsDelete = 0
END
GO

CREATE PROCEDURE GetSupplierByCode
    @Code VARCHAR(50)
AS
BEGIN
    SELECT Code, Id, Name, Email, PhoneNumber,
		Address, Description, CreatedBy, CreatedDate
	FROM Supplier

	WHERE Code LIKE '%' + @Code + '%' AND IsDelete = 0
END
GO

CREATE PROCEDURE UpdateSupplier
    @Id INT,
    @Name NVARCHAR(255),
    @Code VARCHAR(50),
    @Email VARCHAR(255),
    @PhoneNumber VARCHAR(10),
    @Address NVARCHAR(255),
    @Description NVARCHAR(500),
    @ModifiedBy INT
AS
BEGIN
    UPDATE Supplier
    SET Name = @Name,
        Code = @Code,
        Email = @Email,
        PhoneNumber = @PhoneNumber,
        Address = @Address,
        Description = @Description,
        LastModifiedBy = @ModifiedBy,
        LastModifiedDate = GETDATE()
    WHERE Id = @Id AND IsDelete = 0
END
GO

CREATE PROCEDURE DeleteSupplier
    @Id INT,
    @ModifiedBy INT
AS
BEGIN
    UPDATE Supplier
    SET IsDelete = 1,
        LastModifiedBy = @ModifiedBy,
        LastModifiedDate = GETDATE()
    WHERE Id = @Id AND IsDelete = 0
END
GO 






--Stored Procedure Products
CREATE PROCEDURE CreateProduct
    @Name NVARCHAR(255),
    @Detail NVARCHAR(255),
    @Price INT,
    @Number INT,
    @ImageUrl NVARCHAR(255),
	@SupplierId INT,
    @CategoryId INT,
    @CreatedBy INT
AS
BEGIN
    INSERT INTO Product (Name, Detail, Price, Number, ImageUrl, SupplierId, CategoryId, CreatedBy, CreatedDate)
    VALUES (@Name, @Detail, @Price, @Number, @ImageUrl, @SupplierId, @CategoryId, @CreatedBy, GETDATE())
END
GO

CREATE PROCEDURE GetProduct
AS
BEGIN
	SELECT Product.Id, Product.Name, Detail, Price, Number, ImageUrl,
		Supplier.Name AS NameSupplier , Category.Name AS NameCategory,
		AverageRating, Product.CreatedBy, Product.CreatedDate
	FROM Product 
		LEFT JOIN Supplier ON SupplierId = Supplier.Id 
		LEFT JOIN Category ON CategoryId = Category.Id	
	WHERE Product.IsDelete = 0
END
GO

CREATE PROCEDURE GetProductById
    @Id INT
AS
BEGIN
    SELECT Product.Id, Product.Name, Detail, Price, Number, ImageUrl,
		Supplier.Name AS NameSupplier , Category.Name AS NameCategory,
		AverageRating, Product.CreatedBy, Product.CreatedDate
	FROM Product 
		LEFT JOIN Supplier ON SupplierId = Supplier.Id 
		LEFT JOIN Category ON CategoryId = Category.Id
	WHERE Product.Id = @Id AND Product.IsDelete = 0
END
GO

CREATE PROCEDURE GetProductByName
    @Name NVARCHAR(255)
AS
BEGIN
    SELECT Product.Name, Product.Id, Detail, Price, Number, ImageUrl,
		Supplier.Name AS NameSupplier , Category.Name AS NameCategory,
		AverageRating, Product.CreatedBy, Product.CreatedDate
	FROM Product 
		LEFT JOIN Supplier ON SupplierId = Supplier.Id 
		LEFT JOIN Category ON CategoryId = Category.Id
	WHERE Product.Name LIKE '%' + @Name + '%' AND
		Product.IsDelete = 0
END
GO

CREATE PROCEDURE GetProductByNameSupplier
    @NameSupplier NVARCHAR(255)
AS
BEGIN
    SELECT Supplier.Name AS NameSupplier, Product.Id, Product.Name,
		Detail, Price, Number, ImageUrl, Category.Name AS NameCategory,
		AverageRating, Product.CreatedBy, Product.CreatedDate
	FROM Product 
		LEFT JOIN Supplier ON SupplierId = Supplier.Id 
		LEFT JOIN Category ON CategoryId = Category.Id
	WHERE Supplier.Name LIKE '%' + @NameSupplier + '%' AND
		Product.IsDelete = 0;
END
GO

CREATE PROCEDURE GetProductByNameCategory
    @NameCategory NVARCHAR(255)
AS
BEGIN
    SELECT Category.Name AS NameCategory, Product.Id, Product.Name,
		Detail, Price, Number, ImageUrl, Supplier.Name AS NameSupplier,
		AverageRating, Product.CreatedBy, Product.CreatedDate
	FROM Product 
		LEFT JOIN Supplier ON SupplierId = Supplier.Id 
		LEFT JOIN Category ON CategoryId = Category.Id
	WHERE Category.Name LIKE '%' + @NameCategory + '%'AND
		Product.IsDelete = 0;
END
GO

CREATE PROCEDURE UpdateProduct
    @Id INT,
    @Name NVARCHAR(255),
    @Detail NVARCHAR(255),
    @Price INT,
    @Number INT,
    @ImageUrl NVARCHAR(255),
	@SupplierId INT,
    @CategoryId INT,
    @ModifiedBy INT
AS
BEGIN
    UPDATE Product
    SET Name = @Name,
        Detail = @Detail,
        Price = @Price,
        Number = @Number,
        ImageUrl = @ImageUrl,
		SupplierId = @SupplierId,
        CategoryId = @CategoryId,
        LastModifiedBy = @ModifiedBy,
        LastModifiedDate = GETDATE()
    WHERE Id = @Id AND IsDelete = 0
END
GO

CREATE PROCEDURE DeleteProduct
    @Id INT,
    @ModifiedBy INT
AS
BEGIN
    UPDATE Product
    SET IsDelete = 1,
        LastModifiedBy = @ModifiedBy,
        LastModifiedDate = GETDATE()
    WHERE Id = @Id
END
GO










--Stored Procedure Promotion
CREATE PROCEDURE CreatePromotion
    @Code VARCHAR(50),
    @DiscountType NVARCHAR(20),
    @DiscountValue INT,
    @MaxAmount INT,
    @ApplicableMembership NVARCHAR(50),
    @StartDate DATE,
    @EndDate DATE,
    @MinOrderValue INT,
    @UsageLimit INT,
    @Description NVARCHAR(255),
    @CreatedBy INT
AS
BEGIN
    INSERT INTO Promotion (
        Code, DiscountType, DiscountValue, MaxAmount, ApplicableMembership, 
        StartDate, EndDate, MinOrderValue, UsageLimit, Description, 
        CreatedBy, CreatedDate
    )
    VALUES (
        @Code, @DiscountType, @DiscountValue, @MaxAmount, 
        @ApplicableMembership, 
        @StartDate, @EndDate, @MinOrderValue, @UsageLimit, @Description, 
        @CreatedBy, GETDATE()
    )
END
GO

CREATE PROCEDURE GetPromotion
AS
BEGIN
	SELECT Id, Code, DiscountType, DiscountValue, MaxAmount, ApplicableMembership,
		StartDate, EndDate, MinOrderValue, UsageLimit,
		Description, IsActive, CreatedBy, CreatedDate
	FROM Promotion
	
	WHERE IsDelete = 0
END
GO

CREATE PROCEDURE GetPromotionById
    @Id INT
AS
BEGIN
    SELECT Id, Code, DiscountType, DiscountValue, MaxAmount, ApplicableMembership, 
		StartDate, EndDate, MinOrderValue, UsageLimit,
		Description, IsActive, CreatedBy, CreatedDate
	FROM Promotion
	
	WHERE Id = @Id AND IsDelete = 0
END
GO

CREATE PROCEDURE GetPromotionByCode
    @Code VARCHAR(50)
AS
BEGIN
    SELECT Id, Code, DiscountType, DiscountValue, MaxAmount, ApplicableMembership,
		StartDate, EndDate, MinOrderValue, UsageLimit,
		Description, IsActive, CreatedBy, CreatedDate
	FROM Promotion
	
	WHERE Code LIKE '%' + @Code + '%' AND IsDelete = 0
END
GO

CREATE PROCEDURE GetPromotionByDiscountType
    @DiscountType VARCHAR(50)
AS
BEGIN
    SELECT DiscountType, Id, Code, DiscountValue, MaxAmount, ApplicableMembership,
		StartDate, EndDate, MinOrderValue, UsageLimit,
		Description, IsActive, CreatedBy, CreatedDate
	FROM Promotion
	
	WHERE  DiscountType LIKE '%' +  @DiscountType + '%' AND IsDelete = 0
END
GO

CREATE PROCEDURE UpdatePromotion
    @Id INT,
    @Code VARCHAR(50),
    @DiscountType NVARCHAR(20),
    @DiscountValue INT,
    @MaxAmount INT,
    @ApplicableMembership NVARCHAR(50),
    @StartDate DATE,
    @EndDate DATE,
    @MinOrderValue INT,
    @UsageLimit INT,
    @Description NVARCHAR(255),
	@IsActive BIT,
    @ModifiedBy INT
AS
BEGIN
    UPDATE Promotion
    SET 
        Code = @Code,
        DiscountType = @DiscountType,
        DiscountValue = @DiscountValue,
        MaxAmount = @MaxAmount,
        ApplicableMembership = @ApplicableMembership,
        StartDate = @StartDate,
        EndDate = @EndDate,
        MinOrderValue = @MinOrderValue,
        UsageLimit = @UsageLimit,
        Description = @Description,
		IsActive = @IsActive,
        LastModifiedBy = @ModifiedBy,
        LastModifiedDate = GETDATE()
    WHERE Id = @Id AND IsDelete = 0
END
GO

CREATE PROCEDURE DeletePromotion
    @Id INT,
    @ModifiedBy INT
AS
BEGIN
    UPDATE Promotion
    SET IsDelete = 1,
        LastModifiedBy = @ModifiedBy,
        LastModifiedDate = GETDATE()
    WHERE Id = @Id
END
GO









--Stored Proceduce Orders
CREATE PROCEDURE CreateOrder
    @UserId INT,
    @TotalPrice INT,
    @ShippingAddress NVARCHAR(255),
    @PromotionId INT,
    @CreatedBy INT
AS
BEGIN
    INSERT INTO Orders (UserId, TotalPrice, ShippingAddress, PromotionId, CreatedBy, CreatedDate)
    VALUES (@UserId, @TotalPrice, @ShippingAddress, @PromotionId, @CreatedBy, GETDATE())
END
GO

CREATE PROCEDURE GetOrderByFilter
    @AccountName NVARCHAR(255),
    @StartDate DATETIME,
    @EndDate DATETIME,
    @ProductName NVARCHAR(255),
    @Status NVARCHAR(20)
AS
BEGIN
    DECLARE @StartDateAdd DATETIME = DATEADD(SECOND, -1, @StartDate);
    DECLARE @EndDateAdd DATETIME = DATEADD(DAY, 1, @EndDate);
    DECLARE @SQL NVARCHAR(MAX)
    SET @SQL = N'
        SELECT Orders.Id, Account.Name, OrderDate, Status, TotalPrice, ShippingAddress, PromotionId,
               Orders.CreatedBy, Orders.CreatedDate
        FROM Orders
            LEFT JOIN Account ON Account.Id = Orders.UserId
            LEFT JOIN OrderDetail ON Orders.Id = OrderDetail.OrderId 
            LEFT JOIN Product ON OrderDetail.ProductId = Product.Id
        WHERE Orders.IsDelete = 0
    '

    -- Thêm điều kiện động
    IF @AccountName IS NOT NULL AND  DATALENGTH(@AccountName) > 0
        SET @SQL += N' AND Account.Name LIKE N''%'' + @AccountName + N''%'''

    IF @ProductName IS NOT NULL AND DATALENGTH(@ProductName) > 0
        SET @SQL += N' AND Product.Name LIKE N''%'' + @ProductName + N''%'''

 IF @StartDate IS NOT NULL
        SET @SQL += N' AND Orders.OrderDate > @StartDateAdd';

    IF @EndDate IS NOT NULL
        SET @SQL += N' AND Orders.OrderDate < @EndDateAdd';

    IF @Status IS NOT NULL AND DATALENGTH(@Status) > 0
        SET @SQL += N' AND Orders.Status = @Status'

	SET @SQL += N'
		GROUP BY 
			Account.Name,
			Orders.Id,
			Orders.OrderDate,
			Orders.Status,
			Orders.TotalPrice,
			Orders.ShippingAddress,
			Orders.PromotionId,
			Orders.CreatedBy,
			Orders.CreatedDate
	'	

    -- Thực thi truy vấn động
    EXEC sp_executesql 
        @stmt = @SQL,
        @params = N'@AccountName NVARCHAR(255), @ProductName NVARCHAR(255), @StartDateAdd DATETIME, @EndDateAdd DATETIME, @Status NVARCHAR(20)',
        @AccountName = @AccountName,
        @ProductName = @ProductName,
        @StartDateAdd = @StartDateAdd,
        @EndDateAdd = @EndDateAdd,
        @Status = @Status;
END
GO

CREATE PROCEDURE UpdateOrder
    @Id INT,
    @Status NVARCHAR(20),
    @TotalPrice INT,
    @ShippingAddress NVARCHAR(255),
    @PromotionId INT,
    @ModifiedBy INT
AS
BEGIN
    UPDATE Orders
    SET Status = @Status,
        TotalPrice = @TotalPrice,
        ShippingAddress = @ShippingAddress,
        PromotionId = @PromotionId,
        LastModifiedBy = @ModifiedBy,
        LastModifiedDate = GETDATE()
    WHERE Id = @Id AND IsDelete = 0
END
GO

CREATE PROCEDURE DeleteOrder
    @Id INT,
    @ModifiedBy INT
AS
BEGIN
    UPDATE Orders
    SET IsDelete = 1,
        LastModifiedBy = @ModifiedBy,
        LastModifiedDate = GETDATE()
    WHERE Id = @Id
END
GO





--Stored Procedure OrderDetail
CREATE PROCEDURE CreateOrderDetail
    @OrderId INT,
    @ProductId INT,
    @Number INT,
    @Price INT,
    @CreatedBy INT
AS
BEGIN
    INSERT INTO OrderDetail (OrderId, ProductId, Number, Price, CreatedBy, CreatedDate)
    VALUES (@OrderId, @ProductId, @Number, @Price, @CreatedBy, GETDATE())
END
GO

CREATE PROCEDURE GetOrderDetail
AS
BEGIN
	SELECT OrderDetail.Id, OrderId, Product.Name, OrderDetail.Number,
		OrderDetail.Price, OrderDetail.CreatedBy, OrderDetail.CreatedDate
	FROM OrderDetail
		LEFT JOIN Product ON ProductId = Product.Id
	WHERE OrderDetail.IsDelete = 0
END
GO

CREATE PROCEDURE GetOrderDetailByOrderIdandProductId
	@OrderId INT,
    @ProductId INT
AS
BEGIN
	SELECT OrderDetail.Id, OrderId, Product.Name, OrderDetail.Number,
		OrderDetail.Price, OrderDetail.CreatedBy, OrderDetail.CreatedDate
	FROM OrderDetail
		LEFT JOIN Product ON ProductId = Product.Id
	WHERE OrderId = @OrderId AND
		ProductId = @ProductId AND
		OrderDetail.IsDelete = 0
END
GO

CREATE PROCEDURE GetOrderDetailById
    @Id INT
AS
BEGIN
    SELECT OrderDetail.Id, OrderId, Product.Name, OrderDetail.Number,
		OrderDetail.Price, OrderDetail.CreatedBy, OrderDetail.CreatedDate
	FROM OrderDetail
		LEFT JOIN Product ON ProductId = Product.Id
    WHERE OrderDetail.Id = @Id AND
		OrderDetail.IsDelete = 0;
END
GO

CREATE PROCEDURE GetOrderDetailByOrderId
    @OrderId INT
AS
BEGIN
	SELECT OrderId, OrderDetail.Id, Product.Name, OrderDetail.Number,
		OrderDetail.Price, OrderDetail.CreatedBy, OrderDetail.CreatedDate
	FROM OrderDetail
		LEFT JOIN Product ON ProductId = Product.Id
    WHERE OrderId = @OrderId AND
		OrderDetail.IsDelete = 0;
END
GO

CREATE PROCEDURE UpdateOrderDetail
    @Id INT,
    @Number INT,
    @Price INT,
    @ModifiedBy INT
AS
BEGIN
    UPDATE OrderDetail
    SET Number = @Number,
        Price = @Price,
        LastModifiedBy = @ModifiedBy,
        LastModifiedDate = GETDATE()
    WHERE Id = @Id AND IsDelete = 0;
END
GO



CREATE PROCEDURE DeleteOrderDetail
    @Id INT,
    @ModifiedBy INT
AS
BEGIN
    UPDATE OrderDetail
    SET IsDelete = 1,
        LastModifiedBy = @ModifiedBy,
        LastModifiedDate = GETDATE()
    WHERE Id = @Id;
END
GO






--Stored Procedure Delivery
CREATE PROCEDURE CreateDelivery
    @OrderId INT,
    @DeliveryDate DATETIME,
    @Status NVARCHAR(50),
    @DeliveryFee INT,
    @CreatedBy INT
AS
BEGIN
    DECLARE @ShippingAddress NVARCHAR(255);

    -- Lấy ShippingAddress từ Orders dựa trên OrderId
    SELECT @ShippingAddress = ShippingAddress 
    FROM Orders 
    WHERE Id = @OrderId;

    INSERT INTO Delivery (OrderId, DeliveryDate, Status, ShippingAddress, DeliveryFee, CreatedBy, CreatedDate)
    VALUES (@OrderId, @DeliveryDate, @Status, @ShippingAddress, @DeliveryFee, @CreatedBy, GETDATE())
END
GO

CREATE PROCEDURE GetDeliveryById
    @Id INT
AS
BEGIN
    SELECT * FROM Delivery WHERE Id = @Id AND IsDelete = 0
END
GO

CREATE PROCEDURE UpdateDelivery
    @Id INT,
    @DeliveryDate DATETIME,
    @Status NVARCHAR(50),
    @ShippingAddress NVARCHAR(255),
    @DeliveryFee INT,
    @ModifiedBy INT
AS
BEGIN
    UPDATE Delivery
    SET DeliveryDate = @DeliveryDate,
        Status = @Status,
        ShippingAddress = @ShippingAddress,
        DeliveryFee = @DeliveryFee,
        LastModifiedBy = @ModifiedBy,
        LastModifiedDate = GETDATE()
    WHERE Id = @Id AND IsDelete = 0
END
GO

CREATE PROCEDURE DeleteDelivery
    @Id INT,
    @ModifiedBy INT
AS
BEGIN
    UPDATE Delivery
    SET IsDelete = 1,
        LastModifiedBy = @ModifiedBy,
        LastModifiedDate = GETDATE()
    WHERE Id = @Id
END
GO





--Stored Procedure ProductReviews
CREATE PROCEDURE CreateProductReview
    @UserId INT,
    @ProductId INT,
    @Rating INT,
    @Comment NVARCHAR(1024),
    @CreatedBy INT
AS
BEGIN
    INSERT INTO ProductReview (UserId, ProductId, Rating, Comment, CreatedBy, CreatedDate)
    VALUES (@UserId, @ProductId, @Rating, @Comment, @CreatedBy, GETDATE())
END
GO

CREATE PROCEDURE GetProductReview
    @ProductId INT
AS
BEGIN
    SELECT * FROM ProductReview 
    WHERE ProductId = @ProductId AND IsDelete = 0
END
GO

CREATE PROCEDURE UpdateProductReview
	@Id INT,
    @Rating INT,
    @Comment NVARCHAR(1024),
    @ModifiedBy INT
AS
BEGIN
    UPDATE ProductReview
    SET Rating = @Rating,
        Comment = @Comment,
        LastModifiedBy = @ModifiedBy,
        LastModifiedDate = GETDATE()
    WHERE Id = @Id AND IsDelete = 0
END
GO

CREATE PROCEDURE DeleteProductReview
	@Id INT,
    @ModifiedBy INT
AS
BEGIN
    UPDATE ProductReview
    SET IsDelete = 1,
        LastModifiedBy = @ModifiedBy,
        LastModifiedDate = GETDATE()
    WHERE Id = @Id
END
GO
-- 1. Create Accounts
EXEC CreateAccount
    @Email = 'user1@example.com',
    @Name = N'Nguyễn Văn A',
    @PhoneNumber = '0123456789',
    @PassWord = 'hashed_password',
    @Role = 'User',
    @CreatedBy = 1; -- Assume admin with Id=1 exists

EXEC CreateAccount
    @Email = 'user2@example.com',
    @Name = N'Trần Thị B',
    @PhoneNumber = '0987654321',
    @PassWord = 'hashed_password2',
    @Role = 'Admin',
    @CreatedBy = 1;

EXEC CreateAccount
    @Email = 'user3@example.com',
    @Name = N'Lê Minh C',
    @PhoneNumber = '0912345678',
    @PassWord = 'hashed_password3',
    @Role = 'User',
    @CreatedBy = 2;

-- 2. Create Memberships
EXEC CreateMembership
    @LevelName = N'Basic',
    @MinSpend = 0,
    @DowngradeAfterMonths = NULL,
    @Description = N'Cấp mặc định',
    @CreatedBy = 2;

EXEC CreateMembership
    @LevelName = N'Silver',
    @MinSpend = 1000000,
    @DowngradeAfterMonths = 6,
    @Description = N'Cấp cơ bản',
    @CreatedBy = 2;

EXEC CreateMembership
    @LevelName = N'Gold',
    @MinSpend = 5000000,
    @DowngradeAfterMonths = 6,
    @Description = N'Cấp trung',
    @CreatedBy = 2;

EXEC CreateMembership
    @LevelName = N'Platinum',
    @MinSpend = 10000000,
    @DowngradeAfterMonths = 12,
    @Description = N'Cấp cao cấp',
    @CreatedBy = 2;


-- 4. Create Suppliers
EXEC CreateSupplier
    @Name = N'Nhà cung cấp A',
    @Code = 'SUP001',
    @Email = 'supplier1@example.com',
    @PhoneNumber = '0123456789',
    @Address = N'123 Đường Láng, Hà Nội',
    @Description = N'Chuyên cung cấp bút',
    @CreatedBy = 2;

EXEC CreateSupplier
    @Name = N'Nhà cung cấp B',
    @Code = 'SUP002',
    @Email = 'supplier2@example.com',
    @PhoneNumber = '0981234567',
    @Address = N'456 Cầu Giấy, Hà Nội',
    @Description = N'Chuyên cung cấp giấy',
    @CreatedBy = 2;

-- 5. Create Categories
EXEC CreateCategory
    @Name = N'Bút thư pháp',
    @CreatedBy = 2;

EXEC CreateCategory
    @Name = N'Giấy thư pháp',
    @CreatedBy = 2;

EXEC CreateCategory
    @Name = N'Mực thư pháp',
    @CreatedBy = 2;

-- 6. Create Products
EXEC CreateProduct
    @Name = N'Bút lông thư pháp',
    @Detail = N'Bút lông chất lượng cao',
    @Price = 100000,
    @Number = 50,
    @ImageUrl = 'http://example.com/but.jpg',
    @SupplierId = 1,
    @CategoryId = 1,
    @CreatedBy = 2;

EXEC CreateProduct
    @Name = N'Giấy thư pháp cao cấp',
    @Detail = N'Giấy chất lượng cao cho thư pháp',
    @Price = 50000,
    @Number = 100,
    @ImageUrl = 'http://example.com/giay.jpg',
    @SupplierId = 2,
    @CategoryId = 2,
    @CreatedBy = 2;

-- 7. Create Promotions
EXEC CreatePromotion
    @Code = N'PROMO1',
    @DiscountType = N'Percent',
    @DiscountValue = 10,
    @MaxAmount = 500000,
    @ApplicableMembership = 'All',
    @StartDate = '2025-05-01',
    @EndDate = '2025-12-31',
    @MinOrderValue = 500000,
    @UsageLimit = 100,
    @Description = N'Khuyến mãi cho tất cả',
    @CreatedBy = 2;

EXEC CreatePromotion
    @Code = N'PROMO2',
    @DiscountType = N'Fixed',
    @DiscountValue = 50000,
    @MaxAmount = 50000,
    @ApplicableMembership = 'Silver,Gold,Platinum',
    @StartDate = '2025-06-01',
    @EndDate = '2025-11-30',
    @MinOrderValue = 200000,
    @UsageLimit = 50,
    @Description = N'Khuyến mãi cho thành viên cao cấp',
    @CreatedBy = 2;

-- 8. Create Orders (all using PROMO1 or NULL if < 500,000 VND)
EXEC CreateOrder
    @UserId = 1, -- Nguyễn Văn A (Basic)
    @TotalPrice = 540000, -- 6 * 100000 = 600000 - 10% (60000)
    @ShippingAddress = N'123 Đường Láng, Hà Nội',
    @PromotionId = 1, -- PROMO1
    @CreatedBy = 1;

EXEC CreateOrder
    @UserId = 3, -- Lê Minh C (Silver)
    @TotalPrice = 600000, -- 12 * 50000 = 600000 - 10% (60000)
    @ShippingAddress = N'789 Ba Đình, Hà Nội',
    @PromotionId = 1, -- PROMO1
    @CreatedBy = 3;

EXEC CreateOrder
    @UserId = 1, -- Nguyễn Văn A (Basic)
    @TotalPrice = 900000, -- 10 * 100000 = 1000000 - 10% (100000)
    @ShippingAddress = N'123 Đường Láng, Hà Nội',
    @PromotionId = 1, -- PROMO1
    @CreatedBy = 1;

EXEC CreateOrder
    @UserId = 3, -- Lê Minh C (Silver)
    @TotalPrice = 540000, -- 12 * 50000 = 600000 - 10% (60000)
    @ShippingAddress = N'789 Ba Đình, Hà Nội',
    @PromotionId = 1, -- PROMO1
    @CreatedBy = 3;

EXEC CreateOrder
    @UserId = 1, -- Nguyễn Văn A (Basic)
    @TotalPrice = 630000, -- (3 * 100000 + 7 * 50000) = 650000 - 10% (65000)
    @ShippingAddress = N'123 Đường Láng, Hà Nội',
    @PromotionId = 1, -- PROMO1
    @CreatedBy = 1;

-- 9. Create Order Details
EXEC CreateOrderDetail
    @OrderId = 1,
    @ProductId = 1, -- Bút lông thư pháp
    @Number = 6,
    @Price = 100000,
    @CreatedBy = 2;

EXEC CreateOrderDetail
    @OrderId = 2,
    @ProductId = 2, -- Giấy thư pháp cao cấp
    @Number = 12,
    @Price = 50000,
    @CreatedBy = 2;

EXEC CreateOrderDetail
    @OrderId = 3,
    @ProductId = 1, -- Bút lông thư pháp
    @Number = 10,
    @Price = 100000,
    @CreatedBy = 2;

EXEC CreateOrderDetail
    @OrderId = 4,
    @ProductId = 2, -- Giấy thư pháp cao cấp
    @Number = 12,
    @Price = 50000,
    @CreatedBy = 2;

EXEC CreateOrderDetail
    @OrderId = 5,
    @ProductId = 1, -- Bút lông thư pháp
    @Number = 3,
    @Price = 100000,
    @CreatedBy = 2;

EXEC CreateOrderDetail
    @OrderId = 5,
    @ProductId = 2, -- Giấy thư pháp cao cấp
    @Number = 7,
    @Price = 50000,
    @CreatedBy = 2;

-- 10. Create Deliveries
EXEC CreateDelivery
    @OrderId = 1,
    @DeliveryDate = '2025-05-22 10:00:00', -- 2 days after May 20, 2025
    @Status = N'Chưa giao',
    @DeliveryFee = 30000,
    @CreatedBy = 2;

EXEC CreateDelivery
    @OrderId = 2,
    @DeliveryDate = '2025-05-23 14:00:00', -- 3 days after
    @Status = N'Chưa giao',
    @DeliveryFee = 25000,
    @CreatedBy = 2;

EXEC CreateDelivery
    @OrderId = 3,
    @DeliveryDate = '2025-05-24 09:00:00', -- 4 days after
    @Status = N'Chưa giao',
    @DeliveryFee = 30000,
    @CreatedBy = 2;

EXEC CreateDelivery
    @OrderId = 4,
    @DeliveryDate = '2025-05-25 11:00:00', -- 5 days after
    @Status = N'Chưa giao',
    @DeliveryFee = 25000,
    @CreatedBy = 2;

EXEC CreateDelivery
    @OrderId = 5,
    @DeliveryDate = '2025-05-23 12:00:00', -- 3 days after
    @Status = N'Chưa giao',
    @DeliveryFee = 35000,
    @CreatedBy = 2;

-- 11. Create Product Reviews
EXEC CreateProductReview
    @UserId = 1, -- Nguyễn Văn A
    @ProductId = 1, -- Bút lông thư pháp (Orders 1, 3, 5)
    @Rating = 5,
    @Comment = N'Bút viết rất mượt, đáng tiền',
    @CreatedBy = 1;

EXEC CreateProductReview
    @UserId = 3, -- Lê Minh C
    @ProductId = 2, -- Giấy thư pháp cao cấp (Orders 2, 4)
    @Rating = 5,
    @Comment = N'Giấy rất đẹp, phù hợp thư pháp',
    @CreatedBy = 3;

EXEC CreateProductReview
    @UserId = 1, -- Nguyễn Văn A
    @ProductId = 2, -- Giấy thư pháp cao cấp (Order 5)
    @Rating = 4,
    @Comment = N'Giấy tốt, nhưng hơi mỏng',
    @CreatedBy = 1;

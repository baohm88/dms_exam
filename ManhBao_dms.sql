-- 1. Write a script to create database with name is XgameBattle and all table in diagram(Table 1).
CREATE DATABASE XgameBattle;
USE XgameBattle;

CREATE TABLE PlayerTable (
	PlayerId CHAR(38) NOT NULL,
    PlayerName NVARCHAR(120) NOT NULL,
    PlayerNational NVARCHAR(50) NOT NULL,
    PRIMARY KEY (PlayerId)
);

CREATE TABLE ItemTypeTable (
	ItemTypeId INT(4) NOT NULL,
    ItemTypeName NVARCHAR(50) NOT NULL,
    PRIMARY KEY (ItemTypeId)
);

CREATE TABLE ItemTable (
	ItemId CHAR(38) NOT NULL,
    ItemName NVARCHAR(120) NOT NULL,
    ItemTypeId INT NOT NULL,
    Price DECIMAL(21,6) NOT NULL,
    PRIMARY KEY (ItemId),
    FOREIGN KEY(ItemTypeId) REFERENCES ItemTypeTable(ItemTypeId)
);

CREATE TABLE PlayerItem (
	ItemId CHAR(38) NOT NULL,
    PlayerId CHAR(38) NOT NULL,
    FOREIGN KEY(ItemId) REFERENCES ItemTable(ItemId),
    FOREIGN KEY(PlayerId) REFERENCES PlayerTable(PlayerId)
);

-- 2. Write a script to insert values in (Table 2, Table 3, Table 4, Table 5) into the database.

INSERT INTO PlayerTable (PlayerId, PlayerName, PlayerNational)
VALUES ('2C16E515-83AF-4D37-8A21-58AFD900E3F6', 'Player 1', 'Viet Nam'),
		    ('D401EA60-7A83-4C7E-BF6E-707CF1F3E57E', 'Player 2', 'US');

INSERT INTO ItemTypeTable (ItemTypeId, ItemTypeName )
VALUES (1, 'Attack'),
		  (2, 'Defense');


INSERT INTO ItemTable (ItemId, ItemName, ItemTypeId,Price)
VALUES ('72B83972-051D-4B96-B229-05DE585DF1EE', 'Gun', 1, 5),
		    ('83B931C2-AC84-4080-9852-5734C4E05082', 'Bullet', 1, 10),
        ('97E25C9F-FA12-4D9A-AB32-D62EBC2107BF', 'Shield', 2, 20);

INSERT INTO PlayerItem (ItemId, PlayerId )
VALUES ('72B83972-051D-4B96-B229-05DE585DF1EE', '2C16E515-83AF-4D37-8A21-58AFD900E3F6'),
		    ('72B83972-051D-4B96-B229-05DE585DF1EE', 'D401EA60-7A83-4C7E-BF6E-707CF1F3E57E'),
        ('83B931C2-AC84-4080-9852-5734C4E05082', '2C16E515-83AF-4D37-8A21-58AFD900E3F6'),
        ('83B931C2-AC84-4080-9852-5734C4E05082', 'D401EA60-7A83-4C7E-BF6E-707CF1F3E57E'),
        ('97E25C9F-FA12-4D9A-AB32-D62EBC2107BF', '2C16E515-83AF-4D37-8A21-58AFD900E3F6'),
        ('97E25C9F-FA12-4D9A-AB32-D62EBC2107BF', 'D401EA60-7A83-4C7E-BF6E-707CF1F3E57E');


-- 3. Write a store procedure to calculate maximun price of the item where Player 1
DELIMITER $$
CREATE PROCEDURE getMaxItemPriceByPlayerName(IN p_name CHAR(120))
BEGIN
	WITH tmp as (
		SELECT IT.Price, PT.PlayerName FROM PlayerItem PI
		INNER JOIN ItemTable IT ON IT.ItemId = PI.ItemID
		INNER JOIN PlayerTable PT ON PT.PlayerID = PI.PlayerID)
		SELECT max(Price) as MaxPrice from tmp WHERE PlayerName = p_name;
END $$retrieveDataAndOrderByPlayerName

DELIMITER ;

CALL getMaxItemPriceByPlayerName('Player 1');


-- 4. Write a stored procedure to retrieve data and order by Player name following below table
DELIMITER $$
CREATE PROCEDURE retrieveDataAndOrderByPlayerName()
BEGIN
	SELECT pt.PlayerName as 'Player name', it.ItemName as 'Item name',itt.ItemTypeName as 'Item type', it.Price  FROM PlayerTable pt
	JOIN PlayerItem pi on pi.PlayerId = pt.PlayerId
	JOIN ItemTable it on it.ItemId = pi.ItemId
	JOIN ItemTypeTable itt on itt.ItemTypeId = it.ItemTypeId
	ORDER BY 'Player name';
END $$

DELIMITER ;

CALL retrieveDataAndOrderByPlayerName();

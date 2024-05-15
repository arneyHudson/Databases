DROP TABLE IF EXISTS test;
DROP TABLE IF EXISTS exampletable;

-- SET autocommit=1;
SET autocommit=0;
-- SELECT @@autocommit;
/*
CREATE TABLE Test(Num INTEGER NOT NULL) engine=InnoDB;

-- INSERT INTO Test VALUES (1), (2), (3);
-- SELECT * FROM TEST;

/*SET autocommit=0;
INSERT INTO Test VALUES (4), (5);
SELECT * FROM Test;

-- Step 1: Disable autocommit
SET autocommit=0;

-- Step 2: Begin a transaction
START TRANSACTION;

-- Step 3: Perform operations, intentionally introduce an error
INSERT INTO Test VALUES (1), (2), (3); -- Assume this succeeds
INSERT INTO Test VALUES (2); -- Intentionally causes a duplicate key error

-- Step 4: Rollback the transaction
-- ROLLBACK;

-- Step 5: Verify if changes were successfully rolled back
SELECT * FROM Test;*/


SET autocommit=0;

CREATE TABLE ExampleTable (
    ID INT PRIMARY KEY,
    Value INT
);

INSERT INTO ExampleTable VALUES (1, 10);

START TRANSACTION;
START TRANSACTION;

UPDATE ExampleTable SET Value = Value + 5 WHERE ID = 1;
UPDATE ExampleTable SET Value = Value - 3 WHERE ID = 1;

COMMIT;
COMMIT;

SELECT * FROM ExampleTable;


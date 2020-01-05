CREATE DEFINER=`root`@`localhost` PROCEDURE `on_new_purchase`(IN id_products BIGINT(20), IN cnt INT(11), IN id_purchases BIGINT(20))
BEGIN
	SET @curr_cnt = 0;
	IF EXISTS(SELECT COUNT(*) FROM otus.products p WHERE p.id_products = id_products) THEN
		IF EXISTS(SELECT COUNT(*) FROM otus.warehouse w WHERE w.id_products = id_products) THEN
			START TRANSACTION;
			SELECT w.count INTO @curr_cnt FROM otus.warehouse w WHERE w.id_products = id_products;
            IF @curr_cnt >= cnt THEN
            SET @diff = @curr_cnt - cnt;
				UPDATE otus.warehouse w SET w.count = @diff WHERE w.id_products = id_products;
                UPDATE otus.purchases pu SET pu.status = 1 WHERE pu.id_purchases = id_purchases;
				COMMIT;
			ELSE
				ROLLBACK;
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Product count should not be negative';
			END IF;
		ELSE
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Product is not found in the warehouse';
		END IF;
		ELSE
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Product with provided id is not found';
	END IF;
END
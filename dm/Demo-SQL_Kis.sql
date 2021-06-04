select * from Kis_customer;

CREATE OR REPLACE TRIGGER TRG_KIS_CUSTOMER
BEFORE INSERT OR UPDATE ON KIS_CUSTOMER
FOR EACH ROW
DECLARE 
BEGIN 

    IF (:NEW.CREDITS < 0 ) THEN
        RAISE_APPLICATION_ERROR (-209, 'The credits has to be greater or equal to 0');
    END IF;
    
    IF (:NEW.BIRTHDATE >= SYSDATE) THEN
        RAISE_APPLICATION_ERROR (-208, 'The birthdate must be below the current date');
    END IF;
    
    IF (UPDATING AND :OLD.BIRTHDATE <> :NEW.BIRTHDATE) THEN
        RAISE_APPLICATION_ERROR (-207, 'The birthdate cannot be updated');
    END IF;    
    
    IF (NOT REGEXP_LIKE (:NEW.email,'^[A-Za-z][A-Za-z0-9\.-]*@[A-Za-z]+\.[A-Za-z]+$')) THEN
    RAISE_APPLICATION_ERROR(-206, 'The email is not valid');
    END IF;

END;

COMMIT;

CREATE OR REPLACE PROCEDURE 
PROC_NEW_KIS_CUSTOMER (
                        EMAIL IN VARCHAR2,
                        FIRSTNAME IN VARCHAR2,
                        LASTNAME IN VARCHAR2,
                        GENDER IN VARCHAR2,
                        BIRTHDATE IN DATE,
                        CREDITS IN OUT NUMBER) IS

CUSTOMER_ID NUMBER;
BEGIN

  CUSTOMER_ID := SEQ_CUSTOMER_ID.nextval;
  
  IF CREDITS IS NULL THEN
     CREDITS := 10;
  END IF;
  
  INSERT INTO KIS_CUSTOMER VALUES(CUSTOMER_ID,EMAIL, FIRSTNAME,LASTNAME,GENDER, BIRTHDATE, CREDITS);

END;
/*
		BY : Customizated  by atia  2018
		API Name  : Oracle HRMS - Photo Upload API	
		Version : 1.0.0
**/
/*
	Step #1:
		Connect to Database Using SYS / SYSTEM.
		SELECT VALUE FROM V$PARAMETER WHERE UPPER(NAME) = 'UTL_FILE_DIR';
	Step #2:
		Connect to Database Server & Create Directory "xxempimages" in one of the 'UTL_FILE_DIR' in this
	case "/usr/tmp/".
		Grant READ, WRITE & EXECUTE permissions to the Directory "xxempimages".
		Move all the Employee Images into this Directory.--
	Step #3:
		Connect to Database Using SYS / SYSTEM and Execute the below SQL Statements to Create Directory inside Database also to Grant permissions to APPS Schema.
		
		CREATE DIRECTORY XXCUST_EMP_IMAGES AS '/usr/tmp/xxempimages'; GRANT READ ON DIRECTORY XXCUST_EMP_IMAGES TO APPS; GRANT WRITE ON DIRECTORY XXCUST_EMP_IMAGES TO APPS;
	
		Step #4:
			Connect to Database Using APPS and Execute the below PLSQL to Upload the Employee Images into PER_IMAGES Table.

*/
CREATE OR REPLACE PROCEDURE APPS.XX_IMAGE_UPLOAD
AS
   CURSOR CUR_PER
   IS
      SELECT * FROM APPS.PER_ALL_PEOPLE_F;  --where employee_number = '1772';

   V_IMAGE_NAME    VARCHAR2 (240);
   V_DSTN_FILE     BLOB;
   V_SRC_FILE      BFILE;
   V_FILE_EXISTS   INTEGER := 0;
   V_AMT           INTEGER ;
BEGIN
   FOR I IN CUR_PER
   LOOP
      BEGIN
         V_IMAGE_NAME := TO_CHAR (I.attribute1) || '.jpg';
         V_SRC_FILE := BFILENAME ('XXCUST_EMP_IMAGES', V_IMAGE_NAME);
         V_FILE_EXISTS := DBMS_LOB.FILEEXISTS (V_SRC_FILE);
         
          V_AMT := DBMS_LOB.GETLENGTH(V_SRC_FILE) ;

         IF V_FILE_EXISTS = 1
         THEN
            DBMS_LOB.CREATETEMPORARY (V_DSTN_FILE, TRUE, DBMS_LOB.SESSION);
            DBMS_LOB.FILEOPEN (V_SRC_FILE, DBMS_LOB.FILE_READONLY);
            DBMS_LOB.LOADFROMFILE (V_DSTN_FILE,
                                   V_SRC_FILE,
                                    V_AMT ,
                                   1,
                                   1);
            COMMIT;
            DBMS_LOB.FILECLOSE (V_SRC_FILE);

            INSERT INTO APPS.PER_IMAGES (IMAGE_ID,
                                         PARENT_ID,
                                         TABLE_NAME,
                                         IMAGE)
                 VALUES (PER_IMAGES_S.NEXTVAL,
                         I.PERSON_ID,
                         'PER_PEOPLE_F',
                         V_DSTN_FILE);
         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line (
               'Unable to upload image for the employee code : '
               || I.employee_number);
      END;
   END LOOP;

   COMMIT;
END;
/
/*
			BY : Custommized by atia  2018 
			API Name : Oracle HRMS  Contract API
			Version :1.0.0
**/
CREATE OR REPLACE PROCEDURE APPS.XX_CREATE_CONTRACT
IS
   CURSOR C_CONTRACT
   IS
      SELECT ppa.person_id,
             xpu.employee_code,
             ORIGINAL_DATE_OF_HIRE EFFECTIVE_DATE,
             CONTRACT,
             DECODE (CONTRACT,
                     'Unlimited', 'Unlimited',
                     'Limited', 'Limited')
                REFERENCE,
             DECODE (CONTRACT,
                     'Unlimited', 'UNLIMITED_CONTRACT',
                     'Limited', 'FIXED_CONTRACT')
                TYPE,
             'A-ACTIVE' status,
             NULL upload_status
        FROM per_all_people_f ppa, 
        XX_ALL_CONTRACT_UPLOAD xpu
       WHERE  xpu.employee_code = ppa.employee_number
             AND SYSDATE BETWEEN TO_CHAR (ppa.EFFECTIVE_START_DATE,
                                          'DD-MON-YYYY')
                             AND TO_CHAR (ppa.EFFECTIVE_END_DATE,
                                          'DD-MON-YYYY')  
                                       and nvl(xpu.status,'N') <>  'Y'  and xpu.contract is not null ;

   --                       and employee_code = 20986;

   LC_C_CONTRACT             C_CONTRACT%ROWTYPE;
   L_CONTRACT_ID             NUMBER;
   L_EFFECTIVE_START_DATE    DATE;
   L_EFFECTIVE_END_DATE      DATE;
   L_OBJECT_VERSION_NUMBER   NUMBER;
   ERROR_DESC                VARCHAR2 (240);
   LV_CONTRACT_FLAG          CHAR (1);
   L_SEQ                     VARCHAR2 (20);
BEGIN

fnd_global.apps_initialize (0, 50597, 800);    


   OPEN C_CONTRACT;

   LOOP
      FETCH C_CONTRACT INTO LC_C_CONTRACT;

      EXIT WHEN C_CONTRACT%NOTFOUND;

      BEGIN
         HR_CONTRACT_API.CREATE_CONTRACT (
            P_VALIDATE                => FALSE,
            P_EFFECTIVE_DATE          => LC_C_CONTRACT.EFFECTIVE_DATE,
            P_PERSON_ID               => LC_C_CONTRACT.PERSON_ID,
            P_REFERENCE               => LC_C_CONTRACT.REFERENCE,
            P_TYPE                    => LC_C_CONTRACT.TYPE,
            P_STATUS                  => LC_C_CONTRACT.STATUS,
            --                           P_DURATION                   => LC_C_CONTRACT.DURATION,
            --                           P_DURATION_UNITS             => LC_C_CONTRACT.DURATION_UNITS,
            P_CONTRACT_ID             => L_CONTRACT_ID,
            P_EFFECTIVE_START_DATE    => L_EFFECTIVE_START_DATE,
            P_EFFECTIVE_END_DATE      => L_EFFECTIVE_END_DATE,
            P_OBJECT_VERSION_NUMBER   => L_OBJECT_VERSION_NUMBER);

         IF L_CONTRACT_ID IS NOT NULL
         THEN
            LV_CONTRACT_FLAG := 'Y';
            ERROR_DESC := 'NO ERROR';

            UPDATE XX_ALL_CONTRACT_UPLOAD
               SET STATUS = 'Y'
             WHERE employee_code = LC_C_CONTRACT.employee_code;
             
             else
              UPDATE XX_ALL_CONTRACT_UPLOAD
               SET STATUS = 'N'
             WHERE employee_code = LC_C_CONTRACT.employee_code;
             
         END IF;

         --
         --         IF LV_CONTRACT_FLAG = 'Y'
         --         THEN
         --            UPDATE DEV_CONTRACT
         --               SET JOB_ERROR_DESCRIPTION = ERROR_DESC,
         --                   JOB_PROCESS_FLAG = LV_CONTRACT_FLAG,
         --                   JOB_ID = L_CONTRACT_ID,
         --                   JOB_OBJ_VER_NUMBER = L_OBJECT_VERSION_NUMBER
         --             WHERE LINE_ID = LC_C_CONTRACT.LINE_ID;
         --         ELSE
         --            ERROR_DESC := ERROR_DESC || SQLERRM;
         --
         --            UPDATE DEV_CONTRACT
         --               SET JOB_ERROR_DESCRIPTION = ERROR_DESC,
         --                   JOB_PROCESS_FLAG = 'N'
         --             WHERE LINE_ID = LC_C_CONTRACT.LINE_ID;
         --         END IF;

         DBMS_OUTPUT.PUT_LINE ('CONTRACT ID    : ' || L_CONTRACT_ID);
      EXCEPTION
         WHEN OTHERS
         THEN
            LV_CONTRACT_FLAG := 'N';
            ERROR_DESC := ERROR_DESC || SQLERRM;

            --            UPDATE DEV_CONTRACT
            --               SET JOB_ERROR_DESCRIPTION = ERROR_DESC,
            --                   JOB_PROCESS_FLAG = LV_CONTRACT_FLAG
            --             WHERE LINE_ID = LC_C_CONTRACT.LINE_ID;

            DBMS_OUTPUT.PUT_LINE (SQLERRM);
      END;

      L_CONTRACT_ID := '';
      L_OBJECT_VERSION_NUMBER := '';
      L_EFFECTIVE_START_DATE := '';
      L_EFFECTIVE_END_DATE := '';
      ERROR_DESC := '';
      LV_CONTRACT_FLAG := '';
   --COMMIT;
   END LOOP;



   CLOSE C_CONTRACT;

   COMMIT;
--DBMS_OUTPUT.PUT_LINE('LOCATION ID        : '||L_LOCATION_ID);
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM);
END;
/

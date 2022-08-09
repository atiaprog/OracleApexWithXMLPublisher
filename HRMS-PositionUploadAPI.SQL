/*
			BY : Customized by atia  2018 
			API Name : Oracle HRMS  Position API 
			Version : 1.0.0
**/
CREATE OR REPLACE PROCEDURE APPS.XX_POSITION_LINK_UPLOAD
AS
   L_BUSINESS_GROUP_ID            NUMBER := 81;

   /* Local Variables */
   L_POSITION_NAME                VARCHAR2 (100);
   L_POSITION_ID                  NUMBER;
   L_STATUS                       VARCHAR2 (5) := 'True';
   L_JOB_ID                       PER_JOBS.JOB_ID%TYPE;
   L_SEGMENT2                     VARCHAR2 (200);
   L_ORGANIZATION_ID              HR_ORGANIZATION_UNITS.ORGANIZATION_ID%TYPE;
   L_ERROR_MESSAGE                VARCHAR2 (1000);
   L_VALIDATE_CNT                 NUMBER;

   /* Out Variables */
   L_EFFECTIVE_START_DATE         DATE;
   L_EFFECTIVE_END_DATE           DATE;
   OUT_P_POSITION_ID              NUMBER;
   OUT_P_OBJECT_VERSION_NUMBER    NUMBER;
   OUT_P_POSITION_DEFINITION_ID   NUMBER;
   OUT_P_NAME                     VARCHAR2 (250);

   L_TOTAL_RECORDS                NUMBER := 0;
   L_SUCCESS_RECORDS              NUMBER := 0;
   L_FAILURE_RECORDS              NUMBER := 0;

   CURSOR C1
   IS
        SELECT ROWID ROWIDS,
               TRIM (POSITION_NAME) POSITION_NAME,
               (SELECT PJ.JOB_ID
                  FROM PER_JOBS PJ
                 WHERE 1 = 1 AND PJ.NAME =TRIM ( A.JOB_NAME))
                  JOB_ID,
               JOB_NAME,
               (SELECT ORGANIZATION_ID
                  FROM HR_ORGANIZATION_UNITS
                 WHERE 1 = 1 AND UPPER (NAME) = UPPER (TRIM (A.DEPARTMENT_NAME)))
                  ORG_ID,
               DEPARTMENT_NAME
          FROM XX_POSITON_UPLOAD A
         WHERE 1 = 1
               AND NOT EXISTS
                          (SELECT *
                             FROM PER_POSITIONS PP,
                                  PER_POSITION_DEFINITIONS PPD
                            WHERE 1 = 1
                                  --pp.business_group_id = l_business_group_id
                                  AND PP.POSITION_DEFINITION_ID =
                                         PPD.POSITION_DEFINITION_ID
                                  AND NAME = TRIM (A.POSITION_NAME))
      ORDER BY POSITION_NAME;
BEGIN

   fnd_global.apps_initialize (0, 50637, 800);        -- 0 sysadmin user id

   FOR C1_REC1 IN C1
   LOOP
      OUT_P_POSITION_ID := NULL;
      OUT_P_OBJECT_VERSION_NUMBER := NULL;
      OUT_P_POSITION_DEFINITION_ID := NULL;
      OUT_P_NAME := NULL;
      L_EFFECTIVE_START_DATE := NULL;
      L_EFFECTIVE_END_DATE := NULL;

      HR_POSITION_API.CREATE_POSITION (
         P_EFFECTIVE_DATE           => '01-JAN-1990',
         P_JOB_ID                   => C1_REC1.JOB_ID,
         P_ORGANIZATION_ID          => C1_REC1.ORG_ID,
         P_DATE_EFFECTIVE           => '01-JAN-1990',
         P_SEGMENT1                 => C1_REC1.POSITION_NAME --,p_segment2 => c1_rec1.job_title
                                                            ,
         P_FTE                      => NULL,
         P_MAX_PERSONS              => NULL,
         P_POSITION_ID              => OUT_P_POSITION_ID,
         P_OBJECT_VERSION_NUMBER    => OUT_P_OBJECT_VERSION_NUMBER,
         P_POSITION_DEFINITION_ID   => OUT_P_POSITION_DEFINITION_ID,
         P_NAME                     => OUT_P_NAME,
         P_EFFECTIVE_START_DATE     => L_EFFECTIVE_START_DATE,
         P_EFFECTIVE_END_DATE       => L_EFFECTIVE_END_DATE);


      UPDATE XX_POSITON_UPLOAD
         SET STATUS = 'SUCCESS'
       WHERE ROWID = C1_REC1.ROWIDS;

      UPDATE XX_POSITON_UPLOAD
         SET POSITION_ID = OUT_P_POSITION_ID
       WHERE ROWID = C1_REC1.ROWIDS;

      UPDATE XX_POSITON_UPLOAD
         SET P_OBJECT_VERSION_NUMBER = OUT_P_OBJECT_VERSION_NUMBER
       WHERE ROWID = C1_REC1.ROWIDS;

      UPDATE XX_POSITON_UPLOAD
         SET P_POSITION_DEFINITION_ID = OUT_P_POSITION_DEFINITION_ID
       WHERE ROWID = C1_REC1.ROWIDS;

      UPDATE XX_POSITON_UPLOAD
         SET P_NAME = OUT_P_NAME
       WHERE ROWID = C1_REC1.ROWIDS;

      COMMIT;

      DBMS_OUTPUT.PUT_LINE (
         'End Time : ' || TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
      DBMS_OUTPUT.PUT_LINE (
         '#############################################################');
      DBMS_OUTPUT.PUT_LINE (' out_p_position_id : ' || OUT_P_POSITION_ID);
      DBMS_OUTPUT.PUT_LINE ('out_p_name : ' || OUT_P_NAME);
      DBMS_OUTPUT.PUT_LINE (
         ' l_effective_start_date: ' || L_EFFECTIVE_START_DATE);
      DBMS_OUTPUT.PUT_LINE (
         '#############################################################');
   END LOOP;
END;
/
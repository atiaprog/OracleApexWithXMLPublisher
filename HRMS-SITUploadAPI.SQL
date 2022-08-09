/*
			BY : Customized by atia  2018 
			API Name : Oracle HRMS  Special Information Types (SIT)
			Version : 1.0.0
**/
CREATE OR REPLACE PACKAGE APPS.XX_HR_SIT_CREATION
AS
   PROCEDURE XX_SIT_CREATE_DRIVING;
   PROCEDURE XX_SIT_CREATE_Emirates_ID;
   PROCEDURE XX_SIT_CREATE_Health_Card;
   PROCEDURE XX_SIT_CREATE_Labour_Card;
   PROCEDURE XX_SIT_CREATE_Labour_Contract;
   PROCEDURE XX_SIT_CREATE_VISA;
   PROCEDURE XX_SIT_CREATE_PASSPORT;
   PROCEDURE XX_HR_SIT_CREATION_FINAL;
END XX_HR_SIT_CREATION;
/

CREATE OR REPLACE PACKAGE BODY APPS.xx_hr_sit_creation
IS
   PROCEDURE xx_sit_create_driving
   IS
      x_analysis_criteria_id        NUMBER;
      x_person_analysis_id          NUMBER;
      x_pea_object_version_number   NUMBER;

      x_p_person_id                 NUMBER;
      x_p_business_group_id         NUMBER;
      x_p_id_flex_num               VARCHAR2 (100);
      x_p_effective_date            DATE;

      v_error_exists                VARCHAR2 (2000);
      v_error_message               VARCHAR2 (2000);

      CURSOR c1
      IS
         SELECT employee_code,
                trim(driving_license_number)  driving_license_number,
                trim(driving_place_of_issue)   driving_place_of_issue,
                TO_DATE (driving_issue_date, 'MM/DD/YYYY') driving_issue_date,
                TO_DATE (driving_expiry_date, 'MM/DD/YYYY')
                   driving_expiry_date,
                trim(driving_license_category)  driving_license_category,
                trim(driving_license_type)  driving_license_type
           FROM xx_hrms_sit_upload
          WHERE driving_license_number IS NOT NULL  and  employee_code <> '00129';
   BEGIN
      fnd_global.apps_initialize (0, 50637, 800);        -- 0 sysadmin user id

      FOR i IN c1
      LOOP
         BEGIN
            x_analysis_criteria_id := NULL;
            x_person_analysis_id := NULL;
            x_pea_object_version_number := NULL;

            SELECT person_id, business_group_id, effective_start_date
              INTO x_p_person_id, x_p_business_group_id, x_p_effective_date
              FROM per_all_people_f
             WHERE employee_number = i.employee_code;

            SELECT                  --APPLICATION_COLUMN_NAME , SEGMENT_NAME ,
                  DISTINCT a.id_flex_num
              INTO x_p_id_flex_num
              FROM fnd_id_flex_segments_vl a, fnd_id_flex_structures_vl b
             WHERE     a.id_flex_num = b.id_flex_num
                   AND (a.id_flex_code = 'PEA')
                   AND (a.application_id = 800)
                   AND b.id_flex_structure_name = 'Driving License';

            hr_sit_api.create_sit (
               p_validate                    => NULL,
               p_person_id                   => x_p_person_id,
               p_business_group_id           => x_p_business_group_id,
               p_id_flex_num                 => x_p_id_flex_num,
               p_effective_date              => x_p_effective_date,
               p_date_from                   => SYSDATE,
               p_segment1                    => i.driving_license_number,
               p_segment2                    => i.driving_place_of_issue,
               p_segment3                    => TO_CHAR (i.driving_issue_date,
                                                         'YYYY/MM/DD'),
               p_segment4                    => TO_CHAR (i.driving_expiry_date,
                                                         'YYYY/MM/DD'),
               p_segment5                    => i.driving_license_category,
               p_segment6                    => i.driving_license_type,
               p_analysis_criteria_id        => x_analysis_criteria_id,
               p_person_analysis_id          => x_person_analysis_id,
               p_pea_object_version_number   => x_pea_object_version_number);


            UPDATE xx_hrms_sit_upload a
               SET driving_license_type_error =
                         'Analysis Criteria :  '
                      || x_analysis_criteria_id
                      || '   Person Analysis :  '
                      || x_person_analysis_id
             WHERE a.employee_code = i.employee_code;
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line (
                  'Diving licence is not available for the employee :  '
                  || i.employee_code);

               v_error_message :=
                  'Error Occured during Creation of Person SIT the Employee  : '
                  || '  Error : '
                  || SQLERRM;

               DBMS_OUTPUT.put_line (v_error_message);
         END;



         COMMIT;
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         v_error_exists := 'A';
         v_error_message :=
               'Error Occured during Creation of Person SIT the Employee  : '
            || '  Error : '
            || SQLERRM;
   END;


   PROCEDURE xx_sit_create_emirates_id
   IS
      x_analysis_criteria_id        VARCHAR2 (100);
      x_person_analysis_id          VARCHAR2 (100);
      x_pea_object_version_number   VARCHAR2 (100);

      x_p_person_id                 VARCHAR2 (100);
      x_p_business_group_id         VARCHAR2 (100);
      x_p_id_flex_num               VARCHAR2 (100);
      x_p_effective_date            DATE;

      v_error_exists                VARCHAR2 (2000);
      v_error_message               VARCHAR2 (2000);

      CURSOR c1
      IS
         SELECT ROWID rowids,
                trim(employee_code)  employee_code,
                trim(emirates_id_number)  emirates_id_number,
                TO_DATE (emirates_id_expiry_date, 'MM/DD/YYYY')
                   emirates_id_expiry_date
           FROM xx_hrms_sit_upload
          WHERE 1 = 1 AND emirates_id_number IS NOT NULL   and  employee_code <> '00129';
   BEGIN
      fnd_global.apps_initialize (0, 50637, 800);        -- 0 sysadmin user id

      FOR i IN c1
      LOOP
         BEGIN
            x_analysis_criteria_id := NULL;
            x_person_analysis_id := NULL;
            x_pea_object_version_number := NULL;



            SELECT person_id, business_group_id, effective_start_date
              INTO x_p_person_id, x_p_business_group_id, x_p_effective_date
              FROM per_all_people_f
             WHERE employee_number = i.employee_code;



            SELECT                  --APPLICATION_COLUMN_NAME , SEGMENT_NAME ,
                  DISTINCT a.id_flex_num
              INTO x_p_id_flex_num
              FROM fnd_id_flex_segments_vl a, fnd_id_flex_structures_vl b
             WHERE     a.id_flex_num = b.id_flex_num
                   AND (a.id_flex_code = 'PEA')
                   AND (a.application_id = 800)
                   AND b.id_flex_structure_name = 'Emirates ID';



            hr_sit_api.create_sit (
               p_validate                    => NULL,
               p_person_id                   => x_p_person_id,
               p_business_group_id           => x_p_business_group_id,
               p_id_flex_num                 => x_p_id_flex_num,
               p_effective_date              => SYSDATE,
               p_date_from                   => SYSDATE,
               p_segment1                    => i.emirates_id_number,
               p_segment2                    => TO_CHAR (i.emirates_id_expiry_date,
                                                         'YYYY/MM/DD'),
               p_analysis_criteria_id        => x_analysis_criteria_id,
               p_person_analysis_id          => x_person_analysis_id,
               p_pea_object_version_number   => x_pea_object_version_number);

            UPDATE xx_hrms_sit_upload a
               SET emirates_id_expiry_date_error =
                         'Analysis Criteria :  '
                      || x_analysis_criteria_id
                      || '   Person Analysis :  '
                      || x_person_analysis_id
             WHERE a.employee_code = i.employee_code;

            DBMS_OUTPUT.put_line (
               '  x_analysis_criteria_id' || x_analysis_criteria_id);
            DBMS_OUTPUT.put_line (
               ' x_person_analysis_id' || x_person_analysis_id);
            DBMS_OUTPUT.put_line (
               'x_pea_object_version_number' || x_pea_object_version_number);
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line (
                  'Emrites id is not available for the employee :  '
                  || i.employee_code);

               v_error_message :=
                  'Error Occured during Creation of Person SIT the Employee  : '
                  || '  Error : '
                  || SQLERRM;

               DBMS_OUTPUT.put_line (v_error_message);
         END;


         COMMIT;
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         v_error_exists := 'A';
         v_error_message :=
               'Error Occured during Creation of Person SIT the Employee  : '
            || '  Error : '
            || SQLERRM;

         DBMS_OUTPUT.put_line ('v_error_exists' || v_error_exists);
         DBMS_OUTPUT.put_line (' v_error_message' || v_error_message);
   END;

   PROCEDURE xx_sit_create_health_card
   AS
      x_analysis_criteria_id        VARCHAR2 (100);
      x_person_analysis_id          VARCHAR2 (100);
      x_pea_object_version_number   VARCHAR2 (100);

      x_p_person_id                 VARCHAR2 (100);
      x_p_business_group_id         VARCHAR2 (100);
      x_p_id_flex_num               VARCHAR2 (100);
      x_p_effective_date            DATE;

      v_error_exists                VARCHAR2 (2000);
      v_error_message               VARCHAR2 (2000);

      CURSOR c1
      IS
         SELECT employee_code,
                trim(health_card_number)  health_card_number,
                trim(health_place_of_issue)  health_place_of_issue,
                TO_DATE (health_issue_date, 'MM/DD/YYYY') health_issue_date,
                TO_DATE (health_expiry_date, 'MM/DD/YYYY') health_expiry_date
           FROM xx_hrms_sit_upload
          WHERE 1 = 1 AND health_card_number IS NOT NULL   and  employee_code <> '00129';
   BEGIN
      fnd_global.apps_initialize (0, 50637, 800);        -- 0 sysadmin user id

      FOR i IN c1
      LOOP
         BEGIN
            x_analysis_criteria_id := NULL;
            x_person_analysis_id := NULL;
            x_pea_object_version_number := NULL;

            DBMS_OUTPUT.put_line ('  1' || x_analysis_criteria_id);

            SELECT person_id, business_group_id, effective_start_date
              INTO x_p_person_id, x_p_business_group_id, x_p_effective_date
              FROM per_all_people_f
             WHERE employee_number = i.employee_code;

            DBMS_OUTPUT.put_line ('  2' || x_analysis_criteria_id);

            SELECT                  --APPLICATION_COLUMN_NAME , SEGMENT_NAME ,
                  DISTINCT a.id_flex_num
              INTO x_p_id_flex_num
              FROM fnd_id_flex_segments_vl a, fnd_id_flex_structures_vl b
             WHERE     a.id_flex_num = b.id_flex_num
                   AND (a.id_flex_code = 'PEA')
                   AND (a.application_id = 800)
                   AND b.id_flex_structure_name = 'Health Card';

            DBMS_OUTPUT.put_line ('  3' || x_analysis_criteria_id);

            hr_sit_api.create_sit (
               p_validate                    => NULL,
               p_person_id                   => x_p_person_id,
               p_business_group_id           => x_p_business_group_id,
               p_id_flex_num                 => x_p_id_flex_num,
               p_effective_date              => SYSDATE,
               p_date_from                   => SYSDATE,
               p_segment1                    => i.health_card_number,
               p_segment2                    => i.health_place_of_issue,
               p_segment3                    => TO_CHAR (i.health_issue_date,
                                                         'YYYY/MM/DD'),
               p_segment4                    => TO_CHAR (i.health_expiry_date,
                                                         'YYYY/MM/DD'),
               p_analysis_criteria_id        => x_analysis_criteria_id,
               p_person_analysis_id          => x_person_analysis_id,
               p_pea_object_version_number   => x_pea_object_version_number);

            DBMS_OUTPUT.put_line (
               '  x_analysis_criteria_id' || x_analysis_criteria_id);
            DBMS_OUTPUT.put_line (
               ' x_person_analysis_id' || x_person_analysis_id);
            DBMS_OUTPUT.put_line (
               'x_pea_object_version_number' || x_pea_object_version_number);

            UPDATE xx_hrms_sit_upload a
               SET health_card_number_error =
                         'Analysis Criteria :  '
                      || x_analysis_criteria_id
                      || '   Person Analysis :  '
                      || x_person_analysis_id
             WHERE a.employee_code = i.employee_code;


            COMMIT;
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line (
                  'Health Card is not available for the employee :  '
                  || i.employee_code);

               v_error_message :=
                  'Error Occured during Creation of Person SIT the Employee  : '
                  || '  Error : '
                  || SQLERRM;

               DBMS_OUTPUT.put_line (v_error_message);
         END;
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         v_error_exists := 'A';
         v_error_message :=
               'Error Occured during Creation of Person SIT the Employee  : '
            || '  Error : '
            || SQLERRM;

         DBMS_OUTPUT.put_line ('v_error_exists' || v_error_exists);
         DBMS_OUTPUT.put_line (' v_error_message' || v_error_message);
   END;

   PROCEDURE xx_sit_create_labour_card
   AS
      x_analysis_criteria_id        VARCHAR2 (100);
      x_person_analysis_id          VARCHAR2 (100);
      x_pea_object_version_number   VARCHAR2 (100);

      x_p_person_id                 VARCHAR2 (100);
      x_p_business_group_id         VARCHAR2 (100);
      x_p_id_flex_num               VARCHAR2 (100);
      x_p_effective_date            DATE;

      v_error_exists                VARCHAR2 (2000);
      v_error_message               VARCHAR2 (2000);

      CURSOR c1
      IS
         SELECT employee_code,
                trim(labor_card_number) labor_card_number,
                trim(labor_card_pin_number)  labor_card_pin_number,
                trim(labor_card_place_of_issue)  labor_card_place_of_issue,
                TO_DATE (labor_card_issue_date, 'MM/DD/YYYY')
                   labor_card_issue_date,
                TO_DATE (labor_card_expiry_date, 'MM/DD/YYYY')
                   labor_card_expiry_date,
                trim(labor_card_document_holder)  labor_card_document_holder,
                trim(labor_contract_document_number)  labor_contract_document_number,
                trim(labor_other_description)  labor_other_description
           FROM xx_hrms_sit_upload
          WHERE 1 = 1 AND labor_card_number IS NOT NULL   and  employee_code <> '00129'; --and  employee_code = '00168';
   BEGIN
      fnd_global.apps_initialize (0, 50637, 800);        -- 0 sysadmin user id

      FOR i IN c1
      LOOP
         BEGIN
            x_analysis_criteria_id := NULL;
            x_person_analysis_id := NULL;
            x_pea_object_version_number := NULL;

            DBMS_OUTPUT.put_line ('  1' || x_analysis_criteria_id);

            SELECT person_id, business_group_id, effective_start_date
              INTO x_p_person_id, x_p_business_group_id, x_p_effective_date
              FROM per_all_people_f
             WHERE employee_number = i.employee_code;

            DBMS_OUTPUT.put_line ('  2' || x_analysis_criteria_id);

            SELECT                  --APPLICATION_COLUMN_NAME , SEGMENT_NAME ,
                  DISTINCT a.id_flex_num
              INTO x_p_id_flex_num
              FROM fnd_id_flex_segments_vl a, fnd_id_flex_structures_vl b
             WHERE     a.id_flex_num = b.id_flex_num
                   AND (a.id_flex_code = 'PEA')
                   AND (a.application_id = 800)
                   AND b.id_flex_structure_name = 'Labour Card';

            DBMS_OUTPUT.put_line ('  3' || x_analysis_criteria_id);

            hr_sit_api.create_sit (
               p_validate                    => NULL,
               p_person_id                   => x_p_person_id,
               p_business_group_id           => x_p_business_group_id,
               p_id_flex_num                 => x_p_id_flex_num,
               p_effective_date              => SYSDATE,
               p_date_from                   => SYSDATE,
               p_segment1                    => i.labor_card_number,
               p_segment2                    => i.labor_card_pin_number,
               p_segment3                    => i.labor_card_place_of_issue,
               p_segment4                    => TO_CHAR (i.labor_card_issue_date,
                                                         'YYYY/MM/DD'),
               p_segment5                    => TO_CHAR (i.labor_card_expiry_date,
                                                         'YYYY/MM/DD'),
               p_segment6                    => i.labor_card_document_holder,
               p_segment7                    => i.labor_other_description,
               p_analysis_criteria_id        => x_analysis_criteria_id,
               p_person_analysis_id          => x_person_analysis_id,
               p_pea_object_version_number   => x_pea_object_version_number);

            DBMS_OUTPUT.put_line (
               '  x_analysis_criteria_id' || x_analysis_criteria_id);
            DBMS_OUTPUT.put_line (
               ' x_person_analysis_id' || x_person_analysis_id);
            DBMS_OUTPUT.put_line (
               'x_pea_object_version_number' || x_pea_object_version_number);

            UPDATE xx_hrms_sit_upload a
               SET labor_card_number_error =
                         'Analysis Criteria :  '
                      || x_analysis_criteria_id
                      || '   Person Analysis :  '
                      || x_person_analysis_id
             WHERE a.employee_code = i.employee_code;


            COMMIT;
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line (
                  'Lebor Card is not available for the employee :  '
                  || i.employee_code);

               v_error_message :=
                  'Error Occured during Creation of Person SIT the Employee  : '
                  || '  Error : '
                  || SQLERRM;

               DBMS_OUTPUT.put_line (v_error_message);
         END;
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         v_error_exists := 'A';
         v_error_message :=
               'Error Occured during Creation of Person SIT the Employee  : '
            || '  Error : '
            || SQLERRM;

         DBMS_OUTPUT.put_line ('v_error_exists' || v_error_exists);
         DBMS_OUTPUT.put_line (' v_error_message' || v_error_message);
   END;

   PROCEDURE xx_sit_create_labour_contract
   AS
      x_analysis_criteria_id        VARCHAR2 (100);
      x_person_analysis_id          VARCHAR2 (100);
      x_pea_object_version_number   VARCHAR2 (100);

      x_p_person_id                 VARCHAR2 (100);
      x_p_business_group_id         VARCHAR2 (100);
      x_p_id_flex_num               VARCHAR2 (100);
      x_p_effective_date            DATE;

      v_error_exists                VARCHAR2 (2000);
      v_error_message               VARCHAR2 (2000);

      CURSOR c1
      IS
         SELECT employee_code,
                trim(labor_contract_document_number)  labor_contract_document_number,
                TO_DATE (labor_contract__issue_date, 'MM/DD/YYYY')
                   labor_contract__issue_date,
                TO_DATE (labor_contract__expiry_date, 'MM/DD/YYYY')
                   labor_contract__expiry_date
           FROM xx_hrms_sit_upload
          WHERE 1 = 1 AND labor_contract_document_number IS NOT NULL  and  employee_code <> '00129';
   BEGIN
      fnd_global.apps_initialize (0, 50637, 800);        -- 0 sysadmin user id

      FOR i IN c1
      LOOP
         BEGIN
            x_analysis_criteria_id := NULL;
            x_person_analysis_id := NULL;
            x_pea_object_version_number := NULL;

            DBMS_OUTPUT.put_line ('  1' || x_analysis_criteria_id);

            SELECT person_id, business_group_id, effective_start_date
              INTO x_p_person_id, x_p_business_group_id, x_p_effective_date
              FROM per_all_people_f
             WHERE employee_number = i.employee_code;

            DBMS_OUTPUT.put_line ('  2' || x_analysis_criteria_id);

            SELECT                  --APPLICATION_COLUMN_NAME , SEGMENT_NAME ,
                  DISTINCT a.id_flex_num
              INTO x_p_id_flex_num
              FROM fnd_id_flex_segments_vl a, fnd_id_flex_structures_vl b
             WHERE     a.id_flex_num = b.id_flex_num
                   AND (a.id_flex_code = 'PEA')
                   AND (a.application_id = 800)
                   AND b.id_flex_structure_name = 'Labour Contract';

            DBMS_OUTPUT.put_line ('  3' || x_analysis_criteria_id);

            hr_sit_api.create_sit (
               p_validate                    => NULL,
               p_person_id                   => x_p_person_id,
               p_business_group_id           => x_p_business_group_id,
               p_id_flex_num                 => x_p_id_flex_num,
               p_effective_date              => SYSDATE,
               p_date_from                   => SYSDATE,
               p_segment1                    => i.labor_contract_document_number,
               p_segment2                    => TO_CHAR (i.labor_contract__issue_date,
                                                         'YYYY/MM/DD'),
               p_segment3                    => TO_CHAR (
                                                  i.labor_contract__expiry_date,
                                                  'YYYY/MM/DD'),
               p_analysis_criteria_id        => x_analysis_criteria_id,
               p_person_analysis_id          => x_person_analysis_id,
               p_pea_object_version_number   => x_pea_object_version_number);

            DBMS_OUTPUT.put_line (
               '  x_analysis_criteria_id' || x_analysis_criteria_id);
            DBMS_OUTPUT.put_line (
               ' x_person_analysis_id' || x_person_analysis_id);
            DBMS_OUTPUT.put_line (
               'x_pea_object_version_number' || x_pea_object_version_number);

            UPDATE xx_hrms_sit_upload a
               SET labor_contract_number_error =
                         'Analysis Criteria :  '
                      || x_analysis_criteria_id
                      || '   Person Analysis :  '
                      || x_person_analysis_id
             WHERE a.employee_code = i.employee_code;


            COMMIT;
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line (
                  'Labor Contract is not available for the employee :  '
                  || i.employee_code);

               v_error_message :=
                  'Error Occured during Creation of Person SIT the Employee  : '
                  || '  Error : '
                  || SQLERRM;

               DBMS_OUTPUT.put_line (v_error_message);
         END;
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         v_error_exists := 'A';
         v_error_message :=
               'Error Occured during Creation of Person SIT the Employee  : '
            || '  Error : '
            || SQLERRM;

         DBMS_OUTPUT.put_line ('v_error_exists' || v_error_exists);
         DBMS_OUTPUT.put_line (' v_error_message' || v_error_message);
   END;

   PROCEDURE xx_sit_create_visa
   AS
      x_analysis_criteria_id        VARCHAR2 (100);
      x_person_analysis_id          VARCHAR2 (100);
      x_pea_object_version_number   VARCHAR2 (100);

      x_p_person_id                 VARCHAR2 (100);
      x_p_business_group_id         VARCHAR2 (100);
      x_p_id_flex_num               VARCHAR2 (100);
      x_p_effective_date            DATE;

      v_error_exists                VARCHAR2 (2000);
      v_error_message               VARCHAR2 (2000);

      CURSOR c1
      IS
         SELECT employee_code,
                trim(visa_number) visa_number,
               trim( visa_place_of_issue)  visa_place_of_issue,
                TO_DATE (visa_issue_date, 'MM/DD/YYYY') visa_issue_date,
                TO_DATE (visa_expiry_date, 'MM/DD/YYYY') visa_expiry_date
           FROM xx_hrms_sit_upload
          WHERE 1 = 1 AND visa_number IS NOT NULL  and  employee_code <> '00129';
   BEGIN
      fnd_global.apps_initialize (0, 50637, 800);        -- 0 sysadmin user id


      FOR i IN c1
      LOOP
         BEGIN
            x_analysis_criteria_id := NULL;
            x_person_analysis_id := NULL;
            x_pea_object_version_number := NULL;

            DBMS_OUTPUT.put_line ('  1' || x_analysis_criteria_id);

            SELECT person_id, business_group_id, effective_start_date
              INTO x_p_person_id, x_p_business_group_id, x_p_effective_date
              FROM per_all_people_f
             WHERE employee_number = i.employee_code;

            DBMS_OUTPUT.put_line ('  2' || x_analysis_criteria_id);

            SELECT                  --APPLICATION_COLUMN_NAME , SEGMENT_NAME ,
                  DISTINCT a.id_flex_num
              INTO x_p_id_flex_num
              FROM fnd_id_flex_segments_vl a, fnd_id_flex_structures_vl b
             WHERE     a.id_flex_num = b.id_flex_num
                   AND (a.id_flex_code = 'PEA')
                   AND (a.application_id = 800)
                   AND b.id_flex_structure_name = 'Visa';

            DBMS_OUTPUT.put_line ('  3' || x_analysis_criteria_id);

            hr_sit_api.create_sit (
               p_validate                    => NULL,
               p_person_id                   => x_p_person_id,
               p_business_group_id           => x_p_business_group_id,
               p_id_flex_num                 => x_p_id_flex_num,
               p_effective_date              => SYSDATE,
               p_date_from                   => SYSDATE,
               p_segment1                    => i.visa_number,
               p_segment2                    => i.visa_place_of_issue,
               p_segment3                    => TO_CHAR (i.visa_issue_date,
                                                         'YYYY/MM/DD'),
               p_segment4                    => TO_CHAR (i.visa_expiry_date,
                                                         'YYYY/MM/DD'),
               p_analysis_criteria_id        => x_analysis_criteria_id,
               p_person_analysis_id          => x_person_analysis_id,
               p_pea_object_version_number   => x_pea_object_version_number);

            DBMS_OUTPUT.put_line (
               '  x_analysis_criteria_id' || x_analysis_criteria_id);
            DBMS_OUTPUT.put_line (
               ' x_person_analysis_id' || x_person_analysis_id);
            DBMS_OUTPUT.put_line (
               'x_pea_object_version_number' || x_pea_object_version_number);

            UPDATE xx_hrms_sit_upload a
               SET visa_number_error =
                         'Analysis Criteria :  '
                      || x_analysis_criteria_id
                      || '   Person Analysis :  '
                      || x_person_analysis_id
             WHERE a.employee_code = i.employee_code;


            COMMIT;
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line (
                  'Visa Number is not available for the employee :  '
                  || i.employee_code);

               v_error_message :=
                  'Error Occured during Creation of Person SIT the Employee  : '
                  || '  Error : '
                  || SQLERRM;

               DBMS_OUTPUT.put_line (v_error_message);
         END;
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         v_error_exists := 'A';
         v_error_message :=
               'Error Occured during Creation of Person SIT the Employee  : '
            || '  Error : '
            || SQLERRM;

         DBMS_OUTPUT.put_line ('v_error_exists' || v_error_exists);
         DBMS_OUTPUT.put_line (' v_error_message' || v_error_message);
   END;

   PROCEDURE xx_sit_create_passport
   AS
      x_analysis_criteria_id        VARCHAR2 (100);
      x_person_analysis_id          VARCHAR2 (100);
      x_pea_object_version_number   VARCHAR2 (100);

      x_p_person_id                 VARCHAR2 (100);
      x_p_business_group_id         VARCHAR2 (100);
      x_p_id_flex_num               VARCHAR2 (100);
      x_p_effective_date            DATE;

      v_error_exists                VARCHAR2 (2000);
      v_error_message               VARCHAR2 (2000);

      CURSOR c1
      IS
         SELECT employee_code,
                trim(passport_name_in_passport) passport_name_in_passport,
                trim(passport_number)  passport_number,
                TO_DATE (passport_issue_date, 'MM/DD/YYYY')
                   passport_issue_date,
                TO_DATE (passport_expiry_date, 'MM/DD/YYYY')
                   passport_expiry_date,
                trim(passport_place_of_issue)  passport_place_of_issue,
                trim(passport_family_member_count)  passport_family_member_count,
                trim(passport_family_mothers_name)  passport_family_mothers_name,
               trim(passport_document_holder)  passport_document_holder,
               trim(passport_other_description)  passport_other_description,
                TO_DATE (passport_releasing_date, 'MM/DD/YYYY')
                   passport_releasing_date,
                passport_required_for,
                TO_DATE (passport_return_date, 'MM/DD/YYYY')
                   passport_return_date,
                TO_DATE (passport_expected_return_date, 'MM/DD/YYYY')
                   passport_expected_return_date
           FROM xx_hrms_sit_upload
          WHERE 1 = 1 AND passport_number IS NOT NULL  and  employee_code <> '00129';
   BEGIN
      fnd_global.apps_initialize (0, 50637, 800);        -- 0 sysadmin user id

      FOR i IN c1
      LOOP
         BEGIN
            x_analysis_criteria_id := NULL;
            x_person_analysis_id := NULL;
            x_pea_object_version_number := NULL;

            DBMS_OUTPUT.put_line ('  1' || x_analysis_criteria_id);

            SELECT person_id, business_group_id, effective_start_date
              INTO x_p_person_id, x_p_business_group_id, x_p_effective_date
              FROM per_all_people_f
             WHERE employee_number = i.employee_code;

            DBMS_OUTPUT.put_line ('  2' || x_analysis_criteria_id);

            SELECT                  --APPLICATION_COLUMN_NAME , SEGMENT_NAME ,
                  DISTINCT a.id_flex_num
              INTO x_p_id_flex_num
              FROM fnd_id_flex_segments_vl a, fnd_id_flex_structures_vl b
             WHERE     a.id_flex_num = b.id_flex_num
                   AND (a.id_flex_code = 'PEA')
                   AND (a.application_id = 800)
                   AND b.id_flex_structure_name = 'Passport';

            DBMS_OUTPUT.put_line ('  3' || x_analysis_criteria_id);

            hr_sit_api.create_sit (
               p_validate                    => NULL,
               p_person_id                   => x_p_person_id,
               p_business_group_id           => x_p_business_group_id,
               p_id_flex_num                 => x_p_id_flex_num,
               p_effective_date              => SYSDATE,
               p_date_from                   => SYSDATE,
               p_segment1                    => i.passport_name_in_passport,
               p_segment2                    => i.passport_number,
               p_segment3                    => TO_CHAR (i.passport_issue_date,
                                                         'YYYY/MM/DD'),
               p_segment4                    => TO_CHAR (i.passport_expiry_date,
                                                         'YYYY/MM/DD'),
               p_segment5                    => i.passport_place_of_issue,
               p_segment6                    => i.passport_family_member_count,
               p_segment7                    => i.passport_family_mothers_name,
               p_segment8                    => i.passport_document_holder,
               p_segment9                    => i.passport_other_description,
               p_segment11                   => TO_CHAR (i.passport_releasing_date,
                                                         'YYYY/MM/DD'),
               p_segment12                   => i.passport_required_for,
               p_segment13                   => TO_CHAR (i.passport_return_date,
                                                         'YYYY/MM/DD'),
               p_segment14                   => TO_CHAR (
                                                  i.passport_expected_return_date,
                                                  'YYYY/MM/DD'),
               p_analysis_criteria_id        => x_analysis_criteria_id,
               p_person_analysis_id          => x_person_analysis_id,
               p_pea_object_version_number   => x_pea_object_version_number);

            DBMS_OUTPUT.put_line (
               '  x_analysis_criteria_id' || x_analysis_criteria_id);
            DBMS_OUTPUT.put_line (
               ' x_person_analysis_id' || x_person_analysis_id);
            DBMS_OUTPUT.put_line (
               'x_pea_object_version_number' || x_pea_object_version_number);

            UPDATE xx_hrms_sit_upload a
               SET passport_number_error =
                         'Analysis Criteria :  '
                      || x_analysis_criteria_id
                      || '   Person Analysis :  '
                      || x_person_analysis_id
             WHERE a.employee_code = i.employee_code;


            COMMIT;
         EXCEPTION
            WHEN OTHERS
            THEN
               DBMS_OUTPUT.put_line (
                  'Passport details is not available for the employee :  '
                  || i.employee_code);

               v_error_message :=
                  'Error Occured during Creation of Person SIT the Employee  : '
                  || '  Error : '
                  || SQLERRM;

               DBMS_OUTPUT.put_line (v_error_message);
         END;
      END LOOP;
   EXCEPTION
      WHEN OTHERS
      THEN
         v_error_exists := 'A';
         v_error_message :=
               'Error Occured during Creation of Person SIT the Employee  : '
            || '  Error : '
            || SQLERRM;

         DBMS_OUTPUT.put_line ('v_error_exists' || v_error_exists);
         DBMS_OUTPUT.put_line (' v_error_message' || v_error_message);
   END;

   PROCEDURE xx_hr_sit_creation_final
   AS
   BEGIN
      xx_sit_create_driving;
      xx_sit_create_emirates_id;
      --  XX_SIT_CREATE_Health_Card;
      xx_sit_create_labour_card;
      xx_sit_create_labour_contract;
      xx_sit_create_visa;
      xx_sit_create_passport;

      COMMIT;
   END;
END xx_hr_sit_creation;
/

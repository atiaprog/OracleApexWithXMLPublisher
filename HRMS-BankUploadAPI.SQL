/*
			BY : Customized by atia  2018 
			API Name : Oracle HRMS Bank  API 
			Version : 1.0.0
**/
CREATE OR REPLACE PROCEDURE APPS.xxproc_employee_bank_upload
IS
   --------------- In Parameters Payment Method----------

   v_business_group_id              NUMBER := 81;
   l_per_id                         NUMBER;
   l_obj                            NUMBER;
   method_id                        NUMBER;

   ---------------Out Parameters Payment Method----------

   v_p_personal_payment_method_id   NUMBER;
   v_p_external_account_id          NUMBER;
   v_p_object_version_number        NUMBER;
   v_p_effective_start_date         DATE;
   v_p_effective_end_date           DATE;
   v_p_comment_id                   NUMBER;

   -------------- Internal Parameter Payment Method---------

   invalid_data                     EXCEPTION;
   l_total_records                  NUMBER := 0;
   l_success_records                NUMBER := 0;
   l_failure_records                NUMBER := 0;
   error_msg                        VARCHAR2 (1000);

   ------FOR UPDATE Payment Method---------

   or_object_version_number         NUMBER;
   or_comment_id                    NUMBER;
   or_external_account_id           NUMBER;
   or_effective_start_date          DATE;
   or_effective_end_date            DATE;

   ------------------------------------


   CURSOR cur_pay
   IS
      SELECT assignment.assignment_id,
             assignment.effective_start_date,
             (SELECT ORG_PAYMENT_METHOD_ID
                FROM PAY_ORG_PAYMENT_METHODS_F
               WHERE ORG_PAYMENT_METHOD_NAME = a.PAYMENT_METHOD)
                payment_method_id,
             a.*
        FROM per_all_people_f person,
             per_periods_of_service service,
             per_all_assignments_f assignment,
             xxemp_bank_upload a
       WHERE 1 = 1                         -- '04024' = PERSON.EMPLOYEE_NUMBER
             AND TRUNC (SYSDATE) BETWEEN person.effective_start_date
                                     AND person.effective_end_date
             AND TRUNC (SYSDATE) BETWEEN assignment.effective_start_date
                                     AND assignment.effective_end_date
             AND person.person_id = service.person_id(+)
             AND assignment.primary_flag = 'Y'
             --AND TRUNC(PERSON.EFFECTIVE_START_DATE) = TRUNC(SERVICE.DATE_START)
             AND person.person_id = assignment.person_id
             AND a.empno = assignment.assignment_number
--             AND ROWNUM = 1
             AND a.empno not in ('00002','03038','03045')  and status is null ;
--             AND a.status IS NULL;
BEGIN
   DBMS_OUTPUT.put_line (
      '#############################################################');
   DBMS_OUTPUT.put_line (
      'Data Migration Of Payment Method and Payment Method History :');
   DBMS_OUTPUT.put_line (
      '#############################################################');
   DBMS_OUTPUT.put_line (
      'Start Time : ' || TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));

   fnd_global.apps_initialize (0, 50637, 800);



   FOR rec_pay IN cur_pay
   LOOP
      l_total_records := l_total_records + 1;

      BEGIN
         -------------CHECK IS RECORD EXIST OR NOT------------------

         l_per_id := NULL;
         l_obj := NULL;
         method_id := NULL;



         --         BEGIN
         --            SELECT assignment_id,
         --                   object_version_number,
         --                   personal_payment_method_id
         --              INTO l_per_id, l_obj, method_id
         --              FROM pay_personal_payment_methods_f
         --             WHERE (assignment_id, effective_end_date) IN
         --                      (  SELECT assignment_id, MAX (effective_end_date)
         --                           FROM pay_personal_payment_methods_f
         --                          WHERE assignment_id = rec_pay.assignment_id
         --                       GROUP BY assignment_id);
         --         EXCEPTION
         --            WHEN NO_DATA_FOUND
         --            THEN
         --               l_per_id := -1;
         --         END;

         ------------------------------------------------------------------------------------------


         --         IF l_per_id <> -1
         --         THEN
         or_object_version_number := l_obj;

         hr_personal_pay_method_api.create_personal_pay_method (
            p_effective_date               => rec_pay.effective_start_date,
            p_assignment_id                => rec_pay.assignment_id,
            p_org_payment_method_id        => rec_pay.payment_method_id,
            p_percentage                   => 100,
            p_amount                       => NULL,
            p_priority                     => 1,
            p_territory_code               => 'AE',
            p_segment1                     => trim(rec_pay.bank_name),
            p_segment2                     => trim(rec_pay.bank_branch),
            p_segment3                     => trim(rec_pay.account_name),
            p_segment4                     => trim(rec_pay.account_number),
            p_segment5                     => trim(rec_pay.iban_no),
            p_segment6                     => trim(rec_pay.bank_code),
            p_personal_payment_method_id   => method_id,
            p_external_account_id          => or_external_account_id,
            p_object_version_number        => or_object_version_number,
            p_effective_start_date         => or_effective_start_date,
            p_effective_end_date           => or_effective_end_date,
            p_comment_id                   => or_comment_id);

         DBMS_OUTPUT.put_line ('or_comment_id  ' || or_comment_id);

         UPDATE xxemp_bank_upload a
            SET status = 'Y'
          WHERE a.empno = rec_pay.empno;

         UPDATE xxemp_bank_upload a
            SET xp_personal_payment_method_id = method_id
          WHERE a.empno = rec_pay.empno;

         UPDATE xxemp_bank_upload a
            SET xp_external_account_id = or_external_account_id
          WHERE a.empno = rec_pay.empno;

         UPDATE xxemp_bank_upload a
            SET xp_object_version_number = or_object_version_number
          WHERE a.empno = rec_pay.empno;

         UPDATE xxemp_bank_upload a
            SET xp_effective_start_date = or_effective_start_date
          WHERE a.empno = rec_pay.empno;

         UPDATE xxemp_bank_upload a
            SET xp_effective_end_date = or_effective_end_date
          WHERE a.empno = rec_pay.empno;

         UPDATE xxemp_bank_upload a
            SET xp_comment_id = or_comment_id
          WHERE a.empno = rec_pay.empno;

         COMMIT;
         l_success_records := l_success_records + 1;
      --         END IF;
      EXCEPTION
         WHEN OTHERS
         THEN
            l_failure_records := l_failure_records + 1;
            error_msg := SUBSTR (SQLERRM, 1, 200);

            UPDATE xxemp_bank_upload a
               SET xerror_msg = error_msg
             WHERE a.empno = rec_pay.empno;


            DBMS_OUTPUT.put_line ('error_msg' || error_msg);

            UPDATE xxemp_bank_upload a
               SET a.status = NULL
             WHERE a.empno = rec_pay.empno;

            COMMIT;
      END;
   END LOOP;

   DBMS_OUTPUT.put_line (
      'End Time : ' || TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
   DBMS_OUTPUT.put_line (
      '#############################################################');
   DBMS_OUTPUT.put_line ('Total Records To Be Loaded : ' || l_total_records);
   DBMS_OUTPUT.put_line (
      'Total Success Records      : ' || l_success_records);
   DBMS_OUTPUT.put_line (
      'Total Failure Records      : ' || l_failure_records);
   DBMS_OUTPUT.put_line (
      '#############################################################');
END;
/

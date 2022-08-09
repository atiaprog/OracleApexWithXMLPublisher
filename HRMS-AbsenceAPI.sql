/*
			BY : Customized by atia  2018 
			API Name : Oracle HRMS Absence API 
			Version : 1.0.0
**/

CREATE OR REPLACE PROCEDURE APPS.xx_absence_upload
AS
   ---------------------- API Out Parameters -------------
   p_absence_days                NUMBER;
   p_absence_hours               NUMBER;
   p_absence_attendance_id       NUMBER;
   p_object_version_number       NUMBER;
   p_occurrence                  NUMBER;
   p_dur_dys_less_warning        BOOLEAN;
   p_dur_hrs_less_warning        BOOLEAN;
   p_exceeds_pto_entit_warning   BOOLEAN;
   p_exceeds_run_total_warning   BOOLEAN;
   p_abs_overlap_warning         BOOLEAN;
   p_abs_day_after_warning       BOOLEAN;
   p_dur_overwritten_warning     BOOLEAN;
   p_days                        NUMBER;
   p_days_hours                  NUMBER;
   
       error_msg   varchar2(200);

   CURSOR c1
   IS
      SELECT A.ROWID row_id,
             a.employee_code,
             a.absance_type_name,
             (SELECT absence_attendance_type_id
                FROM per_absence_attendance_types
               WHERE name = a.absance_type_name)
                absance_id,
             absence_start_date,
             absence_end_date,
             (absence_end_date - absence_start_date) + 1 days,
             b.person_id,
             b.business_group_id,
             process_flag
        FROM xx_emp_absence_upload a, per_all_people_f b
       WHERE a.employee_code = b.employee_number
             AND TO_CHAR (SYSDATE, 'DD-MON-YYYY') BETWEEN b.effective_start_date
                                                      AND b.effective_end_date AND a.DAYS is  null  ; --AND  EMPLOYEE_CODE = '03213'  ;
--                                                      AND ABSANCE_TYPE_NAME  =  'Annual Leave';
BEGIN
   -------------------------------------------------
   
      fnd_global.apps_initialize (0, 50637, 800);     
      
   FOR i IN c1
   LOOP
      BEGIN
         p_days := i.days;
         hr_person_absence_api.create_person_absence (
            p_validate                     => FALSE,
            p_effective_date               => i.absence_start_date,
            p_person_id                    => i.person_id,
            p_business_group_id            => i.business_group_id,
            p_absence_attendance_type_id   => i.absance_id,
            p_date_start                   => i.absence_start_date,
            p_date_end                     => i.absence_end_date,
--            p_attribute1                   => i.PROCESS_FLAG,
            p_absence_days                 => p_days,
            p_absence_hours                => p_days_hours,
            p_absence_attendance_id        => p_absence_attendance_id,
            p_object_version_number        => p_object_version_number,
            p_occurrence                   => p_occurrence,
            p_dur_dys_less_warning         => p_dur_dys_less_warning,
            p_dur_hrs_less_warning         => p_dur_hrs_less_warning,
            p_exceeds_pto_entit_warning    => p_exceeds_pto_entit_warning,
            p_exceeds_run_total_warning    => p_exceeds_run_total_warning,
            p_abs_overlap_warning          => p_abs_overlap_warning,
            p_abs_day_after_warning        => p_abs_day_after_warning,
            p_dur_overwritten_warning      => p_dur_overwritten_warning);

         DBMS_OUTPUT.put_line (
            ' p_absence_attendance_id' || p_absence_attendance_id);
            
          DBMS_OUTPUT.put_line (
            ' p_occurrence' ||  p_occurrence);

         UPDATE xx_emp_absence_upload
            SET days = p_days
          WHERE ROWID = i.row_id;

         UPDATE xx_emp_absence_upload
            SET days_hours = p_days_hours
          WHERE ROWID = i.row_id;

         UPDATE xx_emp_absence_upload
            SET absence_attendance_id = p_absence_attendance_id
          WHERE ROWID = i.row_id;

         UPDATE xx_emp_absence_upload
            SET object_version_number = p_object_version_number
          WHERE ROWID = i.row_id;

         UPDATE xx_emp_absence_upload
            SET occurrence = p_occurrence
          WHERE ROWID = i.row_id;

--         UPDATE xx_emp_absence_upload
--            SET dur_dys_less_warning = to_char(p_dur_dys_less_warning)
--          WHERE ROWID = i.row_id;
--
--
--         UPDATE xx_emp_absence_upload
--            SET dur_hrs_less_warning = to_char(p_dur_hrs_less_warning)
--          WHERE ROWID = i.row_id;
--
--         UPDATE xx_emp_absence_upload
--            SET exceeds_pto_entit_warning = p_exceeds_pto_entit_warning
--          WHERE ROWID = i.row_id;
--
--
--         UPDATE xx_emp_absence_upload
--            SET exceeds_run_total_warning = to_char(p_exceeds_run_total_warning)
--          WHERE ROWID = i.row_id;
--
--         UPDATE xx_emp_absence_upload
--            SET abs_overlap_warning = to_char(p_abs_overlap_warning)
--          WHERE ROWID = i.row_id;
--
--         UPDATE xx_emp_absence_upload
--            SET abs_day_after_warning = to_char(p_abs_day_after_warning)
--          WHERE ROWID = i.row_id;
--
--         UPDATE xx_emp_absence_upload
--            SET dur_overwritten_warning = to_char(p_dur_overwritten_warning)
--          WHERE ROWID = i.row_id;



         p_absence_days := NULL;
         p_absence_hours := NULL;
         p_absence_attendance_id := NULL;
         p_object_version_number := NULL;
         p_occurrence := NULL;
         p_dur_dys_less_warning := NULL;
         p_dur_hrs_less_warning := NULL;
         p_exceeds_pto_entit_warning := NULL;
         p_exceeds_run_total_warning := NULL;
         p_abs_overlap_warning := NULL;
         p_abs_day_after_warning := NULL;
         p_dur_overwritten_warning := NULL;
      EXCEPTION
         WHEN OTHERS
         THEN
            p_absence_days := NULL;
            p_absence_hours := NULL;
            p_absence_attendance_id := NULL;
            p_object_version_number := NULL;
            p_occurrence := NULL;
            p_dur_dys_less_warning := NULL;
            p_dur_hrs_less_warning := NULL;
            p_exceeds_pto_entit_warning := NULL;
            p_exceeds_run_total_warning := NULL;
            p_abs_overlap_warning := NULL;
            p_abs_day_after_warning := NULL;
            p_dur_overwritten_warning := NULL;
            
              error_msg := SUBSTR (SQLERRM, 1, 99);
            
             UPDATE xx_emp_absence_upload
            SET dur_overwritten_warning =     error_msg 
          WHERE ROWID = i.row_id;
      END;
   END LOOP;

   COMMIT;

   DBMS_OUTPUT.put_line (
      ' p_absence_attendance_id' || p_absence_attendance_id);
--EXCEPTION
--   WHEN OTHERS
--   THEN
--      NULL;
END; 
/

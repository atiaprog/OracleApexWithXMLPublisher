/*
			BY : Customized by atia  2018 
			API Name : Oracle HRMS  Assignment API 
			Version : 1.0.0
**/
CREATE OR REPLACE PROCEDURE APPS.xx_assign_upload_criteria_proc
 (v_emp_no varchar2 default null, v_update_mode varchar2 default null )
AS
   vl$validate_mode                 BOOLEAN := FALSE;
    vl$assignment_id                 per_assignments_f.assignment_id%TYPE;
   vl$assignment_number             VARCHAR2 (50);
   vl$set_of_books_name             VARCHAR2 (200) := 'COMEX MXN BOOK';
   vl$set_of_books                  NUMBER;
   p_employee_number                VARCHAR2 (50) := '$__19A1099000001'; --'$__19A1099000001';
   vl$person_id                     NUMBER;
   vl$object_version_number         NUMBER;
   vl$job_title                     VARCHAR2 (200);
   vl$job_id                        NUMBER;
   vl$job_name                      VARCHAR2 (200) := 'ELECTRICIAN';
   vl$location_id                   NUMBER := 127;
   vl$called_from_mass_update       BOOLEAN := FALSE;
   V_people_group_id                NUMBER;
   V_object_version_number          NUMBER;
   V_special_ceiling_step_id        NUMBER;
   V_group_name                     VARCHAR2 (4000);
   V_effective_start_date           DATE;
   V_effective_end_date             DATE;
  V_org_now_no_manager_warning     BOOLEAN;
   v_other_manager_warning          BOOLEAN;
   v_spp_delete_warning             BOOLEAN;
   v_entries_changed_warning        VARCHAR2 (4000);
   v_tax_district_changed_warning   BOOLEAN;
   vl$fb_entra                      BOOLEAN := TRUE;
   v_concatenated_segments          VARCHAR2 (200);
   v_gsp_post_process_warning       VARCHAR2 (200);
   v_soft_coding_keyflex_id         NUMBER;

    my_errcode NUMBER;
    my_errm VARCHAR2(32000);

  v_effective_date                DATE := '01-Jan-2013';
   v_datetrack_update_mode        VARCHAR2 (50) := 'UPDATE'; -- CORRECTION|UPDATE
   CURSOR c1
   IS
  SELECT
       ( select organization_id from hr_all_organization_units where type ='LE'
       and name = v.LEGAL_EMPLOYER )
                LEGAL_EMPLOYER,
             (SELECT assignment_id
                FROM per_all_people_f a, per_all_assignments_f b
               WHERE     a.person_id = b.person_id
                     AND a.EMPLOYEE_NUMBER = v.employee_code
                    AND trunc(SYSDATE)  BETWEEN  b.EFFECTIVE_START_DATE AND  b.EFFECTIVE_END_DATE
            AND trunc(SYSDATE)  BETWEEN  a.EFFECTIVE_START_DATE AND  a.EFFECTIVE_END_DATE
                   AND ROWNUM = 1)
                assignment_id,
              (SELECT b.effective_start_date
                FROM per_all_people_f a, per_all_assignments_f b
               WHERE     a.person_id = b.person_id
                     AND a.EMPLOYEE_NUMBER = v.employee_code
                    AND trunc(SYSDATE)  BETWEEN  b.EFFECTIVE_START_DATE AND  b.EFFECTIVE_END_DATE
            AND trunc(SYSDATE)  BETWEEN  a.EFFECTIVE_START_DATE AND  a.EFFECTIVE_END_DATE
                   AND ROWNUM = 1)
                ASG_EFF_ST_date,
             (SELECT B.OBJECT_VERSION_NUMBER
                FROM per_all_people_f a, per_all_assignments_f b
               WHERE     a.person_id = b.person_id
                      AND trunc(SYSDATE)  BETWEEN  b.EFFECTIVE_START_DATE AND  b.EFFECTIVE_END_DATE
                        AND trunc(SYSDATE)  BETWEEN  a.EFFECTIVE_START_DATE AND  a.EFFECTIVE_END_DATE
                        AND a.EMPLOYEE_NUMBER = v.employee_code
                     AND ROWNUM = 1)
                obj_ver_no,
             v.employee_code,
             (SELECT POSITION_ID
                FROM HR_ALL_POSITIONS_F
               WHERE NAME = v.POSITION
               and ROWNUM = 1 )
                position_id,
             (SELECT job_ID
                FROM PER_JOBS
               WHERE NAME = v.JOB_TITLE
               and ROWNUM = 1 )
                job_id,
             v.POSITION,
             (SELECT ORGANIZATION_ID
                FROM hr_all_organization_units
               WHERE NAME = v.ORGANIZATION)
                org_id,
                (SELECT LOCATION_ID
                FROM hr_locations_all
               WHERE LOCATION_CODE = v.location)
                location,
             ASSIGNMENT_STATUS,
             STAFF_TYPE,
             SHIFT_HOURS || ' Hours' SHIFT_HOURS,
             DECODE (ACCOMMODATION_PROVIDED,
                     'Yes', 'Y',
                     'yes', 'Y',
                     'No', 'N',
                     'no', 'N',
                    Null)
                ACCOMMODATION_PROVIDED,
             DECODE (TRANSPORTAION_PROVIDED,
                     'Yes', 'Y',
                     'yes', 'Y',
                     'No', 'N',
                     'no', 'N',
                     Null)
                TRANSPORTAION_PROVIDED,
             DECODE (OVERTIME_ELIGIBLE,'yes', 'Y',  'Yes', 'Y',  'No', 'N', 'no', 'N', Null)
                OVERTIME_ELIGIBLE,
             DECODE (SPECIAL_OT_ELIGIBLE, 'yes', 'Y',  'Yes', 'Y',  'No', 'N', 'no', 'N', Null)
                SPECIAL_OT_ELIGIBLE,
                SPECIAL_OT_RATE,
             DECODE (TIME_SHEET_REQUIRED,  'yes', 'Y',  'Yes', 'Y',  'No', 'N', 'no', 'N',  Null)
                TIME_SHEET_REQUIRED,
           TO_DATE(ASSIGNMENT_EFFICITIVE_DATE,'MM/DD/YYYY')
                ASSIGNMENT_EFFICITIVE_DATE,
             (SELECT person_id
                FROM per_all_people_f
               WHERE supervisor = employee_number AND ROWNUM = 1)
                supervisor_id,
                   (SELECT assignment_id
                FROM per_all_people_f a, per_all_assignments_f b
               WHERE     a.person_id = b.person_id
                     AND a.EMPLOYEE_NUMBER = v.supervisor
                    AND trunc(SYSDATE)  BETWEEN  b.EFFECTIVE_START_DATE AND  b.EFFECTIVE_END_DATE
            AND trunc(SYSDATE)  BETWEEN  a.EFFECTIVE_START_DATE AND  a.EFFECTIVE_END_DATE
                   AND ROWNUM = 1)
                sup_assign_id,
             supervisor,
             Payroll_id,
             People_grp_id
        FROM xx_assign_upload v
       WHERE v.employee_code like nvl(v_emp_no,'%')
       and Record_criteria_processed_flag is null  ;




BEGIN
  
if v_update_mode is not null then 
  v_datetrack_update_mode := v_update_mode;
 End if;

   FOR i IN c1
   LOOP

   Begin
    v_effective_date  :=  '01-Jan-2013';  
   if v_effective_date <= i.asg_eff_st_date then 
     v_effective_date := i.asg_eff_st_date ;
     v_datetrack_update_mode := 'CORRECTION' ; 
     
   Else 
     v_datetrack_update_mode := 'UPDATE' ; 
     
   End if ;

        V_people_group_id                := null ;
        V_object_version_number          := i.obj_ver_no;
        V_special_ceiling_step_id        := null;
        V_group_name                     := null;
        V_effective_start_date           := null;
        V_effective_end_date              := null;
        v_entries_changed_warning        := null;
        v_concatenated_segments          := null;
        v_gsp_post_process_warning       := null;
     --   v_soft_coding_keyflex_id         := i.LEGAL_EMPLOYER;
      v_soft_coding_keyflex_id         := null;
     -- v_effective_date := I.ASG_EFF_ST_date;
      
    
     hr_assignment_api.update_emp_asg_criteria (
         p_effective_date                 => v_effective_date,
      p_datetrack_update_mode          => v_datetrack_update_mode,
      p_assignment_id                  => i.ASSIGNMENT_ID,
      p_validate                       => False,
      p_called_from_mass_update        => NULL,
      p_grade_id                       => NULL,
      p_position_id                    => i.POSITION_ID,
      p_job_id                         => i.job_id,
      p_payroll_id                     => i.Payroll_id,
      p_location_id                    => i.LOCATION,
      p_organization_id                => i.ORG_ID,
      p_pay_basis_id                   => NULL,
      p_segment1                       => i.STAFF_TYPE,
      p_segment2                       => i.SHIFT_HOURS,
      p_SEGMENT3                       => i.ACCOMMODATION_PROVIDED, --    Accommodation Provided
      p_SEGMENT4                       => i.TRANSPORTAION_PROVIDED, --    Transportaion Provided
      p_SEGMENT5                       => i.OVERTIME_ELIGIBLE, --    Overtime Eligible
      p_SEGMENT6                       => i.SPECIAL_OT_ELIGIBLE, --    Special OT Eligible 
      p_segment7                       => i.SPECIAL_OT_RATE, --   Special OT Rate,
      p_SEGMENT8                       => i.TIME_SHEET_REQUIRED, --    Time Sheet Required
      p_SEGMENT9                       => null, 
      p_supervisor_assignment_id       => i.sup_assign_id , 
      p_object_version_number          => v_object_version_number,
      p_special_ceiling_step_id        => v_special_ceiling_step_id,
      p_people_group_id                => v_people_group_id,
      p_soft_coding_keyflex_id         => v_soft_coding_keyflex_id,
      p_group_name                     => v_group_name,
      p_effective_start_date           => v_effective_start_date,
      p_effective_end_date             => v_effective_end_date,
      p_org_now_no_manager_warning     => v_org_now_no_manager_warning,
      p_other_manager_warning          => v_other_manager_warning,
      p_spp_delete_warning             => v_spp_delete_warning,
      p_entries_changed_warning        => v_entries_changed_warning,
      p_tax_district_changed_warning   => v_tax_district_changed_warning,
      p_concatenated_segments          => v_concatenated_segments,
      p_gsp_post_process_warning       => v_gsp_post_process_warning);

      -- If API is Successfull 
      Update xx_assign_upload set Record_criteria_processed_flag = 'Y' , Record_criteria_processed_dt = sysdate 
      where employee_code = i.employee_code ;
      
        dbms_output.put_line( 'Employee code :'|| i.employee_code || ' Updated ');
     
      Exception
       When Others then
         my_errcode := SQLCODE;
         my_errm := SQLERRM;
         update xx_assign_upload set Record_err_message = substr(('Employee code :'|| i.employee_code||'Ass Eff dt :'||
          to_char(I.ASG_EFF_ST_date,'DD-MON-YYYY') || 
           'Position id ' || i.POSITION_ID|| 'Error code ' || my_errcode || ': ' || my_errm),1, 2000),
                  Record_processed_dt = sysdate 
         where employee_code = i.employee_code ;
          
         dbms_output.put_line( 'Employee code :'|| i.employee_code||'Ass Eff dt :'||
          to_char(I.ASG_EFF_ST_date,'DD-MON-YYYY') || 
           'Position id ' || i.POSITION_ID||
          'Error code ' || my_errcode || ': ' || my_errm);
    End ;
   END LOOP;

   COMMIT;
-- Output the results
EXCEPTION
   WHEN OTHERS    THEN
      DBMS_OUTPUT.put_line (
         SUBSTR ('Error ' || TO_CHAR (SQLCODE) || ': ' || SQLERRM, 1, 255));
      RAISE;
END;
/

CREATE OR REPLACE procedure APPS.XX_ASSIGN_UPLOAD_PROC ( v_emp_no varchar2 default null , v_update_mode varchar2 default null ) as

   lc_dt_ud_mode                   VARCHAR2 (100) := NULL;
   ln_assignment_id                NUMBER;
   ln_supervisor_id                NUMBER;
   ln_object_number                NUMBER;
   ln_people_group_id              NUMBER;

   -- Out Variables for Find Date Track Mode API
   -- -----------------------------------------------------------------
   lb_correction                   BOOLEAN;
   lb_update                       BOOLEAN;
   lb_update_override              BOOLEAN;
   lb_update_change_insert         BOOLEAN;

   -- Out Variables for Update Employee Assignment API
   -- ----------------------------------------------------------------------------
   ln_soft_coding_keyflex_id       HR_SOFT_CODING_KEYFLEX.SOFT_CODING_KEYFLEX_ID%TYPE;
   lc_concatenated_segments        VARCHAR2 (2000);
   ln_comment_id                   PER_ALL_ASSIGNMENTS_F.COMMENT_ID%TYPE;
   lb_no_managers_warning          BOOLEAN;

   -- Out Variables for Update Employee Assgment Criteria
   -- -------------------------------------------------------------------------------
   ln_special_ceiling_step_id      PER_ALL_ASSIGNMENTS_F.SPECIAL_CEILING_STEP_ID%TYPE;
   lc_group_name                   VARCHAR2 (30);
   ld_effective_start_date         PER_ALL_ASSIGNMENTS_F.EFFECTIVE_START_DATE%TYPE;
   ld_effective_end_date           PER_ALL_ASSIGNMENTS_F.EFFECTIVE_END_DATE%TYPE;
   lb_org_now_no_manager_warning   BOOLEAN;
   lb_other_manager_warning        BOOLEAN;
   lb_spp_delete_warning           BOOLEAN;
   lc_entries_changed_warning      VARCHAR2 (30);
   lb_tax_district_changed_warn    BOOLEAN;
  my_errcode NUMBER;
    my_errm VARCHAR2(32000);
    
   v_cagr_grade_def_id            number  ;

 v_cagr_concatenated_segments     varchar2(200);
  V_concatenated_segments           varchar2 (200);
  V_soft_coding_keyflex_id        number ; -- bug 2359997
  V_comment_id                      number;
  V_effective_start_date             date;
  V_effective_end_date               date;
  v_no_managers_warning              boolean;
  v_other_manager_warning            boolean;
  v_hourly_salaried_warning          boolean;
  v_gsp_post_process_warning        varchar2(4000);
  v_effective_date                DATE := '01-Jan-2013';
  v_datetrack_update_mode        VARCHAR2 (50) := 'UPDATE'; -- CORRECTION|UPDATE

   CURSOR c1
   IS
      SELECT
       ( select organization_id from hr_all_organization_units where type ='LE'
       and name = v.LEGAL_EMPLOYER )
                LEGAL_EMPLOYER,
             (SELECT assignment_id
                FROM per_all_people_f a, per_all_assignments_f b
               WHERE     a.person_id = b.person_id
                     AND a.EMPLOYEE_NUMBER = v.employee_code
                    AND trunc(SYSDATE)  BETWEEN  b.EFFECTIVE_START_DATE AND  b.EFFECTIVE_END_DATE
            AND trunc(SYSDATE)  BETWEEN  a.EFFECTIVE_START_DATE AND  a.EFFECTIVE_END_DATE
                   AND ROWNUM = 1)
                assignment_id,
              (SELECT b.effective_start_date
                FROM per_all_people_f a, per_all_assignments_f b
               WHERE     a.person_id = b.person_id
                     AND a.EMPLOYEE_NUMBER = v.employee_code
                    AND trunc(SYSDATE)  BETWEEN  b.EFFECTIVE_START_DATE AND  b.EFFECTIVE_END_DATE
            AND trunc(SYSDATE)  BETWEEN  a.EFFECTIVE_START_DATE AND  a.EFFECTIVE_END_DATE
                   AND ROWNUM = 1)
                ASG_EFF_ST_date,
             (SELECT B.OBJECT_VERSION_NUMBER
                FROM per_all_people_f a, per_all_assignments_f b
               WHERE     a.person_id = b.person_id
                      AND trunc(SYSDATE)  BETWEEN  b.EFFECTIVE_START_DATE AND  b.EFFECTIVE_END_DATE
                        AND trunc(SYSDATE)  BETWEEN  a.EFFECTIVE_START_DATE AND  a.EFFECTIVE_END_DATE
                        AND a.EMPLOYEE_NUMBER = v.employee_code
                     AND ROWNUM = 1)
                obj_ver_no,
                
                (SELECT  pcf1.CONTRACT_ID
                 from per_all_people_f a,per_contracts_f pcf1
                    Where pcf1.Status ='A-ACTIVE'
                       and a.person_id = pcf1.person_id
                        AND trunc(SYSDATE)  BETWEEN  a.EFFECTIVE_START_DATE AND  a.EFFECTIVE_END_DATE
                        AND a.EMPLOYEE_NUMBER = v.employee_code ) contract_id,
             v.employee_code,
             (SELECT POSITION_ID
                FROM HR_ALL_POSITIONS_F
               WHERE NAME = v.POSITION
               and ROWNUM = 1 )
                position_id,
             (SELECT job_ID
                FROM PER_JOBS
               WHERE NAME = v.JOB_TITLE
               and ROWNUM = 1 )
                job_id,
             v.POSITION,
             (SELECT ORGANIZATION_ID
                FROM hr_all_organization_units
               WHERE NAME = v.ORGANIZATION and rownum=1)
                org_id,
                (SELECT LOCATION_ID
                FROM hr_locations_all
               WHERE LOCATION_CODE = v.location and rownum = 1)
                location,
             ASSIGNMENT_STATUS,
             STAFF_TYPE,
             SHIFT_HOURS || ' Hours' SHIFT_HOURS,
             DECODE (ACCOMMODATION_PROVIDED,
                     'Yes', 'Y',
                     'No', 'N',
                     'Null')
                ACCOMMODATION_PROVIDED,
             DECODE (TRANSPORTAION_PROVIDED,
                     'Yes', 'Y',
                     'No', 'N',
                     'Null')
                TRANSPORTAION_PROVIDED,
             DECODE (OVERTIME_ELIGIBLE,  'Yes', 'Y',  'No', 'N',  'Null')
                OVERTIME_ELIGIBLE,
             DECODE (SPECIAL_OT_ELIGIBLE,  'Yes', 'Y',  'No', 'N',  'Null')
                SPECIAL_OT_ELIGIBLE,
             DECODE (SPECIAL_OT_RATE,  'Yes', 'Y',  'No', 'N',  'Null')
                SPECIAL_OT_RATE,
             DECODE (TIME_SHEET_REQUIRED,  'Yes', 'Y',  'No', 'N',  'Null')
                TIME_SHEET_REQUIRED,
           TO_DATE(ASSIGNMENT_EFFICITIVE_DATE,'MM/DD/YYYY')
                ASSIGNMENT_EFFICITIVE_DATE,
             (SELECT person_id
                FROM per_all_people_f
               WHERE supervisor = employee_number AND ROWNUM = 1)
                supervisor_id,
             supervisor
        FROM xx_assign_upload v
       WHERE v.employee_code like nvl(v_emp_no,'%')
        and Record_processed_flag is null;
BEGIN
  if v_update_mode is not null then 
  v_datetrack_update_mode := v_update_mode;
  End if;

   FOR i IN c1
   LOOP

   Begin
    v_effective_date  :=  '01-Jan-2013';
   if v_effective_date <= i.asg_eff_st_date then 
     v_effective_date := i.asg_eff_st_date ;
     v_datetrack_update_mode := 'CORRECTION' ; 
     
   Else 
     v_datetrack_update_mode := 'UPDATE' ; 
     
   End if ;
     

   DBMS_OUTPUT.put_line ('Test 2') ;

      ln_object_number  :=   NVL(i.OBJ_VER_NO,1) ;
      V_soft_coding_keyflex_id := null ;
      
   /*   v_effective_date                DATE := '01-Jan-2013';
   v_datetrack_update_mode        VARCHAR2 (50) := 'UPDATE'; -- CORRECTION|UPDATE*/

      hr_assignment_api.update_emp_asg (                -- Input data elements
         -- ------------------------------
         p_validate => False,
         p_effective_date             => v_effective_date,
         p_datetrack_update_mode      => v_datetrack_update_mode,
         p_assignment_id              => to_number(i.ASSIGNMENT_ID),
         p_supervisor_id              => to_number(i.supervisor_id),
  --       p_change_reason              => NULL,
  --       p_manager_flag               => NULL,
  --       p_bargaining_unit_code       => NULL,
 --        p_labour_union_member_flag   => NULL,
        p_segment1                   => I.LEGAL_EMPLOYER,
         p_segment2                   => Null,
        p_segment3                   => Null,
        p_segment4                   => Null,
        p_segment5                  => Null,
        p_segment7                   => Null,
        p_segment8                   => Null, 
        p_contract_id      => i.contract_id,       
--         p_segment3                   => NULL,
 --        p_normal_hours               => NULL,
  --       p_frequency                  => NULL,
         -- Output data elements
         -- -------------------------------
        p_object_version_number      =>  ln_object_number,
        p_cagr_grade_def_id      =>      v_cagr_grade_def_id,
  p_cagr_concatenated_segments  =>    v_cagr_concatenated_segments,
  p_concatenated_segments      =>     v_concatenated_segments,
  p_soft_coding_keyflex_id  =>     v_soft_coding_keyflex_id,
          p_comment_id                 => v_comment_id,
         p_effective_start_date       => v_effective_start_date,
         p_effective_end_date         => v_effective_end_date,
         p_no_managers_warning        => v_no_managers_warning,
         p_other_manager_warning      => v_other_manager_warning
);

--         DBMS_OUTPUT.put_line (' ln_comment_id' ||  ln_comment_id);
--         DBMS_OUTPUT.put_line (' lb_no_managers_warning' ||  lb_no_managers_warning);
--         DBMS_OUTPUT.put_line (' lb_other_manager_warning' ||  lb_other_manager_warning);


       Update xx_assign_upload set Record_processed_flag = 'Y' , Record_processed_dt = sysdate 
      where employee_code = i.employee_code ;
     
       dbms_output.put_line( 'Employee code :'|| i.employee_code || ' Updated ');
        
      Exception
       When Others then
         my_errcode := SQLCODE;
         my_errm := SQLERRM;
         update xx_assign_upload set Record_err_message = substr(('Employee code :'|| i.employee_code||'Ass Eff dt :'||
          to_char(I.ASG_EFF_ST_date,'DD-MON-YYYY') || 
           'Position id ' || i.POSITION_ID|| 'Error code ' || my_errcode || ': ' || my_errm),1, 2000),
            Record_processed_dt = sysdate 
         where employee_code = i.employee_code ;
          
         dbms_output.put_line( 'Employee code :'|| i.employee_code||'Ass Eff dt :'||
          to_char(I.ASG_EFF_ST_date,'DD-MON-YYYY') || 
           'Position id ' || i.POSITION_ID||
          'Error code ' || my_errcode || ': ' || my_errm);

      End ;
      
      
      
   END LOOP;

DBMS_OUTPUT.put_line ('Test 5') ;
   COMMIT;
-- Output the results
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line (
         SUBSTR ('Error ' || TO_CHAR (SQLCODE) || ': ' || SQLERRM, 1, 255));
      RAISE;
END;
/

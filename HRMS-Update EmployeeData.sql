---------------------------------------------------
-- Purpose : Updating Basic Information for Employee
-- Developed BY  : atia Dec-2018  rev :1.0
----------------------------------------------------
set serveroutput on;
DECLARE
---------------------------------------------------------
---              in parameter
---------------------------------------------------------
  l_validate                            boolean :=false --required paramater
  ;l_effective_date                     date   :=to_date('13-DEC-2018','DD-MON-YYYY')   --to_date(sysdate,'DD-MON-YYYY') --required paramater
  ;l_datetrack_update_mode              varchar2(500) --required paramater
  ;l_person_id                          number         --required paramater
  ;l_person_type_id                     number  
  ;l_last_name                          varchar2(500) --required paramater
  ;l_applicant_number                   varchar2(500) --required paramater
  ;l_comments                           varchar2(500)
  ;l_date_employee_data_verified        date     
  ;l_date_of_birth                      date     
  ;l_email_address                      varchar2 (500)
  ;l_employee_number                    varchar2 (500) -- inout paratmers required paramater 
  ;l_expense_check_send_to_addres       varchar2 (500)
  ;l_first_name                         varchar2 (500)
  ;l_known_as                           varchar2 (500)
  ;l_marital_status                     varchar2 (500)  
  ;l_middle_names                       varchar2 (500)
  ;l_nationality                        varchar2 (500)
  ;l_national_identifier                varchar2 (500)
  ;l_previous_last_name                 varchar2 (500)
  ;l_registered_disabled_flag           varchar2 (500)
  ;l_sex                                varchar2 (500)
  ;l_title                              varchar2 (500)
  ;l_vendor_id                          number   
  ;l_work_telephone                     varchar2 (500)
  ;l_attribute_category                 varchar2 (500)
  ;l_attribute1                         varchar2 (500)
  ;l_attribute2                         varchar2 (500)
  ;l_attribute3                         varchar2 (500)
  ;l_attribute4                         varchar2 (500)
  ;l_attribute5                         varchar2 (500)
  ;l_attribute6                         varchar2 (500)
  ;l_attribute7                         varchar2 (500)
  ;l_attribute8                         varchar2 (500)
  ;l_attribute9                         varchar2 (500)
  ;l_attribute10                        varchar2 (500)
  ;l_attribute11                        varchar2 (500)
  ;l_attribute12                        varchar2 (500)
  ;l_attribute13                        varchar2 (500)
  ;l_attribute14                        varchar2 (500)
  ;l_attribute15                        varchar2 (500)
  ;l_attribute16                        varchar2 (500)
  ;l_attribute17                        varchar2 (500)
  ;l_attribute18                        varchar2 (500)
  ;l_attribute19                        varchar2 (500)
  ;l_attribute20                        varchar2 (500)
  ;l_attribute21                        varchar2 (500)
  ;l_attribute22                        varchar2 (500)
  ;l_attribute23                        varchar2 (500)
  ;l_attribute24                        varchar2 (500)
  ;l_attribute25                        varchar2 (500)
  ;l_attribute26                        varchar2 (500)
  ;l_attribute27                        varchar2 (500)
  ;l_attribute28                        varchar2 (500)
  ;l_attribute29                        varchar2 (500)
  ;l_attribute30                        varchar2 (500)
  ;l_per_information_category           varchar2 (500)
  ;l_per_information1                   varchar2 (500)
  ;l_per_information2                   varchar2 (500)
  ;l_per_information3                   varchar2 (500)
  ;l_per_information4                   varchar2 (500)
  ;l_per_information5                   varchar2 (500)
  ;l_per_information6                   varchar2 (500)
  ;l_per_information7                   varchar2 (500)
  ;l_per_information8                   varchar2 (500)
  ;l_per_information9                   varchar2 (500)
  ;l_per_information10                  varchar2 (500)
  ;l_per_information11                  varchar2 (500)
  ;l_per_information12                  varchar2 (500)
  ;l_per_information13                  varchar2 (500)
  ;l_per_information14                  varchar2 (500)
  ;l_per_information15                  varchar2 (500)
  ;l_per_information16                  varchar2 (500)
  ;l_per_information17                  varchar2 (500)
  ;l_per_information18                  varchar2 (500)
  ;l_per_information19                  varchar2 (500)
  ;l_per_information20                  varchar2 (500)
  ;l_per_information21                  varchar2 (500)
  ;l_per_information22                  varchar2 (500)
  ;l_per_information23                  varchar2 (500)
  ;l_per_information24                  varchar2 (500)
  ;l_per_information25                  varchar2 (500)
  ;l_per_information26                  varchar2 (500)
  ;l_per_information27                  varchar2 (500)
  ;l_per_information28                  varchar2 (500)
  ;l_per_information29                  varchar2 (500)
  ;l_per_information30                  varchar2 (500)
  ;l_date_of_death                      date     
  ;l_background_check_status            varchar2 (500)
  ;l_background_date_check              date     
  ;l_blood_type                         varchar2 (500)
  ;l_correspondence_language            varchar2 (500)
  ;l_fast_path_employee                 varchar2 (500)
  ;l_fte_capacity                       number   
  ;l_hold_applicant_date_until          date     
  ;l_honors                             varchar2 (500)
  ;l_internal_location                  varchar2 (500)
  ;l_last_medical_test_by               varchar2 (500)
  ;l_last_medical_test_date             date     
  ;l_mailstop                           varchar2 (500)
  ;l_office_number                      varchar2 (500)
  ;l_on_military_service                varchar2 (500)
  ;l_pre_name_adjunct                   varchar2 (500)
  ;l_projected_start_date               date     
  ;l_rehire_authorizor                  varchar2 (500)
  ;l_rehire_recommendation              varchar2 (500)
  ;l_resume_exists                      varchar2 (500)
  ;l_resume_last_updated                date     
  ;l_second_passport_exists             varchar2 (500)
  ;l_student_status                     varchar2 (500)
  ;l_work_schedule                      varchar2 (500)
  ;l_rehire_reason                      varchar2 (500)
  ;l_suffix                             varchar2 (500)
  ;l_benefit_group_id                   number   
  ;l_receipt_of_death_cert_date         date    
  ;l_coord_ben_med_pln_no               varchar2 (500)
  ;l_coord_ben_no_cvg_flag              varchar2 (500)
  ;l_coord_ben_med_ext_er               varchar2 (500)
  ;l_coord_ben_med_pl_name              varchar2 (500)
  ;l_coord_ben_med_insr_crr_name        varchar2 (500)
  ;l_coord_ben_med_insr_crr_ident       varchar2 (500)
  ;l_coord_ben_med_cvg_strt_dt          date     
  ;l_coord_ben_med_cvg_end_dt           date     
  ;l_uses_tobacco_flag                  varchar2 (500)
  ;l_dpdnt_adoption_date                date     
  ;l_dpdnt_vlntry_svce_flag             varchar2 (500)
  ;l_original_date_of_hire              date     
  ;l_adjusted_svc_date                  date     
  ;l_town_of_birth                      varchar2 (500)
  ;l_region_of_birth                    varchar2 (500)
  ;l_country_of_birth                   varchar2 (500)
  ;l_global_person_id                   varchar2 (500)
  ;l_party_id                           number   
  ;l_npw_number                         varchar2  (500)
  -----------------------------------------------------
  ------              out parameter 
  -----------------------------------------------------
  ;l_effective_start_date               date
  ;l_effective_end_date                 date
  ;l_full_name                          varchar2 (500)
  ;l_comment_id                         number
  ;l_name_combination_warning           boolean
  ;l_assign_payroll_warning             boolean
  ;l_orig_hire_warning                  boolean
  ;l_object_version_number              number;
---------------------------------------------------------------------------
--------------------------------------------------------------------------------
--         Defines audit varibles  used to hold errors and error message 
--------------------------------------------------------------------------------
v_errormsg   varchar2(2000);
v_status     varchar2(1);
-------------------------------------------------------------------------------
--Define Cursor for current employee information  
cursor c_emp_date 
        is 
         select  ROWID rowids,
                    person_id,
                    trim(code) code,
                    trim(insurance_no) insurance_no,
                    trim(last_name) last_name,
                    trim(arabic_name) arabic_name,
                    trim(high_org) high_org,
                    trim(org_name) org_name,
                    trim(position_name) position_name,
                    trim(job_name) job_name,
                    date_of_birth,
                    trim(birth_city) birth_city,
                    trim(birth_state) birth_state,
                    decode(trim(sex),'MALE','M','FEMAL','F') sex,
                    trim(national_identifier) national_identifier,
                    trim(identification_type) identification_type,
                    trim(education_qualification) education_qualification,
                    date_of_graduation,
                    trim(specialization) specialization,
                    trim(militry_service) militry_service,
                    start_date,
                    trim(address) address,
                    trim(city) city,
                    trim(state) state,
                    trim(phone) phone,
                    trim(expertise) expertise,
                    trim(email) email
                        
                              from  xx_swd_employees_upload;
                                          --  where code=1172;
BEGIN
       
 for hr_data in c_emp_date  loop  
    
    begin
    --Assing Correct version number to api    
    select max(papf.object_version_number)
            into l_object_version_number from per_all_people_f papf
        where  papf.employee_number=hr_data.code;
    exception 
        when others then null;
        
    end;    
    begin
    hr_person_api.update_person
    (
         p_validate => l_validate
        , p_effective_date => l_effective_date
        , p_datetrack_update_mode => 'CORRECTION'
        , p_effective_start_date => l_effective_start_date
        , p_effective_end_date => l_effective_end_date
        , p_object_version_number => l_object_version_number
        , p_name_combination_warning => l_name_combination_warning
        , p_assign_payroll_warning => l_assign_payroll_warning
        , p_orig_hire_warning => l_orig_hire_warning
        , p_comment_id => l_comment_id
        , p_full_name => l_full_name
        ------------------------------------------------------------
        , p_person_id => hr_data.person_id
        , p_last_name => hr_data.last_name
        , p_first_name => hr_data.arabic_name 
        , p_employee_number => hr_data.code        
        , p_date_of_birth => hr_data.date_of_birth
        , p_national_identifier => hr_data.national_identifier
        , p_sex => hr_data.sex
        , p_town_of_birth => hr_data.birth_city
        , p_email_address => hr_data.email
        , p_suffix =>hr_data.insurance_no 
    );
commit;--commit change to database 
            -----------------------------------------
            --controling audit per employees update 
            -----------------------------------------
            begin 
                update xx_swd_employees_upload
                        set  status ='Y'
                where  xx_swd_employees_upload.code=hr_data.code;
                    
                    --dbms_output.put_line('Sucess Added Employee : '||hr_data.LAST_NAME); 
                       
                exception 
                    when others then null;
                                    
            end;    
            commit;                    
    --------------------------------------------------
    ---  Exception for for current iteration of loop    
    --------------------------------------------------
    EXCEPTION  when others  then
            v_errormsg := SQLERRM;
            v_status := 'F';
            
            update xx_swd_employees_upload
                        set  errormsg = v_errormsg, status = v_status
                             where xx_swd_employees_upload.code=hr_data.code; 
        commit;     
    END; --end Calling oracle api 
      
end loop;


END;--END MAIN BLOCK
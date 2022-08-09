/*
			BY : Custommized by atia  2018 
			API Name : Oracle HRMS  Person API
			Version :1.0.0
**/
CREATE OR REPLACE PROCEDURE APPS.XX_VALTRANS_EMPLOYEE_CREATION
AS
   p_validate                       BOOLEAN;
   p_hire_date                      DATE;
   p_business_group_id              NUMBER;
   p_last_name                      VARCHAR2 (200);
   p_sex                            VARCHAR2 (200);
   p_person_type_id                 NUMBER;
   p_per_comments                   VARCHAR2 (200);
   p_date_employee_data_verified    DATE;
   p_date_of_birth                  DATE;
   p_email_address                  VARCHAR2 (200);
   p_employee_number                VARCHAR2 (200);
   p_expense_check_send_to_addres   VARCHAR2 (200);
   p_first_name                     VARCHAR2 (200);
   p_known_as                       VARCHAR2 (200);
   p_marital_status                 VARCHAR2 (200);
   p_middle_names                   VARCHAR2 (200);
   p_nationality                    VARCHAR2 (200);
   p_national_identifier            VARCHAR2 (200);
   p_previous_last_name             VARCHAR2 (200);
   p_registered_disabled_flag       VARCHAR2 (200);
   p_title                          VARCHAR2 (200);
   p_vendor_id                      NUMBER;
   p_work_telephone                 VARCHAR2 (200);
   p_attribute_category             VARCHAR2 (200);
   p_attribute1                     VARCHAR2 (200);
   p_attribute2                     VARCHAR2 (200);
   p_attribute3                     VARCHAR2 (200);
   p_attribute4                     VARCHAR2 (200);
   p_attribute5                     VARCHAR2 (200);
   p_attribute6                     VARCHAR2 (200);
   p_attribute7                     VARCHAR2 (200);
   p_attribute8                     VARCHAR2 (200);
   p_attribute9                     VARCHAR2 (200);
   p_attribute10                    VARCHAR2 (200);
   p_attribute11                    VARCHAR2 (200);
   p_attribute12                    VARCHAR2 (200);
   p_attribute13                    VARCHAR2 (200);
   p_attribute14                    VARCHAR2 (200);
   p_attribute15                    VARCHAR2 (200);
   p_attribute16                    VARCHAR2 (200);
   p_attribute17                    VARCHAR2 (200);
   p_attribute18                    VARCHAR2 (200);
   p_attribute19                    VARCHAR2 (200);
   p_attribute20                    VARCHAR2 (200);
   p_attribute21                    VARCHAR2 (200);
   p_attribute22                    VARCHAR2 (200);
   p_attribute23                    VARCHAR2 (200);
   p_attribute24                    VARCHAR2 (200);
   p_attribute25                    VARCHAR2 (200);
   p_attribute26                    VARCHAR2 (200);
   p_attribute27                    VARCHAR2 (200);
   p_attribute28                    VARCHAR2 (200);
   p_attribute29                    VARCHAR2 (200);
   p_attribute30                    VARCHAR2 (200);
   p_per_information_category       VARCHAR2 (200);
   p_per_information1               VARCHAR2 (200);
   p_per_information2               VARCHAR2 (200);
   p_per_information3               VARCHAR2 (200);
   p_per_information4               VARCHAR2 (200);
   p_per_information5               VARCHAR2 (200);
   p_per_information6               VARCHAR2 (200);
   p_per_information7               VARCHAR2 (200);
   p_per_information8               VARCHAR2 (200);
   p_per_information9               VARCHAR2 (200);
   p_per_information10              VARCHAR2 (200);
   p_per_information11              VARCHAR2 (200);
   p_per_information12              VARCHAR2 (200);
   p_per_information13              VARCHAR2 (200);
   p_per_information14              VARCHAR2 (200);
   p_per_information15              VARCHAR2 (200);
   p_per_information16              VARCHAR2 (200);
   p_per_information17              VARCHAR2 (200);
   p_per_information18              VARCHAR2 (200);
   p_per_information19              VARCHAR2 (200);
   p_per_information20              VARCHAR2 (200);
   p_per_information21              VARCHAR2 (200);
   p_per_information22              VARCHAR2 (200);
   p_per_information23              VARCHAR2 (200);
   p_per_information24              VARCHAR2 (200);
   p_per_information25              VARCHAR2 (200);
   p_per_information26              VARCHAR2 (200);
   p_per_information27              VARCHAR2 (200);
   p_per_information28              VARCHAR2 (200);
   p_per_information29              VARCHAR2 (200);
   p_per_information30              VARCHAR2 (200);
   p_date_of_death                  DATE;
   p_background_check_status        VARCHAR2 (200);
   p_background_date_check          DATE;
   p_blood_type                     VARCHAR2 (200);
   p_correspondence_language        VARCHAR2 (200);
   p_fast_path_employee             VARCHAR2 (200);
   p_fte_capacity                   NUMBER;
   p_honors                         VARCHAR2 (200);
   p_internal_location              VARCHAR2 (200);
   p_last_medical_test_by           VARCHAR2 (200);
   p_last_medical_test_date         DATE;
   p_mailstop                       VARCHAR2 (200);
   p_office_number                  VARCHAR2 (200);
   p_on_military_service            VARCHAR2 (200);
   p_pre_name_adjunct               VARCHAR2 (200);
   p_rehire_recommendation          VARCHAR2 (200);
   p_projected_start_date           DATE;
   p_resume_exists                  VARCHAR2 (200);
   p_resume_last_updated            DATE;
   p_second_passport_exists         VARCHAR2 (200);
   p_student_status                 VARCHAR2 (200);
   p_work_schedule                  VARCHAR2 (200);
   p_suffix                         VARCHAR2 (200);
   p_benefit_group_id               NUMBER;
   p_receipt_of_death_cert_date     DATE;
   p_coord_ben_med_pln_no           VARCHAR2 (200);
   p_coord_ben_no_cvg_flag          VARCHAR2 (200);
   p_coord_ben_med_ext_er           VARCHAR2 (200);
   p_coord_ben_med_pl_name          VARCHAR2 (200);
   p_coord_ben_med_insr_crr_name    VARCHAR2 (200);
   p_coord_ben_med_insr_crr_ident   VARCHAR2 (200);
   p_coord_ben_med_cvg_strt_dt      DATE;
   p_coord_ben_med_cvg_end_dt       DATE;
   p_uses_tobacco_flag              VARCHAR2 (200);
   p_dpdnt_adoption_date            DATE;
   p_dpdnt_vlntry_svce_flag         VARCHAR2 (200);
   p_original_date_of_hire          DATE;
   p_adjusted_svc_date              DATE;
   p_town_of_birth                  VARCHAR2 (200);
   p_region_of_birth                VARCHAR2 (200);
   p_country_of_birth               VARCHAR2 (200);
   p_global_person_id               VARCHAR2 (200);
   p_party_id                       NUMBER;
   p_person_id                      NUMBER;
   p_assignment_id                  NUMBER;
   p_per_object_version_number      NUMBER;
   p_asg_object_version_number      NUMBER;
   p_per_effective_start_date       DATE;
   p_per_effective_end_date         DATE;
   p_full_name                      VARCHAR2 (200);
   p_per_comment_id                 NUMBER;
   p_assignment_sequence            NUMBER;
   p_assignment_number              VARCHAR2 (200);
   p_name_combination_warning       BOOLEAN;
   p_assign_payroll_warning         BOOLEAN;
   p_orig_hire_warning              BOOLEAN;


   l_p_emloyee_number               VARCHAR2 (200);
   l_p_attribute1                   VARCHAR2 (200);
   l_p_attribute2                   VARCHAR2 (200);
   l_p_first_name                   VARCHAR2 (200);
   l_p_per_information1             VARCHAR2 (200);
   l_p_per_information2             VARCHAR2 (200);
   l_p_last_name                    VARCHAR2 (200);
   l_p_hire_date                    DATE;
   l_p_sex                          VARCHAR2 (200);
   --                          l_                   :=   i. "Gender"        ;
   l_p_date_of_birth                DATE;
   l_p_town_of_birth                VARCHAR2 (200);
   l_region_of_birth                VARCHAR2 (200);
   l_p_per_information18            VARCHAR2 (200);
   l_p_marital_status               VARCHAR2 (200);
   l_p_PER_INFORMATION12            VARCHAR2 (200);
   l_p_PER_INFORMATION10            VARCHAR2 (200);
   l_p_email_address                VARCHAR2 (200);
   l_p_attribute3                   VARCHAR2 (200);
   l_p_attribute4                   VARCHAR2 (200);
   l_p_attribute5                   VARCHAR2 (200);
   l_p_attribute6                   VARCHAR2 (200);
   l_p_attribute7                   VARCHAR2 (200);
   l_p_title                        VARCHAR2 (200);

   CURSOR c1
   IS
        SELECT ROWID rowids,
             trim(Employee_Code)   Employee_Code,
             trim(Existing_employee_code)    Existing_employee_code,
             trim(First_Name)   First_Name,
             trim(Father_Name)   Father_Name,
             trim(Grand_Father_Name)  Grand_Father_Name,
             trim(Family_name)   Family_name,
             TO_DATE (trim(Date_of_joining), 'MM/DD/YYYY') Date_of_joining,            
             DECODE (trim(Title),
                     'Mr.', 'MR.',
                     'Mrs.', 'MRS.',
                     'Ms.', 'MS.',
                     'MR.')
                Title,
         DECODE (trim(Gender), 'Male', 'M', 'Female', 'F')   Gender,
             TO_DATE (trim(Date_of_birth), 'MM/DD/YYYY') Date_of_birth,
             trim(Place_of_Birth)  Place_of_Birth,
             trim(Region_of_Birth)  Region_of_Birth,
             (SELECT LOOKUP_CODE
                FROM FND_LOOKUP_VALUES_VL
               WHERE     1 = 1
                     AND LOOKUP_TYPE LIKE 'AE_NATIONALITY'    -- 'AE_RELIGION'
                     AND ENABLED_FLAG LIKE 'Y'
                     AND MEANING = trim(b.Country_of_Birth))
                Country_of_Birth,
             DECODE (trim(Marital_status),  'Married', 'M',  'Single', 'S',  NULL)
                Marital_status,
            decode (b.Nationality , 'Cote d Ivoire', '323' , (SELECT LOOKUP_CODE
                FROM FND_LOOKUP_VALUES_VL
               WHERE     1 = 1
                     AND LOOKUP_TYPE LIKE 'AE_NATIONALITY'    -- 'AE_RELIGION'
                     AND ENABLED_FLAG LIKE 'Y'
                     AND MEANING = trim(b.Nationality)))
                Nationality,
             (SELECT LOOKUP_CODE
                FROM FND_LOOKUP_VALUES_VL
               WHERE     1 = 1
                     AND LOOKUP_TYPE LIKE 'AE_RELIGION'
                     AND ENABLED_FLAG LIKE 'Y'
                     AND MEANING = trim(b.Religion))
                Religion,
             trim(Official_E_Mail_Address)  Official_E_Mail_Address,
             trim(Contract_Type)  Contract_Type,
             trim(Number_of_Children_Count)   Number_of_Children_Count,
             trim(Ticket_Destination)  Ticket_Destination,
             trim(Last_Leave_taken_maximum_days)  Last_Leave_taken_maximum_days,
             trim(Valid_date_for_Last_Leave)   Valid_date_for_Last_Leave,
             DECODE (trim(Undertaking_Joining_Checklist),  'Yes', 'Y',  'No', 'N')
                Undertaking_Joining_Checklist
        FROM XX_VALTRANS_PERSON_UPLOAD b
       WHERE 1 = 1
             AND NOT EXISTS
                    (SELECT *
                       FROM per_all_people_f
                      WHERE b.EXISTING_EMPLOYEE_CODE = attribute1) ;
                    --  AND PERSON_ID IS NULl;
-- AND PERSON_ID IS NULL  and employee_code not in  (  '01101','03854','03973') order by EMPLOYEE_CODE;

BEGIN
   --   MO_GLOBAL.SET_POLICY_CONTEXT ('S', 101);
   fnd_global.apps_initialize (0, 50597, 800);           -- 0 sysadmin user id

   --   MO_GLOBAL.INIT ('PER');

   FOR i IN c1
   LOOP
      /* Valied   Fields  */



      BEGIN
         IF i.NATIONALITY IS NULL
         THEN
            DBMS_OUTPUT.put_line (
               'Nationality is not available for the employee_code  '
               || i.employee_code);

            raise_application_error (
               -20001,
                  'An error was encountered - '
               || SQLCODE
               || ' -ERROR- '
               || SQLERRM);
         END IF;


         IF i.RELIGION IS NULL
         THEN
            DBMS_OUTPUT.put_line (
               'Religion is not available for the employee_code  '
               || i.employee_code);

            raise_application_error (
               -20001,
                  'An error was encountered - '
               || SQLCODE
               || ' -ERROR- '
               || SQLERRM);
         END IF;


         IF i.FAMILY_NAME IS NULL
         THEN
            DBMS_OUTPUT.put_line (
               'FAMILY_NAME is not available for the employee_code  '
               || i.employee_code);

            raise_application_error (
               -20001,
                  'An error was encountered - '
               || SQLCODE
               || ' -ERROR- '
               || SQLERRM);
         END IF;


         IF i.DATE_OF_JOINING IS NULL
         THEN
            DBMS_OUTPUT.put_line (
               'DATE_OF_JOINING is not available for the employee_code  '
               || i.employee_code);

            raise_application_error (
               -20001,
                  'An error was encountered - '
               || SQLCODE
               || ' -ERROR- '
               || SQLERRM);
         END IF;



         IF i.TITLE IS NULL
         THEN
            DBMS_OUTPUT.put_line (
               'TITLE is not available for the employee_code  '
               || i.employee_code);

            raise_application_error (
               -20001,
                  'An error was encountered - '
               || SQLCODE
               || ' -ERROR- '
               || SQLERRM);
         END IF;



         l_p_emloyee_number := i.Employee_Code;
         l_p_attribute1 := i.Existing_employee_code;
         l_p_attribute2 := i.contract_type;
         l_p_attribute3 := i.Number_of_Children_Count;
         l_p_attribute4 := i.Ticket_Destination;
         l_p_attribute5 := i.Last_Leave_taken_maximum_days;
         l_p_attribute6 := i.Valid_date_for_Last_Leave;
         l_p_attribute7 := i.Undertaking_Joining_Checklist;
         l_p_first_name := i.First_Name;
         l_p_per_information1 := i.Father_Name;
         l_p_per_information2 := i.Grand_Father_Name;
         l_p_per_information12 := i.Country_of_Birth;
         l_p_PER_INFORMATION18 := i.Nationality;
         l_p_PER_INFORMATION10 := i.Religion;
         l_p_title := i.Title;


         l_p_last_name := i.Family_name;
         l_p_hire_date := i.Date_of_joining;
         l_p_sex := i.Gender;
         --                          l_                   :=         ;
         l_p_date_of_birth := i.Date_of_birth;
         l_p_town_of_birth := i.Place_of_Birth;
         l_region_of_birth := i.Region_of_Birth;

         l_p_marital_status := i.Marital_status;

         l_p_email_address := i.Official_E_Mail_Address;
         --                                            l_                   :=   i."Contract Type"   ;



         /* Null Fields  */
         /* Value From USER */

         p_employee_number := l_p_emloyee_number;
         p_attribute1 := l_p_attribute1;
         p_attribute2 := l_p_attribute2;
         p_attribute3 := l_p_attribute3;
         p_attribute4 := l_p_attribute4;
         p_attribute5 := l_p_attribute5;
         p_attribute6 := l_p_attribute6;
         p_attribute7 := l_p_attribute7;
         p_first_name := l_p_first_name;
         p_per_information1 := l_p_per_information1;
         p_per_information2 := l_p_per_information2;
         p_per_information18 := l_p_per_information18;
         p_per_information12 := l_p_PER_INFORMATION12;
         p_per_information10 := l_p_PER_INFORMATION10;
         p_hire_date := l_p_hire_date;
         p_last_name := l_p_last_name;
         p_sex := l_p_sex;
         p_date_of_birth := l_p_date_of_birth;
         p_town_of_birth := l_p_town_of_birth;
         p_region_of_birth := l_region_of_birth;
         p_email_address := l_p_email_address;
         p_marital_status := l_p_marital_status;
         p_per_effective_start_date := l_p_hire_date;
         p_title := l_p_title;

         /*   hard Corder Value */

         p_validate := FALSE;
         p_business_group_id := 81;
         --    p_person_type_id := 1120;
         p_person_type_id := 2118;                        -- Valtrans Employee
         -- P_KNOWN_AS := 'EMPLOYEE';
         --      p_middle_names := c1_emp.middle_names;
         --      p_national_identifier := c1_emp.national_identifier;
         --      p_registered_disabled_flag := 'Y';
         p_coord_ben_no_cvg_flag := 'N';
         p_dpdnt_vlntry_svce_flag := 'N';



         /* Null Value */
         p_per_comments := NULL;
         p_date_employee_data_verified := NULL;
         p_expense_check_send_to_addres := NULL;
         p_known_as := NULL;
         p_nationality := NULL;
         p_previous_last_name := NULL;
         --      p_title := NULL;
         p_vendor_id := NULL;
         p_work_telephone := NULL;
         p_attribute_category := NULL;
         -- p_attribute2 := NULL;
         p_attribute8 := NULL;
         p_attribute9 := NULL;
         p_attribute10 := NULL;
         p_attribute11 := NULL;
         p_attribute12 := NULL;
         p_attribute13 := NULL;
         p_attribute14 := NULL;
         p_attribute15 := NULL;
         p_attribute16 := NULL;
         p_attribute17 := NULL;
         p_attribute18 := NULL;
         p_attribute19 := NULL;
         p_attribute20 := NULL;
         p_attribute21 := NULL;
         p_attribute22 := NULL;
         p_attribute23 := NULL;
         p_attribute24 := NULL;
         p_attribute25 := NULL;
         p_attribute26 := NULL;
         p_attribute27 := NULL;
         p_attribute28 := NULL;
         p_attribute29 := NULL;
         p_attribute30 := NULL;
         p_per_information_category := NULL;
         p_per_information3 := NULL;
         p_per_information4 := NULL;
         p_per_information5 := NULL;
         p_per_information6 := NULL;
         p_per_information7 := NULL;
         p_per_information8 := NULL;
         p_per_information9 := NULL;
         p_per_information11 := NULL;
         p_per_information13 := NULL;
         p_per_information14 := NULL;
         p_per_information15 := NULL;
         p_per_information16 := NULL;
         p_per_information17 := NULL;
         p_per_information19 := NULL;
         p_per_information20 := NULL;
         p_per_information21 := NULL;
         p_per_information22 := NULL;
         p_per_information23 := NULL;
         p_per_information24 := NULL;
         p_per_information25 := NULL;
         p_per_information26 := NULL;
         p_per_information27 := NULL;
         p_per_information28 := NULL;
         p_per_information29 := NULL;
         p_per_information30 := NULL;
         p_date_of_death := NULL;
         p_background_check_status := NULL;
         p_background_date_check := NULL;
         p_blood_type := NULL;
         p_correspondence_language := NULL;
         p_fast_path_employee := NULL;
         p_fte_capacity := NULL;
         p_honors := NULL;
         p_internal_location := NULL;
         p_last_medical_test_by := NULL;
         p_last_medical_test_date := NULL;
         p_mailstop := NULL;
         p_office_number := NULL;
         p_on_military_service := NULL;
         p_pre_name_adjunct := NULL;
         p_rehire_recommendation := NULL;
         p_projected_start_date := NULL;
         p_resume_exists := NULL;
         p_resume_last_updated := NULL;
         p_second_passport_exists := NULL;
         p_student_status := NULL;
         p_work_schedule := NULL;
         p_suffix := NULL;
         p_benefit_group_id := NULL;
         p_receipt_of_death_cert_date := NULL;
         p_coord_ben_med_pln_no := NULL;
         p_coord_ben_med_ext_er := NULL;
         p_coord_ben_med_pl_name := NULL;
         p_coord_ben_med_insr_crr_name := NULL;
         p_coord_ben_med_insr_crr_ident := NULL;
         p_coord_ben_med_cvg_strt_dt := NULL;
         p_coord_ben_med_cvg_end_dt := NULL;
         p_uses_tobacco_flag := NULL;
         p_dpdnt_adoption_date := NULL;
         p_original_date_of_hire := NULL;
         p_adjusted_svc_date := NULL;
         p_country_of_birth := NULL;
         p_global_person_id := NULL;
         p_party_id := NULL;
         p_person_id := NULL;
         p_assignment_id := NULL;
         p_per_object_version_number := NULL;
         p_asg_object_version_number := NULL;
         p_per_effective_end_date := NULL;
         p_full_name := NULL;
         p_per_comment_id := NULL;
         p_assignment_sequence := NULL;
         p_assignment_number := NULL;
         p_name_combination_warning := NULL;
         p_assign_payroll_warning := NULL;
         p_orig_hire_warning := NULL;



         apps.hr_employee_api.create_employee (
            p_validate,
            p_hire_date,
            p_business_group_id,
            p_last_name,
            p_sex,
            p_person_type_id,
            p_per_comments,
            p_date_employee_data_verified,
            p_date_of_birth,
            p_email_address,
            p_employee_number,
            p_expense_check_send_to_addres,
            p_first_name,
            p_known_as,
            p_marital_status,
            p_middle_names,
            p_nationality,
            p_national_identifier,
            p_previous_last_name,
            p_registered_disabled_flag,
            p_title,
            p_vendor_id,
            p_work_telephone,
            p_attribute_category,
            p_attribute1,
            p_attribute2,
            p_attribute3,
            p_attribute4,
            p_attribute5,
            p_attribute6,
            p_attribute7,
            p_attribute8,
            p_attribute9,
            p_attribute10,
            p_attribute11,
            p_attribute12,
            p_attribute13,
            p_attribute14,
            p_attribute15,
            p_attribute16,
            p_attribute17,
            p_attribute18,
            p_attribute19,
            p_attribute20,
            p_attribute21,
            p_attribute22,
            p_attribute23,
            p_attribute24,
            p_attribute25,
            p_attribute26,
            p_attribute27,
            p_attribute28,
            p_attribute29,
            p_attribute30,
            p_per_information_category,
            p_per_information1,
            p_per_information2,
            p_per_information3,
            p_per_information4,
            p_per_information5,
            p_per_information6,
            p_per_information7,
            p_per_information8,
            p_per_information9,
            p_per_information10,
            p_per_information11,
            p_per_information12,
            p_per_information13,
            p_per_information14,
            p_per_information15,
            p_per_information16,
            p_per_information17,
            p_per_information18,
            p_per_information19,
            p_per_information20,
            p_per_information21,
            p_per_information22,
            p_per_information23,
            p_per_information24,
            p_per_information25,
            p_per_information26,
            p_per_information27,
            p_per_information28,
            p_per_information29,
            p_per_information30,
            p_date_of_death,
            p_background_check_status,
            p_background_date_check,
            p_blood_type,
            p_correspondence_language,
            p_fast_path_employee,
            p_fte_capacity,
            p_honors,
            p_internal_location,
            p_last_medical_test_by,
            p_last_medical_test_date,
            p_mailstop,
            p_office_number,
            p_on_military_service,
            p_pre_name_adjunct,
            p_rehire_recommendation,
            p_projected_start_date,
            p_resume_exists,
            p_resume_last_updated,
            p_second_passport_exists,
            p_student_status,
            p_work_schedule,
            p_suffix,
            p_benefit_group_id,
            p_receipt_of_death_cert_date,
            p_coord_ben_med_pln_no,
            p_coord_ben_no_cvg_flag,
            p_coord_ben_med_ext_er,
            p_coord_ben_med_pl_name,
            p_coord_ben_med_insr_crr_name,
            p_coord_ben_med_insr_crr_ident,
            p_coord_ben_med_cvg_strt_dt,
            p_coord_ben_med_cvg_end_dt,
            p_uses_tobacco_flag,
            p_dpdnt_adoption_date,
            p_dpdnt_vlntry_svce_flag,
            p_original_date_of_hire,
            p_adjusted_svc_date,
            p_town_of_birth,
            p_region_of_birth,
            p_country_of_birth,
            p_global_person_id,
            p_party_id,
            p_person_id,
            p_assignment_id,
            p_per_object_version_number,
            p_asg_object_version_number,
            p_per_effective_start_date,
            p_per_effective_end_date,
            p_full_name,
            p_per_comment_id,
            p_assignment_sequence,
            p_assignment_number,
            p_name_combination_warning,
            p_assign_payroll_warning,
            p_orig_hire_warning);


         UPDATE XX_VALTRANS_PERSON_UPLOAD
            SET person_id = p_person_id
          WHERE ROWID = i.rowids;

         COMMIT;
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line ('EMPLOYEE CODE' || i.employee_code);
            DBMS_OUTPUT.put_line ('THE ERRORMSG' || SQLERRM || SQLCODE);
      END;
   END LOOP;



   COMMIT;



   DBMS_OUTPUT.put_line ('THE ERRORMSG' || SQLERRM || SQLCODE);
END;
/
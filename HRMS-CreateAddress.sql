-------------------------------------------------------------------------------
---   Create Address Developed by atia 2018  ver 1.0
-------------------------------------------------------------------------------
DECLARE
   v_address_error             VARCHAR2 (400);
   p_validate                  BOOLEAN;
   p_effective_date            DATE;
   p_pradd_ovlapval_override   BOOLEAN;
   p_validate_county           BOOLEAN;
   p_person_id                 NUMBER;
   p_primary_flag              VARCHAR2 (200);
   p_style                     VARCHAR2 (200);
   p_date_from                 DATE;
   p_date_to                   DATE;
   p_address_type              VARCHAR2 (200);
   p_comments                  LONG;
   p_address_line1             VARCHAR2 (200);
   p_address_line2             VARCHAR2 (200);
   p_address_line3             VARCHAR2 (200);
   p_town_or_city              VARCHAR2 (200);
   p_region_1                  VARCHAR2 (200);
   p_region_2                  VARCHAR2 (200);
   p_region_3                  VARCHAR2 (200);
   p_postal_code               VARCHAR2 (200);
   p_country                   VARCHAR2 (200);
   p_telephone_number_1        VARCHAR2 (200);
   p_telephone_number_2        VARCHAR2 (200);
   p_telephone_number_3        VARCHAR2 (200);
   p_addr_attribute_category   VARCHAR2 (200);
   p_addr_attribute1           VARCHAR2 (200);
   p_addr_attribute2           VARCHAR2 (200);
   p_addr_attribute3           VARCHAR2 (200);
   p_addr_attribute4           VARCHAR2 (200);
   p_addr_attribute5           VARCHAR2 (200);
   p_addr_attribute6           VARCHAR2 (200);
   p_addr_attribute7           VARCHAR2 (200);
   p_addr_attribute8           VARCHAR2 (200);
   p_addr_attribute9           VARCHAR2 (200);
   p_addr_attribute10          VARCHAR2 (200);
   p_addr_attribute11          VARCHAR2 (200);
   p_addr_attribute12          VARCHAR2 (200);
   p_addr_attribute13          VARCHAR2 (200);
   p_addr_attribute14          VARCHAR2 (200);
   p_addr_attribute15          VARCHAR2 (200);
   p_addr_attribute16          VARCHAR2 (200);
   p_addr_attribute17          VARCHAR2 (200);
   p_addr_attribute18          VARCHAR2 (200);
   p_addr_attribute19          VARCHAR2 (200);
   p_addr_attribute20          VARCHAR2 (200);
   p_add_information13         VARCHAR2 (200);
   p_add_information14         VARCHAR2 (200);
   p_add_information15         VARCHAR2 (200);
   p_add_information16         VARCHAR2 (200);
   p_add_information17         VARCHAR2 (200);
   p_add_information18         VARCHAR2 (200);
   p_add_information19         VARCHAR2 (200);
   p_add_information20         VARCHAR2 (200);
   p_party_id                  NUMBER;
   p_address_id                NUMBER;
   p_object_version_number     NUMBER;

   CURSOR c1
   IS
      SELECT *
        FROM XX_ADD_TEMP
       WHERE valid_flag is null
       --AND   SER BETWEEN 1002 AND 4025 ;
       AND   EMP_NO <>'1838';
                                
BEGIN
   FOR c1_rec IN c1
   LOOP
      p_validate := FALSE;
      
      
      SELECT PERSON_ID 
      INTO   p_person_id
      FROM   PER_ALL_PEOPLE_F WHERE EMPLOYEE_NUMBER=TO_NUMBER(C1_REC.EMP_NO);


      SELECT effective_start_date
        INTO p_effective_date
        FROM per_all_people_f
       WHERE employee_number = c1_rec.emp_no;

--  P_EFFECTIVE_DATE := SYSDATE;
      p_pradd_ovlapval_override := NULL;
      p_validate_county := NULL;
      p_primary_flag := 'Y';
      p_style := 'Egypt';

      SELECT effective_start_date
        INTO p_date_from
        FROM per_all_people_f
       WHERE employee_number = c1_rec.emp_no;

      p_date_to := NULL;
      p_address_type := NULL;
      p_comments := NULL;
      p_address_line1 := c1_rec.add_line1; --building num--
      p_address_line2 := c1_rec.add_line2; -- Street --
      p_address_line3 := NULL;
      p_town_or_city := c1_rec.city;
      p_region_1 := c1_rec.region; -- area--- 
      p_region_2 := NULL;
      p_region_3 := NULL;
      p_postal_code := NULL;
      p_country   := 'уеб';

      /*SELECT territory_code
        INTO p_country
        FROM fnd_territories_vl
       WHERE TRIM (UPPER (territory_short_name)) =
                                                 TRIM (UPPER (c1_rec.country));*/

      p_telephone_number_1 := NULL;
      p_telephone_number_2 := NULL;
      p_telephone_number_3 := NULL;
      p_addr_attribute_category := NULL;
      p_addr_attribute1  := NULL;
      p_addr_attribute2  := NULL;
      p_addr_attribute3  := NULL;
      p_addr_attribute4  := NULL;
      p_addr_attribute5  := NULL;
      p_addr_attribute6  := NULL;
      p_addr_attribute7  := NULL;
      p_addr_attribute8  := NULL;
      p_addr_attribute9  := NULL;
      p_addr_attribute10 := NULL;
      p_addr_attribute11 := NULL;
      p_addr_attribute12 := NULL;
      p_addr_attribute13 := NULL;
      p_addr_attribute14 := NULL;
      p_addr_attribute15 := NULL;
      p_addr_attribute16 := NULL;
      p_addr_attribute17 := NULL;
      p_addr_attribute18 := NULL;
      p_addr_attribute19 := NULL;
      p_addr_attribute20 := NULL;
      p_add_information13:= NULL;
      p_add_information14:= NULL;
      p_add_information15:= NULL;
      p_add_information16:= NULL;
      p_add_information17:= NULL;
      p_add_information18:= NULL;
      p_add_information19:= NULL;
      p_add_information20:= NULL;
      p_party_id         := NULL;
      p_address_id       := NULL;
      p_object_version_number := NULL;

      BEGIN
         apps.hr_person_address_api.create_person_address
                                                  (p_validate,
                                                   p_effective_date,
                                                   p_pradd_ovlapval_override,
                                                   p_validate_county,
                                                   p_person_id,
                                                   p_primary_flag,
                                                   p_style,
                                                   p_date_from,
                                                   p_date_to,
                                                   p_address_type,
                                                   p_comments,
                                                   p_address_line1,
                                                   p_address_line2,
                                                   p_address_line3,
                                                   p_town_or_city,
                                                   p_region_1,
                                                   p_region_2,
                                                   p_region_3,
                                                   p_postal_code,
                                                   p_country,
                                                   p_telephone_number_1,
                                                   p_telephone_number_2,
                                                   p_telephone_number_3,
                                                   p_addr_attribute_category,
                                                   p_addr_attribute1,
                                                   p_addr_attribute2,
                                                   p_addr_attribute3,
                                                   p_addr_attribute4,
                                                   p_addr_attribute5,
                                                   p_addr_attribute6,
                                                   p_addr_attribute7,
                                                   p_addr_attribute8,
                                                   p_addr_attribute9,
                                                   p_addr_attribute10,
                                                   p_addr_attribute11,
                                                   p_addr_attribute12,
                                                   p_addr_attribute13,
                                                   p_addr_attribute14,
                                                   p_addr_attribute15,
                                                   p_addr_attribute16,
                                                   p_addr_attribute17,
                                                   p_addr_attribute18,
                                                   p_addr_attribute19,
                                                   p_addr_attribute20,
                                                   p_add_information13,
                                                   p_add_information14,
                                                   p_add_information15,
                                                   p_add_information16,
                                                   p_add_information17,
                                                   p_add_information18,
                                                   p_add_information19,
                                                   p_add_information20,
                                                   p_party_id,
                                                   p_address_id,
                                                   p_object_version_number
                                                  );
         COMMIT;

         UPDATE xx_add_temp
            SET error_msg = NULL,
                valid_flag = 'Y'
          WHERE emp_no = c1_rec.emp_no;
      EXCEPTION
         WHEN OTHERS
         THEN
            v_address_error := SQLERRM;

            UPDATE xx_add_temp
               SET error_msg = error_msg || '     ' || v_address_error,
                   valid_flag = 'N'
             WHERE emp_no = c1_rec.emp_no;

            COMMIT;
      END;
   END LOOP;
END;
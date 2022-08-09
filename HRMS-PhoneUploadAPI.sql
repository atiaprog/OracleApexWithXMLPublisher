------------------------------------------------------------------
----		BY : Custommized by atia  2018 
----		API Name : Oracle HRMS Phone Upload  API
---			Version :1.1.0
declare
   p_date_from               DATE;
   p_date_to                 DATE;
   p_phone_type              VARCHAR2 (200);
   p_phone_number            VARCHAR2 (200);
   p_parent_id               NUMBER;
   p_parent_table            VARCHAR2 (200);
   p_attribute_category      VARCHAR2 (200);
   p_attribute1              VARCHAR2 (200);
   p_attribute2              VARCHAR2 (200);
   p_attribute3              VARCHAR2 (200);
   p_attribute4              VARCHAR2 (200);
   p_attribute5              VARCHAR2 (200);
   p_attribute6              VARCHAR2 (200);
   p_attribute7              VARCHAR2 (200);
   p_attribute8              VARCHAR2 (200);
   p_attribute9              VARCHAR2 (200);
   p_attribute10             VARCHAR2 (200);
   p_attribute11             VARCHAR2 (200);
   p_attribute12             VARCHAR2 (200);
   p_attribute13             VARCHAR2 (200);
   p_attribute14             VARCHAR2 (200);
   p_attribute15             VARCHAR2 (200);
   p_attribute16             VARCHAR2 (200);
   p_attribute17             VARCHAR2 (200);
   p_attribute18             VARCHAR2 (200);
   p_attribute19             VARCHAR2 (200);
   p_attribute20             VARCHAR2 (200);
   p_attribute21             VARCHAR2 (200);
   p_attribute22             VARCHAR2 (200);
   p_attribute23             VARCHAR2 (200);
   p_attribute24             VARCHAR2 (200);
   p_attribute25             VARCHAR2 (200);
   p_attribute26             VARCHAR2 (200);
   p_attribute27             VARCHAR2 (200);
   p_attribute28             VARCHAR2 (200);
   p_attribute29             VARCHAR2 (200);
   p_attribute30             VARCHAR2 (200);
   p_validate                BOOLEAN;
   p_effective_date          DATE;
   p_party_id                NUMBER;
   p_validity                VARCHAR2 (200);
   p_object_version_number   NUMBER;
   p_phone_id                NUMBER;
   v_pid                     NUMBER;
   v_partyid                 NUMBER;
   v_count                   NUMBER;
   x_msg_count               NUMBER;
   v_status                  VARCHAR2 (100);
   v_ph_type                 VARCHAR2 (100);
   errm                      VARCHAR2 (4000);
   
   

   CURSOR c1
   IS
      SELECT *
        FROM xx_phone_upload
        where code='748';



BEGIN


 fnd_global.apps_initialize (0, 50637, 800); 


   FOR i IN c1
   LOOP
      BEGIN
         errm := '';

         SELECT DISTINCT person_id
                    INTO v_pid
                    FROM per_all_people_f
                   WHERE employee_number = i.code;

         v_status := 'T';
     
    EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_status := 'E';
            errm :=  SQLERRM ;
            
           update xx_phone_upload
                set status=v_status,
                    errormsg=errm
            where person_id=i.person_id;
                    
      END;

      IF v_status = 'S'
      THEN
         BEGIN
            SELECT DISTINCT party_id
                       INTO v_partyid
                       FROM per_all_people_f
                      WHERE employee_number = i.code;

            v_status := 'S';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_status := 'E';
               errm := 'party_id :' || SQLERRM || SQLCODE || errm;
               update xx_phone_upload
                set status=v_status,
                    errormsg=errm
                where person_id=i.person_id;
         END;
      END IF;

      IF v_status = 'S'
      THEN
         BEGIN
            SELECT lookup_code
              INTO v_ph_type
              FROM fnd_lookups
             WHERE lookup_type LIKE 'JTA_EC_PHONE_TYPE';
               

            v_status := 'S';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_status := 'E';
               errm := 'Phone Type :' || SQLERRM || SQLCODE || errm;
              update xx_phone_upload
                set status=v_status,
                    errormsg=errm
                where person_id=i.person_id;
         END;
      END IF;

      SELECT COUNT (1)
        INTO v_count
        FROM per_phones
       WHERE parent_id = v_pid
         AND phone_number = i.phone;
         

      IF (v_count > 0)
      THEN
         DBMS_OUTPUT.put_line ('Already exist');
         errm := 'Already exists' || errm;
         v_status := 'E';
      END IF;

      IF v_count = 0 AND v_status = 'S'
      THEN
         DBMS_OUTPUT.put_line ('inside block ---');
         ---v_status := 'S';
         p_date_from := to_date(sysdate,'DD-MON-YYYY');
         p_date_to :=null;
         p_phone_type := 'M';                        
         p_phone_number := i.phone;
         p_parent_id := v_pid;
         p_parent_table := 'PER_ALL_PEOPLE_F';
         p_attribute_category := NULL;
         p_attribute1 := NULL;
         p_attribute2 := NULL;
         p_attribute3 := NULL;
         p_attribute4 := NULL;
         p_attribute5 := NULL;
         p_attribute6 := NULL;
         p_attribute7 := NULL;
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
         p_validate := FALSE;
         p_effective_date := SYSDATE;
         p_party_id := v_partyid;
         p_validity := NULL;
         p_object_version_number := NULL;
         p_phone_id := NULL;

         BEGIN
            apps.hr_phone_api.create_phone (p_date_from,
                                            p_date_to,
                                            p_phone_type,
                                            p_phone_number,
                                            p_parent_id,
                                            p_parent_table,
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
                                            p_validate,
                                            p_effective_date,
                                            p_party_id,
                                            p_validity,
                                            p_object_version_number,
                                            p_phone_id
                                           );
         EXCEPTION
            WHEN OTHERS
            THEN
               v_status := 'E';
               errm := SQLERRM || SQLCODE || errm;
               update xx_phone_upload
                set status=v_status,
                    errormsg=errm
                where person_id=i.person_id;
               
         END;
      -- ROLLBACK;
      END IF;

      IF (v_status != 'S')
      THEN
         errm := errm || '-' || i.code ;
      END IF;

     

      UPDATE xx_phone_upload
         SET status = v_status,
             errormsg = errm
       WHERE person_id = i.person_id;
         

   COMMIT;
   END LOOP;
END;
/


------------------------------------------------------------
--      Create Phone API  ver 1.1 on ebs R12
---     Developed by atia  2018    ver 1.0
------------------------------------------------------------
set serveroutput on;
declare  
   l_update_mode                  varchar2(100)   
  ;l_date_from                    date :=TO_DATE ('20-DEC-2018')
  ;l_phone_type                   varchar2(30) :='M' --indicate type of phone number (M) for mobile         
  ;l_parent_id                    number (38)         
  ;l_parent_table                 varchar2(50) :='PER_ALL_PEOPLE_F'         
  ;l_validate                     boolean :=false     
  ;l_effective_date               date := TO_DATE ('20-DEC-2018')--Required         
----------------------------------------------------------------------------
--  OUT  Parameter  
    ;l_phone_id                  PER_PHONES.PHONE_ID%TYPE                 --Required
    ;l_object_version_number         PER_PHONES.OBJECT_VERSION_NUMBER%TYPE     --Required
-----------------------------------------------------------------------------
--- Error Indictor Per Row 
 ;v_errormsg    varchar2(2000)
 ;v_status      varchar2(1);

--Define Custom Cursor for Custom Interface Table
    cursor c1 is 
        select person_id ,code,last_name,trim(phone) phone
            from xx_phone_upload;
            
begin  

  for c2 in c1 loop    
      
       l_object_version_number:=null; 
       l_phone_id:=null;
        
        --Get Effective Date from  it  
           begin   
            hr_phone_api.create_or_update_phone(
                p_date_from=> l_date_from,
                p_phone_type=> l_phone_type,
                p_phone_number=> c2.phone,
                p_parent_id=> c2.person_id ,
                p_parent_table=> l_parent_table,
                p_effective_date=> l_effective_date,
                p_update_mode=>l_update_mode,
                p_validate =>l_validate,
                -- Output data elements
                ----------------------------------
                p_phone_id     => l_phone_id,
                p_object_version_number   => l_object_version_number
                ------------------------------------
            );          
        commit;
            
            update xx_phone_upload 
               set errormsg=null,
                    status='Y'
                where   person_id=l_parent_id;
    
                commit;--updated the current row iteration 
         
    exception when others  then  
                v_errormsg:=sqlerrm;
                v_status:='E';
        
                update xx_phone_upload 
                    set errormsg=v_errormsg,
                    status=v_status
                    where   person_id=l_parent_id;
                commit;
      
        end;
    
    end loop;

end;
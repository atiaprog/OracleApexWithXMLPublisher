-----------------------------------------------------
--   Purpose  : Delete All Phones Numbers  with employee
---  Developed by atia 2018 version 1.0   
-----------------------------------------------------
set serveroutput on;
declare 
   l_validate                          boolean default false
  ;l_phone_id                          number
  ;l_object_version_number             number;
  v_errormsg                           varchar2(2000);
  
  --Cursor for current records 
  cursor c1 is
        select phone_id,object_version_number
                    from per_phones;
  
begin  
  
    for c2 in c1 loop
            begin
                  HR_PHONE_API.DELETE_PHONE(
                  p_validate=>l_validate,
                  p_phone_id=>c2.phone_id,
                  p_object_version_number=>c2.object_version_number
                  );
                commit;
                dbms_output.put_line('Delete : '||c2.phone_id || ' Deleted Sucess');            
   
            exception 
                when others then  
                v_errormsg:=sqlerrm;
                dbms_output.put_line('Delete : '||v_errormsg || ' Deleted Sucess');            

         end;    
         end loop;  
end;
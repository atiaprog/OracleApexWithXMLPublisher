-------------------------------------------------------------
-- Update Address API  Oracle HRMS BY atia  2018 ver 1.1
-------------------------------------------------------------
DECLARE
--Mandotory Varibles
   l_validate                      boolean :=false  --requied
  ;l_effective_date               date  :=to_date('18-DEC-2018','DD-MON-YYYY')     --required
  ;l_validate_county              boolean :=null  --required 
  ;l_address_id                   number    --required on update address 
  ;l_object_version_number        number   -- in out parameter  and required 
---------------------------------------------------------------------  
  ;l_date_from                    date   
  ;l_date_to                      date    
  ;l_address_type                 varchar2 (500)
  ;l_comments                     long
  ;l_address_line1                varchar2 (500)
  ;l_address_line2                varchar2 (500)
  ;l_address_line3                varchar2 (500)
  ;l_town_or_city                 varchar2 (500)
  ;l_region_1                     varchar2 (500)
  ;l_region_2                     varchar2 (500)
  ;l_region_3                     varchar2 (500)
  ;l_postal_code                  varchar2 (500)
  ;l_country                      varchar2 (500) :='Egypt'
  ;l_telephone_number_1           varchar2 (500)
  ;l_telephone_number_2           varchar2 (500)
  ;l_telephone_number_3           varchar2 (500)
  ;l_addr_attribute_category      varchar2 (500)
  ;l_addr_attribute1              varchar2 (500)
  ;l_addr_attribute2              varchar2 (500)
  ;l_addr_attribute3              varchar2 (500)
  ;l_addr_attribute4              varchar2 (500)
  ;l_addr_attribute5              varchar2 (500)
  ;l_addr_attribute6              varchar2 (500)
  ;l_addr_attribute7              varchar2 (500)
  ;l_addr_attribute8              varchar2 (500)
  ;l_addr_attribute9              varchar2 (500)
  ;l_addr_attribute10             varchar2 (500)
  ;l_addr_attribute11             varchar2 (500)
  ;l_addr_attribute12             varchar2 (500)
  ;l_addr_attribute13             varchar2 (500)
  ;l_addr_attribute14             varchar2 (500)
  ;l_addr_attribute15             varchar2 (500)
  ;l_addr_attribute16             varchar2 (500)
  ;l_addr_attribute17             varchar2 (500)
  ;l_addr_attribute18             varchar2 (500)
  ;l_addr_attribute19             varchar2 (500)
  ;l_addr_attribute20             varchar2 (500)
  ;l_add_information13            varchar2 (500)
  ;l_add_information14            varchar2 (500)
  ;l_add_information15            varchar2 (500)
  ;l_add_information16            varchar2 (500)
  ;l_add_information17            varchar2 (500)
  ;l_add_information18            varchar2 (500)
  ;l_add_information19            varchar2 (500)
  ;l_add_information20            varchar2 (500)
  ;l_party_id                     number
  -------------------------------------------------------------------------
  --used in Address  Creation Procedure 
  ;l_pradd_ovlapval_override            boolean :=null
  ;l_primary_flag                       varchar2(20) :='Y'
  ;l_style                              varchar2(500) :='EG_GLB'
  ;l_PERSON_ID                          number;
  --------------------------------------------------------------------------
   v_errormsg    varchar2(2000);
   v_status      varchar2(2);
   v_counter     number;
   ---------------------------------------------out parameter 
   v_object_number number;
   v_address_id   number; 
   v_object_version_number number; --                  
--define Cursor for current custom interface table  
cursor c2  
        is 
          select trim(code) code,
            trim(lastname) lastname,trim(region) region,
                trim(state) state ,trim(city) city,trim(line1) line1
                    from xx_address_interface ;              

begin
  
    for adddata in c2 loop
   
    begin
    --Assing Correct version number to api    
    select max(papf.object_version_number)
            into l_object_version_number 
                from per_all_people_f papf
        where  papf.employee_number=adddata.code;
    end; 
    
    --testing for insureing their are value for address or not     
     begin 
      select
                count(papf.employee_number)  into v_counter
           from 
                PER_ALL_PEOPLE_F PAPF,
                per_addresses pa,
                FND_TERRITORIES_TL T ,
                FND_DESCR_FLEX_CONTEXTS_TL TL ,
                HR_LOOKUPS HL1 
            where 
                PAPF.PERSON_ID                = PA.PERSON_ID
                and PA.COUNTRY                = T.TERRITORY_CODE (+)
                AND PA.STYLE                  =TL.DESCRIPTIVE_FLEX_CONTEXT_CODE
                AND TL.APPLICATION_ID         = 800
                AND TL.DESCRIPTIVE_FLEXFIELD_NAME = 'Address Structure'
                AND TL.LANGUAGE                   = userenv('LANG')
                AND HL1.LOOKUP_TYPE(+)            = 'ADDRESS_TYPE'
                AND PA.ADDRESS_TYPE               = HL1.LOOKUP_CODE (+)
                AND T.LANGUAGE (+)                = USERENV('LANG')
                and papf.employee_number=adddata.code
                        and to_number(to_char(PAPF.effective_end_date,'RRRR'))>4000;
        end;    
    --set the effective start data 
        begin 
         SELECT papf.effective_start_date
                into l_date_from
              FROM per_all_people_f papf
         WHERE employee_number = adddata.code
                    and to_number(to_char(PAPF.effective_end_date,'RRRR'))>4000;
        end;
    --assing address id to local varible 
    begin 
    select
                PA.address_id into l_address_id
           from 
                PER_ALL_PEOPLE_F PAPF,
                per_addresses pa,
                FND_TERRITORIES_TL T ,
                FND_DESCR_FLEX_CONTEXTS_TL TL ,
                HR_LOOKUPS HL1 
            where 
                PAPF.PERSON_ID                = PA.PERSON_ID
                and PA.COUNTRY                = T.TERRITORY_CODE (+)
                AND PA.STYLE                  =TL.DESCRIPTIVE_FLEX_CONTEXT_CODE
                AND TL.APPLICATION_ID         = 800
                AND TL.DESCRIPTIVE_FLEXFIELD_NAME = 'Address Structure'
                AND TL.LANGUAGE                   = userenv('LANG')
                AND HL1.LOOKUP_TYPE(+)            = 'ADDRESS_TYPE'
                AND PA.ADDRESS_TYPE               = HL1.LOOKUP_CODE (+)
                AND T.LANGUAGE (+)                = USERENV('LANG')
                and papf.employee_number=adddata.code
                and to_number(to_char(PAPF.effective_end_date,'RRRR'))>4000;
        exception
            when no_data_found then  
            l_address_id:=null;
            when others  then  null;
                    
      end;
      
    begin  
            --Assing correct person id to varible
       SELECT PERSON_ID
               into l_person_id
                  FROM   PER_ALL_PEOPLE_F PAPF
                        WHERE PAPF.EMPLOYEE_NUMBER=adddata.code
                          AND  to_number(to_char(PAPF.effective_end_date,'RRRR'))>4000;    
    
    end;  
      
begin
         
        if v_counter =1 then 
          begin
          --Assing Correct version number to api    
            select max(pa.object_version_number)
                    into v_object_version_number 
                        from PER_ADDRESSES pa
                            where  pa.person_id=l_person_id;
            end;
         begin               
         HR_PERSON_ADDRESS_API.UPDATE_PERSON_ADDRESS(
           --------------------------Required----------------------
            P_VALIDATE => l_VALIDATE,
            P_EFFECTIVE_DATE  => l_EFFECTIVE_DATE,
            P_VALIDATE_COUNTY => l_VALIDATE_COUNTY,
            P_ADDRESS_ID  => l_ADDRESS_ID,
            P_OBJECT_VERSION_NUMBER =>v_object_version_number,
            --------------------------Updated Region----------------------
            P_COUNTRY  => l_COUNTRY,
            P_REGION_1 => adddata.region, ---passing current egypt region 
            P_REGION_2 => adddata.state, ---passing state egypt 
            P_TOWN_OR_CITY => adddata.city, --passing currnet city  
            P_ADDRESS_LINE1 => adddata.line1 --passing the first address of currnet employee
           ----------------------------------------------------------------              
        );
          v_status:='UU';
          v_errormsg:=sqlerrm;
              update xx_address_interface
                    set status=v_status,
                    errormsg=null
                where  xx_address_interface.code=adddata.code;
        commit;        
       
        exception when others then              
           v_status:='EU';
           v_errormsg:=sqlerrm;
              update xx_address_interface
                    set status=v_status,
                    errormsg=v_errormsg
                where  xx_address_interface.code=adddata.code;
        commit;  
        end;
    else
        --on this stage employee does not have address create new address for him 
       begin 
        hr_person_address_api.create_person_address(
           --------------------------Required----------------------
            P_VALIDATE  => l_VALIDATE,
            P_EFFECTIVE_DATE => l_EFFECTIVE_DATE,
            P_PRADD_OVLAPVAL_OVERRIDE => l_PRADD_OVLAPVAL_OVERRIDE ,
            P_VALIDATE_COUNTY => l_VALIDATE_COUNTY,
            P_PERSON_ID => l_PERSON_ID,
            P_PRIMARY_FLAG => l_PRIMARY_FLAG,
            P_STYLE => l_STYLE,
            P_DATE_FROM => l_DATE_FROM,
            P_ADDRESS_ID =>v_address_id, --out paramter
            P_OBJECT_VERSION_NUMBER =>v_object_number, --outparameter
            --------------------------Updated Region----------------------
            P_COUNTRY => l_COUNTRY,
            P_REGION_1 => adddata.region, --adding egypt region for current employee 
            P_REGION_2 => adddata.state, --adding egypt state for current employee
            P_TOWN_OR_CITY => adddata.city, 
            P_ADDRESS_LINE1 =>adddata.line1
             ------------------------------------------------------------------
        );
         v_status:='CC';
         v_errormsg:=sqlerrm;
              update xx_address_interface
                    set status=v_status,
                    errormsg=null
                where  xx_address_interface.code=adddata.code;
        commit;        
       
        exception when others then  
                v_status:='EC';  
                v_errormsg:=sqlerrm;
              update xx_address_interface
                    set status=v_status,
                    errormsg=v_errormsg
              where  xx_address_interface.code=adddata.code;
              
        commit;        
        
        end;
          
    end if; 
exception when others then
    v_errormsg:=sqlerrm;
    v_status:='E';
    update xx_address_interface
            set status=v_status,
            errormsg=v_errormsg
    where  xx_address_interface.code=adddata.code;
    commit;        
   
end; --end calling block

end loop;
end;
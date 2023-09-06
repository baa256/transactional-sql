CREATE OR REPLACE PROCEDURE okr_metric_dim_insert
(
inp_okr_metric_dim_pk                INT
,inp_okr_metric_id			         INT
,inp_okr_metric_name				 VARCHAR(255)
,inp_okr_metric_definition           VARCHAR(1000)
,inp_okr_metric_calculation	         VARCHAR(1000)
,inp_okr_metric_source               VARCHAR(255)
,inp_okr_metric_notes	             VARCHAR(1000)
,inp_okr_metric_status	             VARCHAR(50)
,inp_okr_metric_cadence              VARCHAR(50)
,inp_okr_metric_format               VARCHAR(50)
,inp_okr_metric_owner_name           VARCHAR(255)
,inp_okr_metric_department           VARCHAR(255)
,inp_okr_metric_target               VARCHAR(255)
,inp_okr_metric_target_operator      VARCHAR(2)
,inp_okr_metric_target_value         NUMERIC(10,6)
,inp_okr_metric_sub_department       VARCHAR(255)  
,inp_okr_metric_group                VARCHAR(255)  
,inp_okr_metric_objective_id         INT  
,inp_okr_metric_objective_description VARCHAR(255) 
,inp_okr_metric_value_status          VARCHAR(255) 
,inp_okr_metric_delete_flag     BOOLEAN
)
LANGUAGE plpgsql
AS
$$
	DECLARE 
        lv_dim_exists INT;
        lv_okr_metric_dim_name  VARCHAR(255);
        lv_okr_metric_dim_pk INT;
		lv_okr_metric_id_old INT;
		lv_okr_metric_name_old VARCHAR(255);
		lv_okr_metric_definition_old VARCHAR(1000);
		lv_okr_metric_calculation_old VARCHAR(1000);
		lv_okr_metric_source_old VARCHAR(255);    
		lv_okr_metric_notes_old VARCHAR(1000);   
		lv_okr_metric_status_old VARCHAR(50);
		lv_okr_metric_cadence_old VARCHAR(50); 
		lv_okr_metric_format_old VARCHAR(50); 
		lv_okr_metric_owner_name_old VARCHAR(255);
		lv_okr_metric_department_old VARCHAR(255);
		lv_okr_metric_target_old VARCHAR(255);
		lv_okr_metric_target_operator_old VARCHAR(2);
		lv_okr_metric_target_value_old NUMERIC(10,6);
		lv_okr_metric_sub_department_old VARCHAR(255);
		lv_okr_metric_group_old VARCHAR(255);
		lv_okr_metric_objective_id_old INT;
		lv_okr_metric_objective_description_old VARCHAR(255);
		lv_okr_metric_value_status_old VARCHAR(255);
		lv_okr_metric_delete_flag_old BOOLEAN;
    BEGIN 
	lv_dim_exists := (SELECT 1 FROM public.okr_metric_dim WHERE okr_metric_dim_pk = inp_okr_metric_dim_pk);
    --declaring old vars -bb
    
    SELECT okr_metric_id
	,okr_metric_name
	,okr_metric_definition        
	,okr_metric_calculation       
	,okr_metric_source         
	,okr_metric_notes            
	,okr_metric_status          
	,okr_metric_cadence           
	,okr_metric_format             
	,okr_metric_owner_name          
	,okr_metric_department           
	,okr_metric_target           
	,okr_metric_target_operator    
	,okr_metric_target_value        
	,okr_metric_sub_department        
	,okr_metric_group                    
	,okr_metric_objective_id              
	,okr_metric_objective_description 
	,okr_metric_value_status  
	,okr_metric_delete_flag 
	INTO
	lv_okr_metric_id_old 
	,lv_okr_metric_name_old 
	,lv_okr_metric_definition_old 
	,lv_okr_metric_calculation_old 
	,lv_okr_metric_source_old 
	,lv_okr_metric_notes_old    
	,lv_okr_metric_status_old 
	,lv_okr_metric_cadence_old 
	,lv_okr_metric_format_old 
	,lv_okr_metric_owner_name_old 
	,lv_okr_metric_department_old 
	,lv_okr_metric_target_old 
	,lv_okr_metric_target_operator_old 
	,lv_okr_metric_target_value_old 
	,lv_okr_metric_sub_department_old 
	,lv_okr_metric_group_old 
	,lv_okr_metric_objective_id_old 
	,lv_okr_metric_objective_description_old 
	,lv_okr_metric_value_status_old
	,lv_okr_metric_delete_flag_old 
	FROM okr_metric_dim 
	WHERE 1=1
	AND okr_metric_dim_pk = inp_okr_metric_dim_pk
    ;
    IF lv_dim_exists = 1  THEN 
        UPDATE okr_metric_dim 
        SET  okr_metric_id = inp_okr_metric_id
            ,okr_metric_name = inp_okr_metric_name
            ,okr_metric_definition = inp_okr_metric_definition        
            ,okr_metric_calculation = inp_okr_metric_calculation	      
            ,okr_metric_source = inp_okr_metric_source               
            ,okr_metric_notes = inp_okr_metric_notes	           
            ,okr_metric_status = inp_okr_metric_status	           
            ,okr_metric_cadence = inp_okr_metric_cadence             
            ,okr_metric_format = inp_okr_metric_format              
            ,okr_metric_owner_name = inp_okr_metric_owner_name           
            ,okr_metric_department = inp_okr_metric_department              
            ,okr_metric_target = inp_okr_metric_target              
            ,okr_metric_target_operator = inp_okr_metric_target_operator      
            ,okr_metric_target_value = inp_okr_metric_target_value         
            ,okr_metric_sub_department = inp_okr_metric_sub_department          
            ,okr_metric_group = inp_okr_metric_group                     
            ,okr_metric_objective_id = inp_okr_metric_objective_id              
            ,okr_metric_objective_description = inp_okr_metric_objective_description   
            ,okr_metric_value_status = inp_okr_metric_value_status
            ,okr_metric_delete_flag = inp_okr_metric_delete_flag                
        WHERE   okr_metric_dim_pk = inp_okr_metric_dim_pk ;	
	ELSE							
		INSERT INTO okr_metric_dim
        (
                okr_metric_name 
                ,okr_metric_id
                ,okr_metric_definition      
                ,okr_metric_calculation         
                ,okr_metric_source                 
                ,okr_metric_notes      
                ,okr_metric_status         
                ,okr_metric_cadence              
                ,okr_metric_format               
                ,okr_metric_owner_name            
                ,okr_metric_department                  
                ,okr_metric_target                   
                ,okr_metric_target_operator        
                ,okr_metric_target_value            
                ,okr_metric_sub_department           
                ,okr_metric_group                        
                ,okr_metric_objective_id                 
                ,okr_metric_objective_description     
                ,okr_metric_value_status 
                ,okr_metric_delete_flag          
		) 
		VALUES
	( 
            inp_okr_metric_name
            ,inp_okr_metric_id
            ,inp_okr_metric_definition    
            ,inp_okr_metric_calculation	
            ,inp_okr_metric_source  
            ,inp_okr_metric_notes	
            ,inp_okr_metric_status	    
            ,inp_okr_metric_cadence  
            ,inp_okr_metric_format    
            ,inp_okr_metric_owner_name  
            ,inp_okr_metric_department 
            ,inp_okr_metric_target
            ,inp_okr_metric_target_operator  
            ,inp_okr_metric_target_value    
            ,inp_okr_metric_sub_department  
            ,inp_okr_metric_group  
            ,inp_okr_metric_objective_id 
            ,inp_okr_metric_objective_description 
            ,inp_okr_metric_value_status  
            ,FALSE 
	);
    -- get key of record inserted
    SELECT okr_metric_dim_pk 
    INTO lv_okr_metric_dim_pk 
    FROM okr_metric_dim
    WHERE 1=1
        AND okr_metric_name = inp_okr_metric_name;
    
    END IF;
-- Insert history record

INSERT INTO okr_metric_dim_hist 
(
okr_metric_dim_fk
,okr_metric_id 
--,okr_metric_id_old
,okr_metric_name
,okr_metric_name_old
,okr_metric_definition
,okr_metric_definition_old
,okr_metric_calculation
,okr_metric_calculation_old
,okr_metric_source
,okr_metric_source_old
,okr_metric_notes
,okr_metric_notes_old
,okr_metric_status
,okr_metric_status_old
,okr_metric_cadence 
,okr_metric_cadence_old 
,okr_metric_format
,okr_metric_format_old
,okr_metric_owner_name
,okr_metric_owner_name_old
,okr_metric_department
,okr_metric_department_old
,okr_metric_target
,okr_metric_target_old
,okr_metric_target_operator
,okr_metric_target_operator_old
,okr_metric_target_value 
,okr_metric_target_value_old 
,okr_metric_sub_department
,okr_metric_sub_department_old
,okr_metric_group 
,okr_metric_group_old 
,okr_metric_objective_id
,okr_metric_objective_id_old
,okr_metric_objective_description 
,okr_metric_objective_description_old 
,okr_metric_value_status
,okr_metric_value_status_old
,okr_metric_delete_flag 
,okr_metric_delete_flag_old 
)
VALUES
(
COALESCE(lv_okr_metric_dim_pk,inp_okr_metric_dim_pk)
,inp_okr_metric_id
--,lv_okr_metric_id_old
,inp_okr_metric_name
,lv_okr_metric_name_old
,inp_okr_metric_definition 
,lv_okr_metric_definition_old
,inp_okr_metric_calculation
,lv_okr_metric_calculation_old
,inp_okr_metric_source 
,lv_okr_metric_source_old 
,inp_okr_metric_notes
,lv_okr_metric_notes_old
,inp_okr_metric_status
,lv_okr_metric_status_old
,inp_okr_metric_cadence 
,lv_okr_metric_cadence_old 
,inp_okr_metric_format
,lv_okr_metric_format_old
,inp_okr_metric_owner_name 
,lv_okr_metric_owner_name_old 
,inp_okr_metric_department 
,lv_okr_metric_department_old 
,inp_okr_metric_target
,lv_okr_metric_target_old
,inp_okr_metric_target_operator
,lv_okr_metric_target_operator_old
,inp_okr_metric_target_value
,lv_okr_metric_target_value_old
,inp_okr_metric_sub_department
,lv_okr_metric_sub_department_old
,inp_okr_metric_group
,lv_okr_metric_group_old
,inp_okr_metric_objective_id
,lv_okr_metric_objective_id_old
,inp_okr_metric_objective_description
,lv_okr_metric_objective_description_old
,inp_okr_metric_value_status
,lv_okr_metric_value_status_old
,inp_okr_metric_delete_flag
,lv_okr_metric_delete_flag_old
);

END;
$$;

/* testing code
CALL okr_metric_dim_insert
(
	4 --inp_okr_metric_dim_pk                INT
,5 --inp_okr_metric_id			         INT
,'name' -- inp_okr_metric_name				 VARCHAR(255)
,'' --inp_okr_metric_definition           VARCHAR(1000)
,'' --inp_okr_metric_calculation	         VARCHAR(1000)
,'' --inp_okr_metric_source               VARCHAR(255)
,'' --inp_okr_metric_notes	             VARCHAR(1000)
,'' --inp_okr_metric_status	             VARCHAR(50)
,'' --inp_okr_metric_cadence              VARCHAR(50)
,'' --inp_okr_metric_format               VARCHAR(50)
,'' --inp_okr_metric_owner_name           VARCHAR(255)
,'' --inp_okr_metric_department           VARCHAR(255)
,'' --inp_okr_metric_target               VARCHAR(255)
,'' --inp_okr_metric_target_operator      VARCHAR(2)
,99 --inp_okr_metric_target_value         NUMERIC(10,6)
,'' --inp_okr_metric_sub_department       VARCHAR(255)  
,'' --inp_okr_metric_group                VARCHAR(255)  
,99 --inp_okr_metric_objective_id         INT  
,'' --inp_okr_metric_objective_description VARCHAR(255) 
,'' --inp_okr_metric_value_status          VARCHAR(255) 
,FALSE -- inp_okr_metric_delete_flag     BOOLEAN
	);
SELECT * FROM okr_metric_dim

SELECT * FROM okr_metric_dim_hist

TRUNCATE TABLE okr_metric_dim_hist;
TRUNCATE TABLE okr_metric_fact_hist;

TRUNCATE TABLE okr_metric_fact CASCADE;

TRUNCATE TABLE okr_metric_dim CASCADE;
*/

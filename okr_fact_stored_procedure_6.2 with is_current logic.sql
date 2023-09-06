CREATE OR REPLACE PROCEDURE okr_metric_fact_insert_with_hist
(
inp_okr_metric_dim_fk INT
,inp_okr_metric_fact_pk INT 
,inp_okr_metric_id INT
,inp_okr_metric_date Date
--,inp_okr_metric_is_current BOOLEAN 
,inp_okr_metric_value NUMERIC(18,6)
,inp_okr_metric_value_status VARCHAR(50) 
,inp_okr_metric_target VARCHAR(255)
,inp_okr_metric_target_operator VARCHAR(2)
,inp_okr_metric_target_value NUMERIC(18,6)
,inp_okr_metric_fact_delete_flag BOOLEAN
) 
LANGUAGE plpgsql
AS
$$
	DECLARE 
    lv_fact_exists 	 INT;
    lv_okr_metric_dim_pk INT;
    lv_okr_metric_value_str VARCHAR(50);
    -- vars for hist table 
    lv_okr_metric_dim_fk_old INT;
	lv_okr_metric_id_old INT;
    lv_okr_metric_date_old DATE;    
    lv_okr_metric_is_current_old BOOLEAN;
    lv_okr_metric_value_old NUMERIC(18,6);
    lv_okr_metric_value_status_old VARCHAR(50);
    lv_okr_metric_value_str_old VARCHAR(50);
    lv_okr_metric_target_old VARCHAR(255);
    lv_okr_metric_target_operator_old VARCHAR(2);
    lv_okr_metric_target_value_old NUMERIC(18,6);
    lv_okr_metric_fact_delete_flag_old BOOLEAN; --11

	BEGIN
    --okr_metric_str logic check 

	lv_okr_metric_value_str := (SELECT
    CASE
    WHEN okr_metric_dim.okr_metric_format = 'Percent'
    THEN ROUND(inp_okr_metric_value * 100,2)::VARCHAR || '%'
    ELSE ROUND(inp_okr_metric_value,2)::VARCHAR
    END
    FROM okr_metric_dim 
    WHERE inp_okr_metric_dim_fk = okr_metric_dim_pk);
    
	lv_fact_exists := (SELECT 1 FROM public.okr_metric_fact WHERE okr_metric_dim_fk = inp_okr_metric_dim_fk AND okr_metric_date = inp_okr_metric_date);
    SELECT 
    okr_metric_dim_fk
    ,okr_metric_id 
    ,okr_metric_date
    --,okr_metric_is_current 
    ,okr_metric_value 
    ,okr_metric_value_status
    ,okr_metric_value_str
    ,okr_metric_target
    ,okr_metric_target_operator 
    ,okr_metric_target_value
    ,okr_metric_fact_delete_flag --11
    INTO
    lv_okr_metric_dim_fk_old  
    ,lv_okr_metric_id_old  
    ,lv_okr_metric_date_old      
    --,lv_okr_metric_is_current_old     
    ,lv_okr_metric_value_old  
    ,lv_okr_metric_value_status_old
    ,lv_okr_metric_value_str_old  
    ,lv_okr_metric_target_old
    ,lv_okr_metric_target_operator_old 
    ,lv_okr_metric_target_value_old
    ,lv_okr_metric_fact_delete_flag_old --11
    FROM okr_metric_fact
    WHERE 1 = 1
    AND okr_metric_dim_fk = inp_okr_metric_dim_fk
	AND okr_metric_date = inp_okr_metric_date	
    ;
-- end of delcaring old vars with data assignments        
        
    IF (COALESCE(lv_fact_exists, 0) >0 ) THEN
		UPDATE okr_metric_fact fact  -- update row if exists 
        SET 
        okr_metric_id = okr_metric_dim.okr_metric_id 
        ,okr_metric_date = inp_okr_metric_date-- ,okr_metric_is_current = inp_okr_metric_is_current
        ,okr_metric_value = inp_okr_metric_value 
        ,okr_metric_value_status = okr_metric_dim.okr_metric_value_status
        ,okr_metric_value_str = CASE WHEN okr_metric_dim.okr_metric_format = 'Percent'THEN ROUND(inp_okr_metric_value * 100,2)::VARCHAR || '%'ELSE ROUND(inp_okr_metric_value,2)::VARCHAR END
        ,okr_metric_target = okr_metric_dim.okr_metric_target  
        ,okr_metric_target_operator = okr_metric_dim.okr_metric_target_operator
        ,okr_metric_target_value = okr_metric_dim.okr_metric_target_value 
        ,okr_metric_fact_delete_flag  = okr_metric_dim.okr_metric_delete_flag 
        ,okr_metric_fact_updated_by = 'OKR Table Load.sql script'
        ,okr_metric_fact_updated_timestamp = CURRENT_TIMESTAMP
        FROM public.okr_metric_dim 
        WHERE 1=1 
        AND fact.okr_metric_dim_fk = okr_metric_dim.okr_metric_dim_pk
        AND fact.okr_metric_dim_fk = inp_okr_metric_dim_fk -- check this
        AND okr_metric_date = inp_okr_metric_date;
ELSE 
		--UPDATE okr_metric_fact -- insert row if row doesn't exist 
        --SET okr_metric_is_current = FALSE WHERE okr_metric_date < inp_okr_metric_date AND okr_metric_dim_fk = inp_okr_metric_dim_fk;			

        INSERT INTO okr_metric_fact(
        okr_metric_dim_fk
        ,okr_metric_id
        ,okr_metric_date
        --,okr_metric_is_current
        ,okr_metric_value
        ,okr_metric_value_status
        ,okr_metric_value_str
        ,okr_metric_target
        ,okr_metric_target_operator
        ,okr_metric_target_value
        ,okr_metric_fact_delete_flag) 
        VALUES( 
        inp_okr_metric_dim_fk
        ,inp_okr_metric_id
        ,inp_okr_metric_date
        --,TRUE --iscurrent set to True 
        ,inp_okr_metric_value
        ,inp_okr_metric_value_status
        ,lv_okr_metric_value_str
        ,inp_okr_metric_target
        ,inp_okr_metric_target_operator
        ,inp_okr_metric_target_value
        ,inp_okr_metric_fact_delete_flag);
	END IF; 
-- is_current logic 
	-- set all rows to False for okr 
	UPDATE okr_metric_fact
	SET okr_metric_is_current = false
	Where okr_metric_dim_fk = inp_okr_metric_dim_fk
	;
	
	--set True for most recent okr 
	UPDATE okr_metric_fact
	SET okr_metric_is_current = true 
	Where okr_metric_fact_pk =( 
		SELECT okr_metric_fact.okr_metric_fact_pk 
		FROM okr_metric_fact 
		WHERE okr_metric_fact.okr_metric_date = 
		(SELECT MAX(okr_metric_date) 
		FROM okr_metric_fact 
		WHERE okr_metric_fact.okr_metric_dim_fk = inp_okr_metric_dim_fk
		)
		AND okr_metric_dim_fk = inp_okr_metric_dim_fk
	);
	
-- end of is_current logic 

--Start of Hist  table insert  
	INSERT INTO okr_metric_fact_hist(
	okr_metric_dim_fk
	,okr_metric_id
	,okr_metric_id_old
	,okr_metric_date
	,okr_metric_date_old 
	--,okr_metric_is_current  -- don't need for hist 
	--,okr_metric_is_current_old  -- don't need for hist 
	,okr_metric_value
	,okr_metric_value_old
    ,okr_metric_value_status 
    ,okr_metric_value_status_old
	,okr_metric_value_str
	,okr_metric_value_str_old 
    ,okr_metric_target 
    ,okr_metric_target_old
	,okr_metric_target_operator
	,okr_metric_target_operator_old
    ,okr_metric_target_value 
    ,okr_metric_target_value_old
    ,okr_metric_fact_delete_flag
    ,okr_metric_fact_delete_flag_old
	)
	VALUES(
		inp_okr_metric_dim_fk
		,inp_okr_metric_id
		,lv_okr_metric_id_old 
		,inp_okr_metric_date
		,lv_okr_metric_date_old   
		--,inp_okr_metric_is_current  -- don't need for hist 
		--,lv_okr_metric_is_current_old   -- don't need for hist 
		,inp_okr_metric_value
		,lv_okr_metric_value_old 
        ,inp_okr_metric_value_status
		,lv_okr_metric_value_status_old
        ,lv_okr_metric_value_str
		,lv_okr_metric_value_str_old 
        ,inp_okr_metric_target
        ,lv_okr_metric_target_old
		,inp_okr_metric_target_operator
		,lv_okr_metric_target_operator_old 
        ,inp_okr_metric_target_value
        ,lv_okr_metric_target_value_old
        ,inp_okr_metric_fact_delete_flag 
        ,lv_okr_metric_fact_delete_flag_old
	);
	--End of Hist table insert 
	END;
$$;
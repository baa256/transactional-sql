-- dim hist table - revised on 3-14-2022
CREATE TABLE public.okr_metric_dim_hist(
-- change_hist columns 
okr_metric_dim_hist_pk SERIAL PRIMARY KEY
,okr_metric_dim_fk INT --new
,okr_metric_id_old INT  
,okr_metric_name_old  VARCHAR(255)  
,okr_metric_definition_old  VARCHAR(1000)
,okr_metric_calculation_old  VARCHAR(1000)
,okr_metric_source_old  VARCHAR(255)
,okr_metric_notes_old  VARCHAR(1000)
,okr_metric_status_old  VARCHAR(50)
,okr_metric_cadence_old  VARCHAR(50)
,okr_metric_format_old  VARCHAR(50)
,okr_metric_owner_name_old  VARCHAR(255)
,okr_metric_department_old  VARCHAR(255)
,okr_metric_target_old  VARCHAR(255)
,okr_metric_target_operator_old  VARCHAR(2)
,okr_metric_target_value_old  NUMERIC(18,6)
,okr_metric_sub_department_old  VARCHAR(255)
,okr_metric_group_old  VARCHAR(255)
,okr_metric_objective_id_old  INT
,okr_metric_objective_description_old  VARCHAR(255)
,okr_metric_value_status_old  VARCHAR(50)
,okr_metric_delete_flag_old  BOOLEAN
,okr_metric_id INT NOT NULL
,okr_metric_name VARCHAR(255)  
,okr_metric_definition VARCHAR(1000)
,okr_metric_calculation VARCHAR(1000)
,okr_metric_source VARCHAR(255)
,okr_metric_notes VARCHAR(1000)
,okr_metric_status VARCHAR(50)
,okr_metric_cadence VARCHAR(50)
,okr_metric_format VARCHAR(50)
,okr_metric_owner_name VARCHAR(255)
,okr_metric_department VARCHAR(255)
,okr_metric_target VARCHAR(255)
,okr_metric_target_operator VARCHAR(2)
,okr_metric_target_value NUMERIC(18,6)
,okr_metric_sub_department VARCHAR(255)
,okr_metric_group VARCHAR(255)
,okr_metric_objective_id INT
,okr_metric_objective_description VARCHAR(255)
,okr_metric_value_status VARCHAR(50)
,okr_metric_delete_flag BOOLEAN
,okr_metric_dim_hist_created_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
,okr_metric_dim_hist_created_by VARCHAR(255)
,okr_metric_dim_hist_updated_timestamp TIMESTAMP
,okr_metric_dim_hist_updated_by VARCHAR(255)
,CONSTRAINT ok_metric_dim_hist_okr_metric_dim_fk FOREIGN KEY(okr_metric_dim_fk) REFERENCES public.okr_metric_dim(okr_metric_dim_pk)
);

-- new fact hist table 
CREATE TABLE public.okr_metric_fact_hist(
--hist change columns
okr_metric_fact_hist_pk SERIAL PRIMARY KEY
,okr_metric_dim_fk INT 
,okr_metric_fact_fk INT 
,okr_metric_id_old INT 
,okr_metric_date_old DATE 
,okr_metric_is_current_old BOOLEAN
,okr_metric_value_old NUMERIC(18,6) 
,okr_metric_value_status_old VARCHAR(50)
,okr_metric_value_str_old VARCHAR(50) -- NEW logic TBD
,okr_metric_target_old VARCHAR(255) -- NEW
,okr_metric_target_operator_old VARCHAR(2) -- NEW
,okr_metric_target_value_old NUMERIC(18,6) -- NEW
,okr_metric_fact_delete_flag_old BOOLEAN -- NEW
,okr_metric_id INT 
,okr_metric_date DATE 
,okr_metric_is_current BOOLEAN
,okr_metric_value NUMERIC(18,6) 
,okr_metric_value_status VARCHAR(50)
,okr_metric_value_str VARCHAR(50) -- NEW logic TBD
,okr_metric_target VARCHAR(255) -- NEW
,okr_metric_target_operator VARCHAR(2) -- NEW
,okr_metric_target_value NUMERIC(18,6) -- NEW
,okr_metric_fact_delete_flag BOOLEAN -- NEW
,okr_metric_fact_hist_created_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
,okr_metric_fact_hist_created_by VARCHAR(255)
,okr_metric_fact_hist_updated_timestamp TIMESTAMP
,okr_metric_fact_hist_updated_by VARCHAR(255)
,CONSTRAINT ok_metric_fact_hist_okr_metric_dim_fk FOREIGN KEY(okr_metric_dim_fk) REFERENCES public.okr_metric_dim(okr_metric_dim_pk)
,CONSTRAINT ok_metric_fact_hist_okr_metric_fact_fk FOREIGN KEY(okr_metric_fact_fk) REFERENCES public.okr_metric_fact(okr_metric_fact_pk)
);

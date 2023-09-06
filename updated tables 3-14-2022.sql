-- updated tables  3-14-2022

-- Create Metrics Dimension Table
CREATE TABLE okr_metric_dim
(
okr_metric_dim_pk SERIAL PRIMARY KEY -- disabled caching
,okr_metric_id INT NOT NULL
,okr_metric_name VARCHAR(255) NOT NULL
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
,okr_metric_dim_created_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
,okr_metric_dim_created_by VARCHAR(255)
,okr_metric_dim_updated_timestamp TIMESTAMP
,okr_metric_dim_updated_by VARCHAR(255)
)
;

--fact table 

CREATE TABLE okr_metric_fact
(okr_metric_fact_pk SERIAL PRIMARY KEY -- disabled caching
,okr_metric_dim_fk INT NOT NULL
,okr_metric_id INT NOT NULL
,okr_metric_date DATE
,okr_metric_is_current BOOLEAN
,okr_metric_value NUMERIC(18,6)
,okr_metric_value_status VARCHAR(50)
,okr_metric_value_str VARCHAR(50)
,okr_metric_target VARCHAR(255) -- NEW 
,okr_metric_target_operator VARCHAR(2) -- NEW
,okr_metric_target_value NUMERIC(18,6) -- NEW
,okr_metric_fact_delete_flag BOOLEAN -- NEW
,okr_metric_fact_created_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
,okr_metric_fact_created_by VARCHAR(255)
,okr_metric_fact_updated_timestamp TIMESTAMP 
,okr_metric_fact_updated_by VARCHAR(255)
,FOREIGN KEY(okr_metric_dim_fk) REFERENCES okr_metric_dim(okr_metric_dim_pk)
); --16 total -12 without etl  -11 without value_str
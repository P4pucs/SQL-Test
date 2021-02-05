--------------------------------------- BEFORE TRIGGER ---------------------------------------------


CREATE OR REPLACE FUNCTION replace_bad_start_date() RETURNS trigger AS $replace_bad_start_date$
	DECLARE
		date1 DATE;
		date2 DATE;
    BEGIN
		SELECT
			p.date_of_birth
		INTO
			date1
		FROM
			patients AS p 
		WHERE
			p.id = NEW.patient1_id;
			
		SELECT
			p.date_of_birth
		INTO
			date2
		FROM
			patients AS p 
		WHERE
			p.id = NEW.patient2_id;
			
		IF NEW.started <= GREATEST(date1, date2) 
		THEN
			NEW.started := GREATEST(date1, date2);
		END IF;
		
		RETURN NEW;
    END;
$replace_bad_start_date$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS before_trigger on relations;

CREATE TRIGGER before_trigger BEFORE INSERT ON relations
    FOR EACH ROW EXECUTE FUNCTION replace_bad_start_date();


--------------------------------------- AFTER TRIGGER ---------------------------------------------


CREATE OR REPLACE FUNCTION refresh_end_date() RETURNS trigger AS $refresh_end_date$
	BEGIN

		update relations
		set ended = NEW.date_of_death
		where NEW.id in(patient1_id, patient2_id) and ended > NEW.date_of_death;
		
		RETURN NEW;
    END;
$refresh_end_date$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS after_trigger on patients;

CREATE TRIGGER after_trigger AFTER UPDATE ON patients
    FOR EACH ROW EXECUTE FUNCTION refresh_end_date();



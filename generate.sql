declare
    c_tablename user_tables.table_name%type; 
    cursor table_cur is 
    select table_name
    from user_tables 
    where tablespace_name = 'DATA' 
    AND table_name not like 'MD_%'
    AND table_name not like 'STAGE_%'
    and table_name not like 'MIGR%';
    
begin
    OPEN table_cur; 
    LOOP 
    FETCH table_cur into c_tablename; 
      EXIT WHEN table_cur%notfound; 
        dbms_output.put_line('CREATE SEQUENCE ' || lower(c_tablename) || '_seq');
        dbms_output.put_line('START WITH 99999 ');
        dbms_output.put_line('INCREMENT BY 1');
        dbms_output.put_line('NOCACHE');
        dbms_output.put_line('NOCYCLE;');
        dbms_output.put_line('/');
        dbms_output.put_line('CREATE OR REPLACE TRIGGER ' || lower(c_tablename) || '_seq_trg');
        dbms_output.put_line('BEFORE INSERT');
        dbms_output.put_line('ON ' || lower(c_tablename) || '');
        dbms_output.put_line('REFERENCING NEW AS New OLD AS Old');
        dbms_output.put_line('FOR EACH ROW');
        dbms_output.put_line('DECLARE');
        dbms_output.put_line('tmpVar NUMBER;');
        dbms_output.put_line('');
        dbms_output.put_line('BEGIN');
        dbms_output.put_line('    tmpVar := 0;');
        dbms_output.put_line('    SELECT ' || lower(c_tablename) || '_seq.NEXTVAL INTO tmpVar FROM dual; ');
        dbms_output.put_line('    :NEW.id := tmpVar;');
        dbms_output.put_line('');
        dbms_output.put_line('EXCEPTION ');
        dbms_output.put_line('    WHEN OTHERS THEN');
        dbms_output.put_line('    RAISE;');
        dbms_output.put_line('END ' || lower(c_tablename) || '_seq_trg;');
        dbms_output.put_line('/');
    END LOOP; 
    CLOSE table_cur;
end;







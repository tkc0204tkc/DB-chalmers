CREATE OR REPLACE FUNCTION add_to_waitinglist() RETURNS TRIGGER AS $$
DECLARE
   seatsleft INT := (SELECT capacity FROM LimitedCourses WHERE code = NEW.course) - (SELECT COUNT(student) FROM Registered WHERE course = NEW.course);
   currentposition INT := 1 + (SELECT COUNT(student) FROM WaitingList WHERE course = NEW.course);
   isregistered BOOLEAN := EXISTS (SELECT course FROM Registrations WHERE student = NEW.student AND course = NEW.course);
   iswaiting BOOLEAN := EXISTS (SELECT course FROM WaitingList WHERE student = NEW.student AND course = NEW.course);
   countprereq INT := (SELECT COUNT(prerequisite) FROM Prerequisites WHERE code = NEW.course);
   prereqleft INT := countprereq - (SELECT COUNT(course) FROM Taken WHERE student = NEW.student AND course IN (SELECT prerequisite FROM Prerequisites WHERE code = NEW.course) AND grade NOT IN ('U'));
   failingprereq INT := (SELECT COUNT(course) FROM Taken WHERE student = NEW.student AND course IN (SELECT prerequisite FROM Prerequisites WHERE code = NEW.course) AND grade IN ('U'));
BEGIN
   CASE
    WHEN isregistered THEN 
      RAISE NOTICE 'already registered';
      RETURN NULL; 
    WHEN iswaiting THEN 
      RAISE NOTICE 'already waiting';
      RETURN NULL;
    WHEN prereqleft > 0 THEN 
      RAISE NOTICE 'missing % prereq', prereqleft;
      RETURN NULL;
    WHEN failingprereq > 0 THEN
      RAISE NOTICE 'failing grade on % prereq', failingprereq;
    WHEN seatsleft = 0 THEN
      RAISE NOTICE 'already full, added to waitng list (position %)', currentposition;
      INSERT INTO WaitingList VALUES (NEW.student, NEW.course, currentposition);
      RETURN NULL;
   ELSE 
   INSERT INTO Registered VALUES (NEW.student, NEW.course);
   RAISE NOTICE 'registered';
   RETURN NEW;
   END CASE;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION unregistration() RETURNS TRIGGER AS $$
DECLARE
   firstinlist CHAR(10)
BEGIN
   IF OLD.status = 'registered' THEN 
      DELETE FROM Registered WHERE student = OLD.student AND course = OLD.course;
      DECLARE seatsleft INT := (SELECT capacity FROM LimitedCourses WHERE code = NEW.course) - (SELECT COUNT(student) FROM Registered WHERE course = NEW.course);
      IF EXISTS(SELECT course FROM LimitedCourses WHERE code = OLD.course) AND (SELECT COUNT(student) FROM WaitingList WHERE course = OLD.course) > 0 AND seatsleft > 0 THEN 
         firstinlist := (SELECT student FROM WaitingList WHERE position = 1 AND course = OLD.course);
         DELETE FROM WaitingList WHERE student = firstinlist AND course = OLD.course;
         INSERT INTO Registered VALUES (firstinlist, OLD.course);
         UPDATE WaitingList SET position = position -1 WHERE position > 1;
      END IF;
    
   ELSE
      DELETE FROM WaitingList WHERE student = OLD.student AND course = OLD.course;
      UPDATE WaitingList SET position = position -1 WHERE position > (SELECT position FROM WaitingList WHERE course = OLD.course AND student = OLD.student);
   END IF;
      

   


END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER add_to_waitinglist_trigger
   INSTEAD OF INSERT ON Registrations
   FOR EACH ROW
   EXECUTE FUNCTION add_to_waitinglist();
   
CREATE TRIGGER unregistration_trigger
   INSTEAD OF DELETE ON Registrations
   FOR EACH ROW 
   EXECUTE FUNCTION unregistration();

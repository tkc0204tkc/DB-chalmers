CREATE VIEW BasicInformation AS (
    SELECT s.idnr, s.name, s.login, s.program, sb.branch
    FROM Students s
    LEFT JOIN StudentBranches sb ON s.idnr = sb.student
    ORDER BY idnr
);

CREATE VIEW FinishedCourses AS (
    SELECT t.student, t.course, c.name, t.grade, c.credits
    FROM Taken t
    LEFT JOIN Courses c ON t.course = c.code
    ORDER BY student, grade DESC
);

CREATE VIEW Registrations AS (
    (SELECT *, 'registered' as status
    FROM Registered) 
    Union 
    (SELECT student, course, 'waiting' as status
    FROM WaitingList)
    ORDER BY status, course ASC, student ASC
);

CREATE VIEW PassedCourses AS (
    SELECT student, course, credits
    FROM FinishedCourses
    WHERE grade IN ('3','4','5')
);

CREATE VIEW UnreadMandatory AS (
    (SELECT bi.idnr as student, mp.course  
    FROM BasicInformation bi
    JOIN MandatoryProgram mp ON bi.program = mp.program)
    UNION
    (SELECT sb.student, mb.course
    FROM StudentBranches sb
    JOIN MandatoryBranch mb ON sb.branch = mb.branch AND sb.program = mb.program)
    EXCEPT
    (SELECT student, course
    FROM PassedCourses)
    ORDER BY student
);

CREATE VIEW TotalCred AS (
    SELECT student, SUM(credits) as totalcredits
    FROM PassedCourses
    GROUP BY student
);

CREATE VIEW mandatoryLeft AS (
    SELECT bi.idnr as student, COUNT(um.course) as mandatoryleft
    FROM BasicInformation bi 
    LEFT JOIN UnreadMandatory um ON bi.idnr = um.student
    GROUP BY bi.idnr 
    ORDER BY student ASC
);

CREATE VIEW MathCred AS (
    SELECT pc.student, SUM(pc.credits) as mathcredits
    FROM PassedCourses pc
    LEFT JOIN Classified c ON pc.course = c.course
    WHERE c.classification = 'math'
    GROUP BY pc.student
);

CREATE VIEW SeminarCred AS (
    SELECT pc.student, COUNT(pc.course) as seminarcourses
    FROM PassedCourses pc
    LEFT JOIN Classified c ON pc.course = c.course
    WHERE c.classification = 'seminar'
    GROUP BY pc.student
);  

CREATE VIEW RecommendedCourses AS (
    SELECT bi.idnr as student, rb.course, pc.credits
    FROM BasicInformation bi
    INNER JOIN RecommendedBranch rb ON bi.program = rb.program AND bi.branch = rb.branch 
    INNER JOIN PassedCourses pc ON bi.idnr = pc.student AND pc.course = rb.course
);

CREATE VIEW PathToGraduation AS (
    SELECT ml.student, COALESCE(tc.totalcredits,0) as totalcredits, ml.mandatoryleft, COALESCE(mc.mathcredits,0) as mathcredits, COALESCE(sc.seminarcourses,0) as seminarcourses,
    CASE 
      WHEN (mandatoryleft > 0) OR (mathcredits < 20) OR (seminarcourses < 1) THEN 'f' 
      WHEN (rc.credits is NULL) OR (rc.credits < 10) THEN 'f'
    ELSE 't'
    END AS qualified
    FROM TotalCred tc
    FULL OUTER JOIN mandatoryLeft ml ON tc.student = ml.student
    LEFT JOIN MathCred mc ON ml.student = mc.student
    LEFT JOIN SeminarCred sc ON ml.student = sc.student
    LEFT JOIN RecommendedCourses rc ON ml.student = rc.student
);


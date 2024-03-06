SELECT jsonb_build_object(
                     'student', s.idnr
                    ,'name', s.name
                    ,'login', s.login
                    ,'program', s.program
                    ,'branch', s.branch
                    ,'finished', (SELECT COALESCE(jsonb_agg(jsonb_build_object('course', coursename,'code',course,'credits',credits,'grade',grade)),'[]')
                                  FROM FinishedCourses WHERE student = s.idnr)
                    ,'registered', (SELECT COALESCE(jsonb_agg(jsonb_build_object('course', c.name, 'code', r.course, 'status', r.status, 'position', w.position)),'[]')
                                    FROM Registrations r 
                                    LEFT JOIN WaitingList w ON w.student = r.student AND w.course = r.course
                                    LEFT JOIN Courses c ON c.code = r.course
                                    WHERE r.student = s.idnr)
                    ,'seminarCourses', (SELECT COALESCE(COUNT(pc.course),0)
                                        FROM PassedCourses pc
                                        LEFT JOIN Classified c ON pc.course = c.course
                                        WHERE c.classification = 'seminar' AND student = s.idnr)
                    ,'mathCredits', (SELECT COALESCE(SUM(pc.credits),0)
                                     FROM PassedCourses pc
                                     LEFT JOIN Classified c ON pc.course = c.course
                                     WHERE c.classification = 'math' AND student = s.idnr)
                    ,'totalCredits', (SELECT COALESCE(SUM(credits),0)
                                      FROM PassedCourses WHERE student = s.idnr)
                    ,'canGraduate', (SELECT qualified FROM PathToGraduation WHERE student = s.idnr)
) :: TEXT 
FROM BasicInformation AS s
WHERE s.idnr = '1111111111';
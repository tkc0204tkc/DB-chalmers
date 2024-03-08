import psycopg2


class PortalConnection:
    def __init__(self):
        self.conn = psycopg2.connect(
            host="localhost",
            user="tangkingching",
            password="postgres")
        self.conn.autocommit = True

    def getInfo(self,student):
      with self.conn.cursor() as cur:
        sql = """
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
                WHERE s.idnr = %s;"""
        cur.execute(sql, (student,))
        res = cur.fetchone()
        if res:
            return (str(res[0]))
        else:
            return """{"student":"Not found :("}"""

    def register(self, student, courseCode):
        with self.conn.cursor() as cur:
            try:
                sql = """INSERT INTO Registrations VALUES (%s,%s,'registered');"""
                cur.execute(sql, (student,courseCode))
                return '{"success":true}'
            except psycopg2.Error as e:
                message = getError(e)
                return '{"success":false, "error": "'+message+'"}'

    def unregister(self, student, courseCode):
        with self.conn.cursor() as cur:
            # sql = """DELETE FROM Registrations WHERE student = %s AND course = %s;"""
            cur.execute("DELETE FROM Registrations WHERE student = '%s' AND course = '%s';" % (student,courseCode))
            if cur.rowcount == 0:
                checkcourseExist = """SELECT code FROM Courses WHERE code = %s"""
                cur.execute(checkcourseExist,(courseCode,))
                if not cur.fetchone():
                    return '{"success":false, "error": "course does not exist"}'
                else:
                    return '{"success":false, "error": "student is not registered/waiting"}'
            else:
                return '{"success":true}'

def getError(e):
    message = repr(e)
    message = message.replace("\\n"," ")
    message = message.replace("\"","\\\"")
    return message


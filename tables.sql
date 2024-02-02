CREATE TABLE Students (
    idnr DECIMAL(10) PRIMARY KEY,
    name TEXT NOT NULL,
    login TEXT NOT NULL,
    program TEXT NOT NULL
);

CREATE TABLE Branches (
    name TEXT NOT NULL,
    program TEXT NOT NULL,
    PRIMARY KEY (name, program)
);

CREATE TABLE Courses (
    code TEXT PRIMARY KEY,
    name TEXT NOT NULL, 
    credits FLOAT NOT NULL,
    department TEXT NOT NULL
);

CREATE TABLE LimitedCourses (
    code TEXT PRIMARY KEY,
    capacity INT NOT NULL,
    FOREIGN KEY (code) REFERENCES Courses(code)
);

CREATE TABLE StudentBranches (
    student DECIMAL(10) PRIMARY KEY,
    branch TEXT NOT NULL,
    program TEXT NOT NULL,
    FOREIGN KEY (student) REFERENCES Students(idnr),
    FOREIGN KEY (branch, program) REFERENCES Branches(name, program)
);

CREATE TABLE Classifications (
    name TEXT PRIMARY KEY
);

CREATE TABLE Classified (
    course TEXT NOT NULL,
    classification TEXT NOT NULL,
    FOREIGN KEY (course) REFERENCES Courses(code),
    FOREIGN KEY (classification) REFERENCES Classifications(name),
    PRIMARY KEY (course, classification)
);

CREATE TABLE MandatoryProgram (
    course TEXT NOT NULL,
    program TEXT NOT NULL,
    FOREIGN KEY (course) REFERENCES Courses(code),
    PRIMARY KEY (course, program)
);

CREATE TABLE MandatoryBranch (
    course TEXT NOT NULL,
    branch TEXT NOT NULL,
    program TEXT NOT NULL,
    FOREIGN KEY (course) REFERENCES Courses(code),
    FOREIGN KEY (branch, program) REFERENCES Branches(name, program),
    PRIMARY KEY (course, branch, program)
);

CREATE TABLE RecommendedBranch (
    course TEXT NOT NULL,
    branch TEXT NOT NULL,
    program TEXT NOT NULL,
    FOREIGN KEY (course) REFERENCES Courses(code),
    FOREIGN KEY (branch, program) REFERENCES Branches(name, program),
    PRIMARY KEY (course, branch, program)
);

CREATE TABLE Registered (
    student DECIMAL(10) NOT NULL,
    course TEXT NOT NULL,
    FOREIGN KEY (student) REFERENCES Students(idnr),
    FOREIGN KEY (course) REFERENCES Courses(code),
    PRIMARY KEY (student, course)
);

CREATE TABLE Taken (
    student DECIMAL(10) NOT NULL,
    course TEXT NOT NULL,
    grade CHAR(1) DEFAULT '0' CHECK (grade IN ('0','U','3','4','5')),
    FOREIGN KEY (student) REFERENCES Students(idnr),
    FOREIGN KEY (course) REFERENCES Courses(code),
    PRIMARY KEY (student, course)
);

CREATE TABLE WaitingList (
    student DECIMAL(10) NOT NULL,
    course TEXT NOT NULL,
    position INT NOT NULL,
    FOREIGN KEY (student) REFERENCES Students(idnr),
    FOREIGN KEY (course) REFERENCES LimitedCourses(code),
    PRIMARY KEY (student, course)
);


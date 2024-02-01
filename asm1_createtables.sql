CREATE TABLE Students (
    idnr INT(10) PRIMARY KEY,
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
    credits INT NOT NULL,
    department TEXT NOT NULL
);

CREATE TABLE LimitedCourses (
    code TEXT PRIMARY KEY,
    capacity INT NOT NULL
);

CREATE TABLE StudentBranches (
    student INT(10) PRIMARY KEY,
    branch TEXT NOT NULL,
    program TEXT NOT NULL
);

CREATE TABLE Classifications (
    name TEXT
);

CREATE TABLE Classified (
    course TEXT NOT NULL,
    classification TEXT NOT NULL
    PRIMARY KEY (course, classification)
);

CREATE TABLE MandatoryProgram (
    course TEXT NOT NULL,
    program TEXT NOT NULL,
    PRIMARY KEY (course, program)
);

CREATE TABLE MandatoryBranch (
    course TEXT NOT NULL,
    branch TEXT NOT NULL,
    program TEXT NOT NULL,
    PRIMARY KEY (course, branch, program)
);

CREATE TABLE RecommendedBranch (
    course TEXT NOT NULL,
    branch TEXT NOT NULL,
    program TEXT NOT NULL,
    PRIMARY KEY (course, branch, program)
);

CREATE TABLE Registered (
    student INT(10) NOT NULL,
    course TEXT NOT NULL,
    PRIMARY KEY (student, course)
);

CREATE TABLE Taken (
    student INT(10) NOT NULL,
    course TEXT NOT NULL,
    grade CHAR(1) DEFAULT 0 CHECK (grade IN (0,U,3,4,5)),
    PRIMARY KEY (student, course)
);

CREATE TABLE WaitingList (
    student INT(10) NOT NULL,
    course TEXT NOT NULL,
    position INT NOT NULL,
    PRIMARY KEY (student, course)
);
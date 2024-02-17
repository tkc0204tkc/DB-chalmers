CREATE TABLE Departments (
    name TEXT NOT NULL,
    abbr VARCHAR PRIMARY KEY,
    UNIQUE (name)
);

CREATE TABLE Programs (
    name TEXT PRIMARY KEY,
    abbr VARCHAR NOT NULL
);

CREATE TABLE Host (
    department VARCHAR NOT NULL,
    program TEXT NOT NULL,
    FOREIGN KEY (department) REFERENCES Departments(abbr),
    FOREIGN KEY (program) REFERENCES Programs(name),
    PRIMARY KEY (department, program)
);

CREATE TABLE Students (
    idnr CHAR(10) PRIMARY KEY,
    name TEXT NOT NULL,
    login TEXT NOT NULL,
    program TEXT NOT NULL,
    UNIQUE (login),
    UNIQUE (idnr, program),
    FOREIGN KEY (program) REFERENCES Programs(name)
);

CREATE TABLE Branches (
    name TEXT NOT NULL,
    program TEXT NOT NULL,
    FOREIGN KEY (program) REFERENCES Programs(name),
    PRIMARY KEY (name, program)
);

CREATE TABLE Courses (
    code CHAR(6) PRIMARY KEY,
    name TEXT NOT NULL, 
    credits FLOAT CHECK (credits > 0) NOT NULL,
    department VARCHAR NOT NULL,
    FOREIGN KEY (department) REFERENCES Departments(abbr)
);

CREATE TABLE Prerequisites (
    code CHAR(6) NOT NULL,
    prerequisites CHAR(6) NOT NULL,
    FOREIGN KEY (code) REFERENCES Courses(code),
    FOREIGN KEY (prerequisites) REFERENCES Courses(code),
    PRIMARY KEY (code, prerequisites)
);

CREATE TABLE LimitedCourses (
    code CHAR(6) PRIMARY KEY,
    capacity INT CHECK (capacity > 0) NOT NULL,
    FOREIGN KEY (code) REFERENCES Courses(code)
);

CREATE TABLE StudentBranches (
    student CHAR(10) PRIMARY KEY,
    branch TEXT NOT NULL,
    program TEXT NOT NULL,
    FOREIGN KEY (student) REFERENCES Students(idnr),
    FOREIGN KEY (student, program) REFERENCES Students(idnr, program),
    FOREIGN KEY (branch, program) REFERENCES Branches(name, program)
);

CREATE TABLE Classifications (
    name TEXT PRIMARY KEY
);

CREATE TABLE Classified (
    course CHAR(6) NOT NULL,
    classification TEXT NOT NULL,
    FOREIGN KEY (course) REFERENCES Courses(code),
    FOREIGN KEY (classification) REFERENCES Classifications(name),
    PRIMARY KEY (course, classification)
);

CREATE TABLE MandatoryProgram (
    course CHAR(6) NOT NULL,
    program TEXT NOT NULL,
    FOREIGN KEY (course) REFERENCES Courses(code),
    FOREIGN KEY (program) REFERENCES Programs(name),
    PRIMARY KEY (course, program)
);

CREATE TABLE MandatoryBranch (
    course CHAR(6) NOT NULL,
    branch TEXT NOT NULL,
    program TEXT NOT NULL,
    FOREIGN KEY (course) REFERENCES Courses(code),
    FOREIGN KEY (branch, program) REFERENCES Branches(name, program),
    PRIMARY KEY (course, branch, program)
);

CREATE TABLE RecommendedBranch (
    course CHAR(6) NOT NULL,
    branch TEXT NOT NULL,
    program TEXT NOT NULL,
    FOREIGN KEY (course) REFERENCES Courses(code),
    FOREIGN KEY (branch, program) REFERENCES Branches(name, program),
    PRIMARY KEY (course, branch, program)
);

CREATE TABLE Registered (
    student CHAR(10) NOT NULL,
    course CHAR(6) NOT NULL,
    FOREIGN KEY (student) REFERENCES Students(idnr),
    FOREIGN KEY (course) REFERENCES Courses(code),
    PRIMARY KEY (student, course)
);

CREATE TABLE Taken (
    student CHAR(10) NOT NULL,
    course CHAR(6) NOT NULL,
    grade CHAR(1) CHECK (grade IN ('U','3','4','5')) NOT NULL,
    FOREIGN KEY (student) REFERENCES Students(idnr),
    FOREIGN KEY (course) REFERENCES Courses(code),
    PRIMARY KEY (student, course)
);

CREATE TABLE WaitingList (
    student CHAR(10) NOT NULL,
    course CHAR(6) NOT NULL,
    position INT NOT NULL,
    FOREIGN KEY (student) REFERENCES Students(idnr),
    FOREIGN KEY (course) REFERENCES LimitedCourses(code),
    PRIMARY KEY (student, course),
    UNIQUE (course, position)
);


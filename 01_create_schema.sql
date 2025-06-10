-- Criação do banco de dados
CREATE DATABASE company;
GO

USE company;
GO

-- Desabilita verificações temporariamente para evitar erros com relações circulares
EXEC sp_MSforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all";
GO

-- =============================================
-- TABELA EMPLOYEE (com auto-relacionamento)
-- =============================================
CREATE TABLE employee (
    Fname VARCHAR(15) NOT NULL,
    Minit CHAR(1),
    Lname VARCHAR(15) NOT NULL,
    Ssn CHAR(9) NOT NULL,
    Bdate DATE,
    Address VARCHAR(30),
    Sex CHAR(1),
    Salary DECIMAL(10,2),
    Super_ssn CHAR(9),
    Dno INT NOT NULL DEFAULT 1,
    CONSTRAINT chk_salary_employee CHECK (Salary > 2000.0),
    CONSTRAINT pk_employee PRIMARY KEY (Ssn)
);
GO

ALTER TABLE employee 
ADD CONSTRAINT fk_employee 
FOREIGN KEY (Super_ssn) REFERENCES employee(Ssn)
ON DELETE NO ACTION
ON UPDATE NO ACTION;
GO

-- =============================================
-- TABELA DEPARTMENT
-- =============================================
CREATE TABLE departament (
    Dname VARCHAR(15) NOT NULL,
    Dnumber INT NOT NULL,
    Mgr_ssn CHAR(9) NOT NULL,
    Mgr_start_date DATE, 
    Dept_create_date DATE,
    CONSTRAINT chk_date_dept CHECK (Dept_create_date < Mgr_start_date),
    CONSTRAINT pk_dept PRIMARY KEY (Dnumber),
    CONSTRAINT unique_name_dept UNIQUE(Dname)
);
GO

ALTER TABLE departament
ADD CONSTRAINT fk_dept 
FOREIGN KEY (Mgr_ssn) REFERENCES employee(Ssn)
ON UPDATE NO ACTION;
GO

-- =============================================
-- TABELA DEPT_LOCATIONS
-- =============================================
CREATE TABLE dept_locations (
    Dnumber INT NOT NULL,
    Dlocation VARCHAR(15) NOT NULL,
    CONSTRAINT pk_dept_locations PRIMARY KEY (Dnumber, Dlocation),
    CONSTRAINT fk_dept_locations FOREIGN KEY (Dnumber) REFERENCES departament(Dnumber)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
GO

-- =============================================
-- TABELA PROJECT
-- =============================================
CREATE TABLE project (
    Pname VARCHAR(15) NOT NULL,
    Pnumber INT NOT NULL,
    Plocation VARCHAR(15),
    Dnum INT NOT NULL,
    CONSTRAINT pk_project PRIMARY KEY (Pnumber),
    CONSTRAINT unique_project UNIQUE (Pname),
    CONSTRAINT fk_project FOREIGN KEY (Dnum) REFERENCES departament(Dnumber)
);
GO

-- =============================================
-- TABELA WORKS_ON
-- =============================================
CREATE TABLE works_on (
    Essn CHAR(9) NOT NULL,
    Pno INT NOT NULL,
    Hours DECIMAL(3,1) NOT NULL,
    CONSTRAINT pk_works_on PRIMARY KEY (Essn, Pno),
    CONSTRAINT fk_employee_works_on FOREIGN KEY (Essn) REFERENCES employee(Ssn),
    CONSTRAINT fk_project_works_on FOREIGN KEY (Pno) REFERENCES project(Pnumber)
);
GO

-- =============================================
-- TABELA DEPENDENT
-- =============================================
CREATE TABLE dependent (
    Essn CHAR(9) NOT NULL,
    Dependent_name VARCHAR(15) NOT NULL,
    Sex CHAR(1),
    Bdate DATE,
    Relationship VARCHAR(8),
    CONSTRAINT pk_dependent PRIMARY KEY (Essn, Dependent_name),
    CONSTRAINT fk_dependent FOREIGN KEY (Essn) REFERENCES employee(Ssn)
);
GO

-- Reabilita todas as verificações de constraint
EXEC sp_MSforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all";
GO

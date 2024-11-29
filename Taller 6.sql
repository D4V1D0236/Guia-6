CREATE DATABASE SISTEMAS;
USE SISTEMAS;

-- Crear la tabla bloque
CREATE TABLE Bloque (
    bloqueId INT PRIMARY KEY,
    piso INT NOT NULL
);

-- Crear la tabla estudiante
CREATE TABLE Estudiante (
    codEst INT PRIMARY KEY,
    apellido VARCHAR(100) NOT NULL,
    nombre VARCHAR(100) NOT NULL
);

-- Crear la tabla curso
CREATE TABLE Curso (
    codCurso INT PRIMARY KEY,
    nombreCurso VARCHAR(100) NOT NULL,
    semestre INT NOT NULL
);

-- Crear la tabla profesor
CREATE TABLE Profesor (
    profesorId INT AUTO_INCREMENT PRIMARY KEY,
    apellidoProf VARCHAR(100) NOT NULL,
    nombreProf VARCHAR(100) NOT NULL,
    bloqueId INT,
    ofProf VARCHAR(50),
    FOREIGN KEY (bloqueId) REFERENCES Bloque(bloqueId)
);

-- Crear la tabla EstudianteCurso (Relacionar curso, estudiante y profesor)
CREATE TABLE EstudianteCurso (
    codEst INT,
    codCurso INT,
    nota DECIMAL(5,2),
    profesorId INT,
    PRIMARY KEY (codEst, codCurso, profesorId),
    FOREIGN KEY (codEst) REFERENCES Estudiante(codEst),
    FOREIGN KEY (codCurso) REFERENCES Curso(codCurso),
    FOREIGN KEY (profesorId) REFERENCES Profesor(profesorId)
);

INSERT INTO Bloque (bloqueId, piso) VALUES 
(2, 2),
(3, 3),
(4, 2);

INSERT INTO Estudiante (codEst, apellido, nombre) VALUES 
(10, 'andres', 'gomez'),
(20, 'maria', 'hurtado'),
(30, 'camilo', 'montoya'),
(40, 'ana', 'medina');

INSERT INTO Curso (codCurso, nombreCurso, semestre) VALUES 
(10, 'logica', 1),
(20, 'prog', 2),
(30, 'bases', 3),
(40, 'estructuras', 3);

INSERT INTO Profesor (apellidoProf, nombreProf, bloqueId, ofProf) VALUES 
('rodriguez', 'carlos', 2, '201'),
('mantilla', 'pedro', 3, '305'),
('cardenas', 'juan', 2, '202'),
('victoria', 'caceres', 4, '201');

INSERT INTO EstudianteCurso (codEst, codCurso, nota, profesorId) VALUES 
(10, 10, 3, 1), 
(10, 20, 2, 2),  
(10, 30, 3, 1),  
(20, 10, 4, 3),  
(30, 10, 3, 1),  
(30, 30, 4, 1),  
(40, 40, 3, 4); 

SELECT * FROM Estudiante e JOIN EstudianteCurso ec ON e.codEst = ec.codEst JOIN Curso c ON ec.codCurso = c.codCurso JOIN 
Profesor p ON ec.profesorId = p.profesorId JOIN Bloque b ON p.bloqueId = b.bloqueId ORDER BY e.codEst, c.codCurso;
	CREATE DATABASE UniversidadUAN;

	USE UniversidadUAN;
    ALTER TABLE Estudiante ADD COLUMN promedio DECIMAL(3,2) DEFAULT 0;


	CREATE TABLE Estudiante(
		codigo INT UNIQUE PRIMARY KEY auto_increment,
		nombre VARCHAR(50) NOT NULL,
		apellido VARCHAR(50) NOT NULL
	);
	CREATE TABLE Curso(
		codigo INT UNIQUE PRIMARY KEY auto_increment,
		departamento ENUM('Matematicas','Fisica','Sistemas','Biologia') NOT NULL,
		nombre VARCHAR(50) NOT NULL,
		creditos INT NOT NULL,
		nota DECIMAL(3,2) NOT NULL
	);
	CREATE TABLE RegistrarNotas(
		id_registro INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
		estudiante_codigo INT NOT NULL,
		curso_codigo INT NOT NULL,
		nota DECIMAL (3,2) NOT NULL CHECK(nota BETWEEN 1.5 AND 5),
		FOREIGN KEY (estudiante_codigo) REFERENCES Estudiante(codigo),
		FOREIGN KEY (curso_codigo) REFERENCES Curso(codigo)   
	);

	INSERT INTO Estudiante (nombre, apellido)
	VALUES
		('Juanita','Perez'),
		('Andres','Martinez'),
		('Alberto','Gomez'),
		('Isabella','Murillo');
		
	INSERT INTO Curso(departamento, nombre, creditos, nota)
	VALUES
		('Matemáticas','Matematicas Discretas',3,0),
		('Física','Electromecánica',4,0),
		('Sistemas','TGS',3,0),
		('Biología','Anatomia',2,0);

	INSERT INTO RegistrarNotas(estudiante_codigo, curso_codigo, nota)
	VALUES
		(1,4,2.50),
		(2,3,4.25),
		(3,2,3.50),
		(4,1,4.75);
		
	SELECT * FROM RegistrarNotas;	
	SELECT * FROM Curso;
	SELECT * FROM Estudiante INNER JOIN RegistrarNotas;

	ALTER TABLE Curso ADD COLUMN promedio DECIMAL(3,2);


	CREATE INDEX idx_nombre_estudiante ON Estudiante(nombre);
	CREATE INDEX idx_apellido_estudiante ON Estudiante(apellido);

	CREATE INDEX idx_departamento_curso ON Curso(departamento);
	CREATE INDEX idx_nombre_curso ON Curso(nombre);
	CREATE INDEX idx_creditos_curso ON Curso(creditos);

	CREATE INDEX idx_estudiante_codigo_notas ON RegistrarNotas(estudiante_codigo);
	CREATE INDEX idx_curso_codigo_notas ON  RegistrarNotas(curso_codigo);
	CREATE INDEX idx_nota_notas ON RegistrarNotas(nota);

	ALTER TABLE Curso MODIFY COLUMN nota DECIMAL (3,2) NOT NULL DEFAULT 0;

	SELECT nombre FROM Estudiante WHERE promedio >= 0;
	SELECT nombre FROM Estudiante WHERE apellido != 'Martinez';


	CREATE USER 'abc'@'localhost';

	GRANT SELECT ON UniversidadUAN.Estudiante TO 'abc'@'localhost';
	GRANT SELECT ON UniversidadUAN.RegistrarNotas TO 'abc'@'localhost';

	REVOKE SELECT ON UniversidadUAN.RegistrarNotas FROM 'abc'@'localhost';

	FLUSH PRIVILEGES;
	SHOW GRANTS FOR 'abc'@'localhost';

	CREATE VIEW VistaNotas 
	AS SELECT
		c.nombre AS nombre_curso,
		e.nombre AS nombre_estudiante,
		e.apellido AS nombre_apellido,
		r.nota AS nota
		FROM Estudiante e JOIN RegistrarNotas r ON e.codigo = r.Estudiante_codigo
		JOIN curso c ON c.codigo = r.curso_codigo;

	SELECT * FROM VistaNotas;
    
-- Calcular y actualizar el promedio de un estudiante 
DELIMITER $$
CREATE PROCEDURE CalcularPromedioEstudiante(IN p_estudiante_codigo INT)
BEGIN
    DECLARE v_promedio DECIMAL(3,2);
    
    -- Calcular el promedio de notas para el estudiante específico
    SELECT AVG(nota) INTO v_promedio
    FROM RegistrarNotas
    WHERE estudiante_codigo = p_estudiante_codigo;
    
    -- Actualizar el promedio en la tabla Estudiante
    UPDATE Estudiante 
    SET promedio = ROUND(v_promedio, 2)
    WHERE codigo = p_estudiante_codigo;
    
    -- Devolver el promedio calculado
    SELECT v_promedio AS promedio_estudiante;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER ActualizarPromedioCurso 
AFTER INSERT ON RegistrarNotas
FOR EACH ROW
BEGIN
    DECLARE v_promedio_curso DECIMAL(3,2);
    
    -- Calcular el promedio de notas para el curso específico
    SELECT AVG(nota) INTO v_promedio_curso
    FROM RegistrarNotas
    WHERE curso_codigo = NEW.curso_codigo;
    
    -- Actualizar el promedio en la tabla Curso
    UPDATE Curso
    SET promedio = ROUND(v_promedio_curso, 2)
    WHERE codigo = NEW.curso_codigo;
END $$
DELIMITER ;

CALL CalcularPromedioEstudiante(1); 
CALL CalcularPromedioEstudiante(2);

INSERT INTO RegistrarNotas (estudiante_codigo, curso_codigo, nota)
VALUES (1, 1, 2.0);

SELECT * FROM Estudiante;
SELECT * FROM Curso;
SELECT * FROM RegistrarNotas;
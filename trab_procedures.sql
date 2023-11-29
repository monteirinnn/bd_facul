-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS sistemas_informacao;
USE sistemas_informacao;

-- Tabela de Alunos
CREATE TABLE IF NOT EXISTS Alunos (
    aluno_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    endereco VARCHAR(255),
    telefone VARCHAR(15),
    status ENUM('ativo', 'inativo') DEFAULT 'ativo'
);

-- Tabela de Cursos
CREATE TABLE IF NOT EXISTS Cursos (
    curso_id INT AUTO_INCREMENT PRIMARY KEY,
    nome_curso VARCHAR(255) NOT NULL
);

-- Tabela de Turmas
CREATE TABLE IF NOT EXISTS Turmas (
    turma_id INT AUTO_INCREMENT PRIMARY KEY,
    curso_id INT,
    nome_turma VARCHAR(255) NOT NULL,
    FOREIGN KEY (curso_id) REFERENCES Cursos(curso_id)
);

-- Tabela de Disciplinas
CREATE TABLE IF NOT EXISTS Disciplinas (
    disciplina_id INT AUTO_INCREMENT PRIMARY KEY,
    nome_disciplina VARCHAR(255) NOT NULL
);

-- Tabela de Matrículas
CREATE TABLE IF NOT EXISTS Matriculas (
    matricula_id INT AUTO_INCREMENT PRIMARY KEY,
    aluno_id INT,
    turma_id INT,
    disciplina_id INT,
    nota FLOAT,
    faltas INT,
    FOREIGN KEY (aluno_id) REFERENCES Alunos(aluno_id),
    FOREIGN KEY (turma_id) REFERENCES Turmas(turma_id),
    FOREIGN KEY (disciplina_id) REFERENCES Disciplinas(disciplina_id)
);

-- Tabela de Histórico
CREATE TABLE IF NOT EXISTS Historico (
    historico_id INT AUTO_INCREMENT PRIMARY KEY,
    aluno_id INT,
    turma_id INT,
    acao VARCHAR(255) NOT NULL,
    data_acao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (aluno_id) REFERENCES Alunos(aluno_id),
    FOREIGN KEY (turma_id) REFERENCES Turmas(turma_id)
);
DELIMITER //
CREATE PROCEDURE listar_alunos(IN turma_nome VARCHAR(255))
BEGIN
    SELECT Alunos.nome
    FROM Alunos
    JOIN Matriculas ON Alunos.aluno_id = Matriculas.aluno_id
    JOIN Turmas ON Matriculas.turma_id = Turmas.turma_id
    WHERE Turmas.nome_turma = turma_nome;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE remove_aluno(IN aluno_id_param INT, IN turma_id_param INT)
BEGIN
    DELETE FROM Matriculas
    WHERE aluno_id = aluno_id_param AND turma_id = turma_id_param;
    
    INSERT INTO Historico (aluno_id, turma_id, acao)
    VALUES (aluno_id_param, turma_id_param, 'Remoção de Aluno');
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE transfere_aluno(IN aluno_id_param INT, IN turma_origem_id INT, IN turma_destino_id INT)
BEGIN
    UPDATE Matriculas
    SET turma_id = turma_destino_id
    WHERE aluno_id = aluno_id_param AND turma_id = turma_origem_id;

    INSERT INTO Historico (aluno_id, turma_id, acao)
    VALUES (aluno_id_param, turma_destino_id, 'Transferência de Aluno');
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE totalAlunos(IN turma_nome VARCHAR(255))
BEGIN
    SELECT COUNT(*) AS total_alunos
    FROM Matriculas
    JOIN Turmas ON Matriculas.turma_id = Turmas.turma_id
    WHERE Turmas.nome_turma = turma_nome;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE listar_alunos_disciplina(IN disciplina_nome VARCHAR(255))
BEGIN
    SELECT Alunos.nome
    FROM Alunos
    JOIN Matriculas ON Alunos.aluno_id = Matriculas.aluno_id
    JOIN Disciplinas ON Matriculas.disciplina_id = Disciplinas.disciplina_id
    WHERE Disciplinas.nome_disciplina = disciplina_nome;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE calcular_media(IN turma_nome VARCHAR(255), IN disciplina_nome VARCHAR(255))
BEGIN
    -- Lógica para calcular média dos alunos em uma disciplina de uma turma
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE atualiza_contato(IN aluno_id_param INT, IN novo_email VARCHAR(255), IN novo_endereco VARCHAR(255), IN novo_telefone VARCHAR(15))
BEGIN
    UPDATE Alunos
    SET email = novo_email, endereco = novo_endereco, telefone = novo_telefone
    WHERE aluno_id = aluno_id_param;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE atualiza_status(IN aluno_id_param INT, IN novo_status ENUM('ativo', 'inativo'))
BEGIN
    UPDATE Alunos
    SET status = novo_status
    WHERE aluno_id = aluno_id_param;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE contar_faltas(IN aluno_id_param INT)
BEGIN
    SELECT SUM(faltas) AS total_faltas
    FROM Matriculas
    WHERE aluno_id = aluno_id_param;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE relatorio_notas(IN disciplina_nome VARCHAR(255))
BEGIN
    -- Lógica para gerar o relatório de notas de todos os alunos em uma disciplina
END //
DELIMITER ;

CREATE DATABASE ecommerce_db;
USE ecommerce_db;

CREATE TABLE clientes (
cliente_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
nome VARCHAR(100) NOT NULL,
email VARCHAR(100) UNIQUE NOT NULL,
senha_hash VARCHAR(255) NOT NULL,
telefone VARCHAR(20),
data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE enderecos (
    endereco_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    cliente_id INT NOT NULL,
    logradouro VARCHAR(200) NOT NULL,
    numero VARCHAR(10),
    complemento VARCHAR(50),
    cep VARCHAR(10) NOT NULL,
    cidade VARCHAR(50) NOT NULL,
    estado CHAR(2) NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
);

CREATE TABLE categorias (
    categoria_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    nome VARCHAR(50) NOT NULL,
    descricao TEXT
);

CREATE TABLE produtos (
    produto_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10, 2) NOT NULL,
    estoque INT NOT NULL DEFAULT 0,
    categoria_id INT,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (categoria_id) REFERENCES categorias(categoria_id)
);

CREATE TABLE pedidos (
    pedido_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    cliente_id INT NOT NULL,
    endereco_id INT NOT NULL,
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pendente', 'processando', 'enviado', 'entregue', 'cancelado') DEFAULT 'pendente',
    total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id),
    FOREIGN KEY (endereco_id) REFERENCES enderecos(endereco_id)
);

CREATE TABLE itens_pedido (
    item_id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    pedido_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(pedido_id),
    FOREIGN KEY (produto_id) REFERENCES produtos(produto_id)
);

CREATE TABLE pagamentos (
    pagamento_id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    metodo ENUM('cartao', 'pix', 'boleto') NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    status ENUM('pendente', 'aprovado', 'recusado') DEFAULT 'pendente',
    data_processamento DATETIME,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(pedido_id)
);

CREATE TABLE avaliacoes (
    avaliacao_id INT AUTO_INCREMENT PRIMARY KEY,
    produto_id INT NOT NULL,
    cliente_id INT NOT NULL,
    nota TINYINT NOT NULL CHECK (nota BETWEEN 1 AND 5),
    comentario TEXT,
    data_avaliacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (produto_id) REFERENCES produtos(produto_id),
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
);

INSERT INTO clientes (nome, email, senha_hash, telefone)
VALUES 
('Alice Lima', 'alice@example.com', 'hash1', '81999990001'),
('Bruno Souza', 'bruno@example.com', 'hash2', '81999990002'),
('Carla Mendes', 'carla@example.com', 'hash3', '81999990003'),
('Daniel Oliveira', 'daniel@example.com', 'hash4', '81999990004'),
('Eduarda Castro', 'eduarda@example.com', 'hash5', '81999990005');

INSERT INTO enderecos (cliente_id, logradouro, numero, complemento, cep, cidade, estado)
VALUES
(1, 'Rua das Flores', '123', 'Apto 101', '50000-000', 'Recife', 'PE'),
(2, 'Av. Brasil', '456', '', '60000-000', 'Fortaleza', 'CE'),
(3, 'Rua Verde', '789', 'Casa', '70000-000', 'Salvador', 'BA'),
(4, 'Rua da Alegria', '321', '', '40000-000', 'João Pessoa', 'PB'),
(5, 'Av. Central', '654', 'Apto 201', '30000-000', 'Natal', 'RN');

INSERT INTO categorias (nome, descricao)
VALUES
('Eletrônicos', 'Produtos eletrônicos em geral'),
('Roupas', 'Vestuário masculino e feminino'),
('Livros', 'Livros de diversos gêneros'),
('Acessórios', 'Relógios, pulseiras e mais'),
('Games', 'Jogos e consoles'),
('Beleza', 'Produtos para cuidados pessoais');

INSERT INTO produtos (nome, descricao, preco, estoque, categoria_id)
VALUES
('Smartphone X', 'Um celular muito bom', 1500.00, 5, 1),
('Notebook Y', 'Notebook potente para trabalho', 3500.00, 1, 1),
('Camisa Polo', 'Camisa confortável', 80.00, 30, 2),
('Calça Jeans', 'Calça resistente', 120.00, 10, 2),
('Livro de SQL', 'Aprenda SQL do básico ao avançado', 60.00, 0, 3),
('Livro de HTML', 'Fundamentos de HTML e CSS', 40.00, 100, 3),
('Relógio Digital', 'Relógio com funções de alarme', 150.00, 15, 4),
('Pulseira Fitness', 'Monitora passos e batimentos', 200.00, 8, 4),
('Console Z', 'Console de última geração', 4000.00, 2, 5),
('Jogo de Corrida', 'Jogo de corrida realista', 300.00, 20, 5),
('Creme Facial', 'Hidrata e protege a pele', 90.00, 25, 6),
('Perfume Elegante', 'Fragrância marcante e duradoura', 220.00, 10, 6);

INSERT INTO pedidos (cliente_id, endereco_id, data_pedido, status, total)
VALUES 
-- Cliente 1 - Pedido entregue mês passado
(1, 1, '2025-03-10', 'entregue', 1580.00),

-- Cliente 2 - Pedido entregue
(2, 2, '2025-03-15', 'entregue', 160.00),

-- Cliente 1 - Pedido atual (em envio)
(1, 1, '2025-04-01', 'enviado', 80.00),

-- Cliente 3 - Pedido atual (pendente)
(3, 3, '2025-04-10', 'pendente', 40.00),

-- Cliente 4 - Pedido cancelado
(4, 4, '2025-03-05', 'cancelado', 3500.00),

-- Cliente 5 - Pedido em processamento
(5, 5, '2025-04-05', 'processando', 200.00);

INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unitario)
VALUES 
-- Pedido 1: Cliente 1
(1, 1, 1, 1500.00),
(1, 3, 1, 80.00),

-- Pedido 2: Cliente 2
(2, 3, 1, 80.00),
(2, 4, 1, 80.00),

-- Pedido 3: Cliente 1
(3, 3, 1, 80.00),

-- Pedido 4: Cliente 3
(4, 6, 1, 40.00),

-- Pedido 5: Cliente 4
(5, 2, 1, 3500.00),

-- Pedido 6: Cliente 5
(6, 3, 2, 80.00),
(6, 4, 1, 40.00);

INSERT INTO pagamentos (pedido_id, metodo, valor, status, data_processamento)
VALUES 
(1, 'cartao', 1580.00, 'aprovado', '2025-03-11'),
(2, 'pix', 160.00, 'aprovado', '2025-03-16'),
(3, 'boleto', 80.00, 'pendente', NULL),
(4, 'pix', 40.00, 'pendente', NULL),
(5, 'cartao', 3500.00, 'recusado', '2025-03-06'),
(6, 'pix', 200.00, 'aprovado', '2025-04-06');

INSERT INTO avaliacoes (produto_id, cliente_id, nota, comentario)
VALUES 
(1, 1, 5, 'Excelente produto!'),
(3, 2, 4, 'Muito bom'),
(4, 2, 3, 'Serviu bem'),
(6, 3, 5, 'Perfeito para iniciantes!'),
(3, 5, 4, 'Gostei bastante da qualidade!');


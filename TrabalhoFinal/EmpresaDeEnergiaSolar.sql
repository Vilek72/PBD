Create Database TrabalhoFinal;
Use TrabalhoFinal;

CREATE TABLE Cliente (
    idCliente INT AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    PRIMARY KEY (idCliente)
);

CREATE TABLE TelefoneCliente (
    idCliente INT,
    numTelefone VARCHAR(11),
    PRIMARY KEY (numTelefone),
    FOREIGN KEY (idCliente)
        REFERENCES Cliente (idCliente)
);



CREATE TABLE PessoaFisica (
    cpf VARCHAR(11),
    idCliente INT,
    endereco VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (cpf),
    FOREIGN KEY (idCliente)
        REFERENCES Cliente (idCliente)
);


CREATE TABLE PessoaJuridica (
    cnpj VARCHAR(14),
    nomeEmpresa VARCHAR(50) NOT NULL,
    endEmpresa VARCHAR(255) DEFAULT NULL,
    idCliente INT,
    PRIMARY KEY (cnpj),
    FOREIGN KEY (idCliente)
        REFERENCES Cliente (idCliente)
);

CREATE TABLE Fornecedor (
    idFornec INT AUTO_INCREMENT,
    cnpjFornec VARCHAR(14) UNIQUE,
    nomeFornec VARCHAR(50) NOT NULL,
    endFornec VARCHAR(255) DEFAULT NULL,
    PRIMARY KEY (idFornec)
);

CREATE TABLE TelefoneFornecedor (
    idFornec INT,
    numTelefone VARCHAR(11),
    PRIMARY KEY (numTelefone),
    FOREIGN KEY (idFornec)
        REFERENCES Fornecedor (idFornec)
);

CREATE TABLE Funcionario (
    idFunc INT AUTO_INCREMENT,
    cpfFunc VARCHAR(11) UNIQUE,
    nomeFunc VARCHAR(50) NOT NULL,
    nascFunc DATE,
    endFunc VARCHAR(255),
    PRIMARY KEY (idFunc)
);

CREATE TABLE Tecnico (
    idFunc INT,
    salario NUMERIC(12 , 2 ),
    servicos INT,
    FOREIGN KEY (idFunc)
        REFERENCES Funcionario (idFunc)
);

CREATE TABLE Vendedor (
    idFunc INT,
    salario NUMERIC(12 , 2 ),
    vendas INT,
    FOREIGN KEY (idFunc)
        REFERENCES Funcionario (idFunc)
);

CREATE TABLE Venda (
    codPedido INT AUTO_INCREMENT,
    idCliente INT,
    idFunc INT,
    valor NUMERIC(12 , 2 ),
    dataVenda DATE NOT NULL,
    PRIMARY KEY (codPedido),
    FOREIGN KEY (idCliente)
        REFERENCES Cliente (idCliente),
    FOREIGN KEY (idFunc)
        REFERENCES Funcionario (idFunc)
);

CREATE TABLE Instalação (
    codPedido INT,
    idFunc INT,
    dataInst DATE NOT NULL,
    FOREIGN KEY (codPedido)
        REFERENCES Venda (codPedido),
    FOREIGN KEY (idFunc)
        REFERENCES Funcionario (idFunc)
);

CREATE TABLE ProdutoTipo (
    idProduto INT AUTO_INCREMENT,
    idFornec INT,
    preco NUMERIC(12 , 2 ) DEFAULT 0,
    nome VARCHAR(100) NOT NULL,
    PRIMARY KEY (idProduto),
    FOREIGN KEY (idFornec)
        REFERENCES Fornecedor (idFornec)
);

CREATE TABLE ProdutoVenda (
    codPedido INT,
    idProduto INT,
    quantidade INT,
    FOREIGN KEY (codPedido)
        REFERENCES Venda (codPedido),
    FOREIGN KEY (idProduto)
        REFERENCES ProdutoTipo (idProduto)
);

CREATE TABLE ProdutoCliente (
    idCliente INT,
    idProduto INT,
    idFunc INT,
    dataInst DATE,
    consumo DOUBLE,
    FOREIGN KEY (idCliente)
        REFERENCES Cliente (idCliente),
    FOREIGN KEY (idFunc)
        REFERENCES Funcionario (idFunc)
);

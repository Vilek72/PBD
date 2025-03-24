CREATE SCHEMA EmpresaNome;

Create Table Cliente (
idCliente		int				auto_increment,
nome			varchar(100)	NOT NULL,

PRIMARY KEY (idCliente)

);

Create Table Telefone (
idCliente		int,
numTelefone		varchar(11),

PRIMARY KEY (numTelefone),
FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)

);

Create Table PessoaFisica (
cpf				varchar(11),
idCliente		int,
endereco		varchar(255)	DEFAULT NULL,

PRIMARY KEY (cpf),
FOREIGN KEY (idCliente) REFERENCES Cliente(id)
);


Create Table PessoaJuridica (
cpnj			varchar(13),
nomeEmpresa		varchar(50),
endEmpresa		varchar(255)	DEFAULT NULL,
idCliente		int,

PRIMARY KEY (cnpj),
FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

Create Table Fornecedor (
idFunc			int				AUTO_INCREMENT,
cnpjFornec		varchar(13)		UNIQUE,
nomeFornec		varchar(50)		NOT NULL,
endFornec		varchar(255)	DEFAULT NULL,

PRIMARY KEY (id)
);



Create Table Funcionario (
idFunc			int				AUTO_INCREMENT,
cpfFunc			varchar(11)		UNIQUE,
nomeFunc		varchar(50)		NOT NULL,
nascFunc		date,
endFunc			varchar(255),

PRIMARY KEY (idFunc)
);

Create Table Tecnico (
idFunc			int,
salario			numeric(12,2),
servicos		int			AUTO_INCREMENT,

FOREIGN KEY (idFunc) REFERENCES Funcionario(idFunc)
);

Create Table Vendedor (
idFunc		int,
salario		numeric(12,2),
vendas		int				AUTO_INCREMENT,

FOREIGN KEY (idFunc) REFERENCES Funcionario(idFunc)

);

Create Table Administrador (
idFunc		int,
salario		numeric(12,2),
idGerente	int				AUTO_INCREMENT,

PRIMARY KEY (idGerente),
FOREIGN KEY (idFunc) REFERENCES Funcionario(id)

);

Create Table Venda (
codPedido		int,
idCliente		int,
idFunc			int,
valor			double,
dataVenda		date		NOT NULL,


PRIMARY KEY (codPedido),
FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente),
FOREIGN KEY (idFunc) REFERENCES Funcionario(idFunc)

);

Create Table Instalação (
codPedido		int,
idFunc			int,
dataInst		date		NOT NULL,

FOREIGN KEY (codPedido) REFERENCES Venda(codPedido),
FOREIGN KEY (idFunc) REFERENCES Funcionario(idFunc)

);

Create Table ProdutoVenda (
codPedido		int,
idProduto		int,
quantidade		int,

FOREIGN KEY (codPedido) REFERENCES Pedido(codPedido),
FOREIGN KEY (idProduto) REFERENCES ProdutoTipo(idProduto)

);

Create Table ProdutoTipo (
idProduto		int					AUTO_INCREMENT,
idFornec		int,
nome			varchar(100)		NOT NULL,

PRIMARY KEY (idProduto),
FOREIGN KEY (idFornec) REFERENCES Fornecedor(idFornec)

);

Create Table ProdutoCliente (
idCliente		int,
idProduto		int,
idFunc			int,
dataInst		date,
consumo			double,

FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente),
FOREIGN KEY (idFunc) REFERENCES Funcionario(idFunc)

);

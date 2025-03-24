
CREATE SCHEMA EmpresaNome;

Create Table Cliente (
idCliente		int,
cpf				varchar(11)		DEFAULT NULL,
cnpj			varchar(13)		DEFAULT NULL,

PRIMARY KEY (idCliente),
FOREIGN KEY	(cpf) REFERENCES PessoaFisica(cpf),
FOREIGN KEY (cnpj) REFERENCES PessoaJuridica(cnpj)

);

Create Table PessoaFisica (
cpf				varchar(11),
idCliente		int,
nome			varchar(50)		NOT NULL,
endereco		varchar(255)	DEFAULT NULL,


PRIMARY KEY (cpf),
FOREIGN KEY (id_cliente) REFERENCES Cliente(id)
);

Create Table Telefone (
cpf				varchar(11),	
cnpj			varchar(13),
num_telefone	varchar(11),

PRIMARY KEY (num_telefone),
FOREIGN KEY (cpf) REFERENCES PessoaFisica(cpf),
FOREIGN KEY (cnpj) REFERENCES PessoaJuridica(cnpj)

);

Create Table PessoaJuridica (
cpnj			varchar(13),
nomeEmpresa		varchar(50),
endEmpresa		varchar(255)	DEFAULT NULL,
id_cliente		int,


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
cpfCliente		varchar(11),
cnpjCliente		varchar(13),
idFunc			int,
valor			double,
dataVenda		date		NOT NULL,


PRIMARY KEY (codPedido),
FOREIGN KEY (cpfCliente) REFERENCES PessoaFisica(cpf),
FOREIGN KEY (cnpjCliente) REFERENCES PessoaJuridica(cnpj),
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
id_pedido		int,
id_produto		int,
quantidade		int,

FOREIGN KEY (id_pedido) REFERENCES Pedido(id),
FOREIGN KEY (id_produto) REFERENCES ProdutoTipo(id)

);

Create Table ProdutoTipo (
idProduto		int			AUTO_INCREMENT,
id_fornecedor	int,
descricao		varchar(200),

PRIMARY KEY (id),
FOREIGN KEY (idFornec) REFERENCES Fornecedor(idFornec)

);

Create Table ProdutoCliente (
id_cliente		int,
id_produto		int,
id_func			int,
data_inst		date,
consumo			double,

PRIMARY KEY (id_cliente),
FOREIGN KEY (id_cliente) REFERENCES Cliente(id),
FOREIGN KEY (id_func) REFERENCES Funcionario(id)

);




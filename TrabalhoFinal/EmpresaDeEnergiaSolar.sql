CREATE SCHEMA EmpresaNome;

Create Table Cliente (
id				int,
cpf_cliente		varchar(11)		DEFAULT NULL,
cnpj_cliente	varchar(13)		DEFAULT NULL,

PRIMARY KEY (id_cliente),
FOREIGN KEY	(cpf_cliente) REFERENCES PessoaFisica(cpf),
FOREIGN KEY (cnpj_cliente) REFERENCES PessoaJuridica(cnpj)

);

Create Table PessoaFisica (
cpf				varchar(11),
id_cliente		int,
nome			varchar(50)		NOT NULL,
endereco		varchar(255)	DEFAULT NULL,


PRIMARY KEY (cpf),
FOREIGN KEY (id_cliente) REFERENCES Cliente(id)
);

Create Table Telefone (
cpf_pessoa		varchar(11),	
cnpj_empresa	varchar(13),
num_telefone	varchar(11),

PRIMARY KEY (num_telefone),
FOREIGN KEY (cpf_pessoa) REFERENCES Pessoa(cpf)

);

Create Table PessoaJuridica (
cpnj			varchar(13),
nome			varchar(50),
endereco		varchar(255)	DEFAULT NULL,
id_cliente		int,


PRIMARY KEY (cnpj)
);

Create Table Fornecedor (
id				int				AUTO_INCREMENT,
cnpj			varchar(13)		UNIQUE,
nome			varchar(50)		NOT NULL,
endereco		varchar(255)	DEFAULT NULL,

PRIMARY KEY (id)
);



Create Table Funcionario (
id				int				AUTO_INCREMENT,
cpf				varchar(11)		UNIQUE,
nome			varchar(50)		NOT NULL,
data_nasc		date,
endereco		varchar(255),


PRIMARY KEY (id)
	
);

Create Table Tecnico (
id_func			int,
salario			float,
servicos		int			AUTO_INCREMENT,


FOREIGN KEY (id_func) REFERENCES Funcionario(id)

);

Create Table Vendedor (
id_func		int,
salario		float,
vendas		int		AUTO_INCREMENT,


FOREIGN KEY (id_func) REFERENCES Funcionario(id)

);

Create Table Administrador (
id_func		int,



FOREIGN KEY (id_func) REFERENCES Funcionario(id)

);



Create Table Pedido (
id				int			NOT NULL,
cpf_cliente		varchar(11),
cnpj_cliente	varchar(13),
id_atendente	int,
valor			double,
dataP			date		NOT NULL,


PRIMARY KEY (id),
FOREIGN KEY (cpf_cliente) REFERENCES PessoaFisica(cpf),
FOREIGN KEY (cnpj_cliente) REFERENCES PessoaJuridica(cnpj),
FOREIGN KEY (id_atendente) REFERENCES Funcionario(id)

);

Create Table ProdutoPedido (
id_pedido		int,
id_produto		int,
quantidade		int,

FOREIGN KEY (id_pedido) REFERENCES Pedido(id),
FOREIGN KEY (id_produto) REFERENCES ProdutoTipo(id)

);

Create Table ProdutoTipo (
id				int			AUTO_INCREMENT,
id_fornecedor	int,
descricao		varchar(200),

PRIMARY KEY (id),
FOREIGN KEY (id_fornecedor) REFERENCES Fornecedor

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



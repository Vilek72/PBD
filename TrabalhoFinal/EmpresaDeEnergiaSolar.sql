Create Table PessoaFisica (
cpf				varchar(11),
nome			varchar(50),

PRIMARY KEY (cpf));

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

PRIMARY KEY (cnpj)
);

Create Table Fornecedor (
id				int,
cnpj_empresa	varchar(13),
endereco		varchar(255),

PRIMARY KEY (id),
FOREIGN KEY (cnpj) REFERENCES PessoaJuridica(cnpj)

);

Create Table Funcionario (
id			int,
cpf_func		varchar(11),

PRIMARY KEY (id),
FOREIGN KEY (cpf_func) REFERENCES PessoaFisica(cpf)
	
);

Create Table Tecnico (
id_func		int,

FOREIGN KEY (id_func) REFERENCES Funcionrio(id)

);

Create Table Vendedor (
id_func		int,

FOREIGN KEY (id_func) REFERENCES Funcionrio(id)

);

Create Table Administrador (
id_func		int,

FOREIGN KEY (id_func) REFERENCES Funcionario(id)

);

Create Table Cliente (
id_cliente		int,
cpf_cliente		varchar(11),
cnpj_cliente	varchar(13),

PRIMARY KEY (id_cliente),
FOREIGN KEY	(cpf_cliente) REFERENCES PessoaFisica(cpf),
FOREIGN KEY (cnpj_cliente) REFERENCES PessoaJuridica(cnpj)

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
id				int,
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



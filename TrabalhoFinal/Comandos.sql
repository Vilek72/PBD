INSERT INTO Cliente (nome) VALUES 
('João Silva'),
('Maria Oliveira'),
('Empresa ABC Ltda'),
('Carlos Souza'),
('Tech Solutions SA');

INSERT INTO PessoaFisica (cpf, idCliente, endereco) VALUES 
('12345678901', 1, 'Rua A, 100 - São Paulo/SP'),
('98765432109', 2, 'Av. B, 200 - Rio de Janeiro/RJ'),
('45678912304', 4, 'Rua C, 300 - Belo Horizonte/MG');

INSERT INTO PessoaJuridica (cnpj, nomeEmpresa, endEmpresa, idCliente) VALUES 
('12345678000190', 'Empresa ABC Ltda', 'Av. X, 1000 - São Paulo/SP', 3),
('98765432000181', 'Tech Solutions SA', 'Rua Y, 2000 - Campinas/SP', 5);

INSERT INTO TelefoneCliente (idCliente, numTelefone) VALUES 
(1, '53987654321'),
(2, '51987654321'),
(3, '5333334444'),
(4, '5333335555'),
(5, '5333336666');

INSERT INTO Fornecedor (cnpjFornec, nomeFornec, endFornec) VALUES 
('11222333000144', 'Fornecedor Alpha', 'Rua Z, 500 - São Paulo/SP'),
('44555666000177', 'Fornecedor Beta', 'Av. W, 600 - Curitiba/PR');

INSERT INTO TelefoneFornecedor (idFornec, numTelefone) VALUES 
(1, '53456456456'),
(2, '53908789795');

INSERT INTO Funcionario (cpfFunc, nomeFunc, nascFunc, endFunc) VALUES 
('11122233344', 'Pedro Alves', '1980-05-15', 'Rua F, 100 - São Paulo/SP'),
('55566677788', 'Ana Costa', '1985-08-20', 'Av. G, 200 - São Paulo/SP'),
('99988877766', 'Marcos Lima', '1975-03-10', 'Rua H, 300 - Campinas/SP'),
('33344455566', 'Juliana Santos', '1990-11-25', 'Av. I, 400 - São Paulo/SP');

INSERT INTO Tecnico (idFunc, salario, servicos) VALUES 
(1, 3500.00, 0),
(2, 3800.00, 0);

INSERT INTO Vendedor (idFunc, salario, vendas) VALUES 
(3, 3000.00, 0),
(4, 5000.00, 0);

INSERT INTO ProdutoTipo (idFornec, nome, preco) VALUES 
(1, 'Ar-condicionado Split 12.000 BTUs', 2500.00),
(1, 'Ar-condicionado Split 18.000 BTUs', 3200.00),
(2, 'Purificador de Água', 800.00),
(2, 'Climatizador de Ar', 1200.00);

INSERT INTO Venda (idCliente, idFunc, dataVenda) VALUES 
(1, 3, '2023-01-15'),
(3, 3, '2023-02-20'),
(4, 3, '2023-03-10');

INSERT INTO ProdutoVenda (codPedido, idProduto, quantidade) VALUES 
(1, 1, 1),
(1, 3, 2),
(2, 2, 3),
(3, 4, 1),
(3, 1, 1);

INSERT INTO Instalação (codPedido, idFunc, dataInst) VALUES 
(1, 1, '2023-01-16'),
(2, 2, '2023-02-21'),
(3, 1, '2023-03-11');

SELECT c.idCliente, c.nome, t.numTelefone
FROM Cliente c
INNER JOIN TelefoneCliente t ON c.idCliente = t.idCliente;

SELECT v.codPedido, c.nome AS cliente, f.nomeFunc AS vendedor, 
       v.dataVenda, v.valor
FROM Venda v
INNER JOIN Cliente c ON v.idCliente = c.idCliente
INNER JOIN Funcionario f ON v.idFunc = f.idFunc;

SELECT pv.codPedido, pt.nome AS produto, pv.quantidade, 
       pt.preco, (pv.quantidade * pt.preco) AS subtotal,
       f.nomeFornec AS fornecedor
FROM ProdutoVenda pv
INNER JOIN ProdutoTipo pt ON pv.idProduto = pt.idProduto
INNER JOIN Fornecedor f ON pt.idFornec = f.idFornec
ORDER BY pv.codPedido;

SELECT i.codPedido, f.nomeFunc AS tecnico, c.nome AS cliente, 
       i.dataInst, v.dataVenda
FROM Instalação i
INNER JOIN Funcionario f ON i.idFunc = f.idFunc
INNER JOIN Venda v ON i.codPedido = v.codPedido
INNER JOIN Cliente c ON v.idCliente = c.idCliente;

SELECT f.nomeFunc AS vendedor, COUNT(v.codPedido) AS total_vendas, 
       SUM(v.valor) AS valor_total
FROM Funcionario f
LEFT JOIN Venda v ON f.idFunc = v.idFunc
WHERE EXISTS (SELECT 1 FROM Vendedor WHERE idFunc = f.idFunc)
GROUP BY f.nomeFunc;

SELECT c.nome AS cliente, pt.nome AS produto, 
       pc.dataInst, f.nomeFunc AS tecnico
FROM ProdutoCliente pc
INNER JOIN Cliente c ON pc.idCliente = c.idCliente
INNER JOIN ProdutoTipo pt ON pc.idProduto = pt.idProduto
INNER JOIN Funcionario f ON pc.idFunc = f.idFunc
ORDER BY c.nome, pc.dataInst;




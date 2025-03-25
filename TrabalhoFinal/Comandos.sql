INSERT INTO Cliente (nome, endereco) VALUES 
('Otávio Pacheco', 'R. General Osório, 122 - Pelotas/RS'),
('Ana Paula Andrade', 'R. Dom Pedro II, 75 - Pelotas/RS'),
('ALDO Solar Ltda', 'R. Felix da Cunha, 303 - Pelotas/RS'),
('Paulo Henrique Hoff', 'R. Tiradentes, 2114 - Pelotas/RS'),
('Jinko Solar', 'R. Santos Dumont, 590 - Pelotas/RS');

INSERT INTO PessoaFisica (cpf, idCliente) VALUES 
('12345678901', 1),
('98765432109', 2),
('45678912304', 4);

INSERT INTO PessoaJuridica (cnpj, idCliente) VALUES 
('94879947000168', 3),
('19977931000172', 5);

INSERT INTO TelefoneCliente (idCliente, numTelefone) VALUES 
(1, '53512859962'),
(2, '53987654321'),
(3, '51333344442'),
(4, '53333355552'),
(5, '55333264674');

INSERT INTO Fornecedor (cnpjFornec, nomeFornec, endFornec) VALUES 
('81106957000119', 'ALDO Solar Ltda', 'Av. Advogado Horácio Raccanello Filho, 1836 - Maringá/PR'),
('19518151000164', 'Jinko Solar', 'Av. Yingbin, 1 - Jiangxi/CH');

INSERT INTO TelefoneFornecedor (idFornec, numTelefone) VALUES 
(1, '40932612000'),
(2, '15052203150');

INSERT INTO Funcionario (cpfFunc, nomeFunc, nascFunc, endFunc) VALUES 
('05356942028', 'Luis Eduardo Rasch', '2004-10-14', 'R. Álvaro Chaves, 356 - Pelotas/RS'),
('56942028053', 'Paulo Vinicius', '2003-08-20', 'Av. Santa Cruz, 77 - Pelotas/RS'),
('04202853591', 'Marcos Lima', '2001-01-28', 'R. Lindolfo Color, 45 - Pelotas/RS'),
('33344455566', 'Frederico Bolaños', '1992-04-05', 'R. Nilton Barbosa, 13 - Camaquã/RS');

INSERT INTO Tecnico (idFunc, salario, servicos) VALUES 
(1, 3587.25, 0),
(2, 3839.60, 0);

INSERT INTO Vendedor (idFunc, salario, vendas) VALUES 
(3, 2000.00, 0),
(4, 4200.00, 0);

INSERT INTO ProdutoTipo (idFornec, nome, preco) VALUES 
(1, 'Gerador Fotovoltaico 4,44KWP Growatt', 2125.00),
(1, 'Gerador Fotovoltaico 7,05KWP Growatt', 3250.00),
(2, 'Painel Solar Jinko 530W', 700.00),
(2, 'Painel Solar Jinko 685W', 1399.99);

INSERT INTO Venda (idCliente, idFunc, dataVenda) VALUES 
(1, 3, '2023-01-15'),
(3, 3, '2023-03-07'),
(4, 4, '2023-01-21');

INSERT INTO ProdutoVenda (codPedido, idProduto, quantidade) VALUES 
(1, 1, 1),
(1, 3, 2),
(2, 2, 3),
(3, 4, 1),
(3, 1, 1);

INSERT INTO Instalação (codPedido, idFunc, dataInst) VALUES 
(1, 1, '2023-01-20'),
(2, 2, '2023-04-01'),
(3, 1, '2023-03-11');

SELECT c.idCliente as Id, c.nome as Nome, t.numTelefone as Telefone
FROM Cliente c
INNER JOIN TelefoneCliente t ON c.idCliente = t.idCliente;

SELECT c.idCliente as Id, pf.cpf as CPF, c.nome as Nome, t.numTelefone as Telefone
FROM Cliente c
INNER JOIN TelefoneCliente t ON c.idCliente = t.idCliente
INNER JOIN PessoaFisica pf ON c.idCliente = pf.idCliente;

SELECT c.idCliente as Id, pj.cnpj as CNPJ, c.nome as Nome, t.numTelefone as Telefone
FROM Cliente c
INNER JOIN TelefoneCliente t ON c.idCliente = t.idCliente
INNER JOIN PessoaJuridica pj ON c.idCliente = pj.idCliente;

SELECT v.codPedido, c.nome AS Cliente, f.nomeFunc AS Vendedor, 
       v.dataVenda as DataVenda, v.valor as Valor
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






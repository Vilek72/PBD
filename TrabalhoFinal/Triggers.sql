DELIMITER //
CREATE TRIGGER after_instalacao_insert
AFTER INSERT ON Instalação
FOR EACH ROW
BEGIN
    UPDATE Tecnico 
    SET servicos = IFNULL(servicos, 0) + 1 
    WHERE idFunc = NEW.idFunc;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER after_venda_insert
AFTER INSERT ON Venda
FOR EACH ROW
BEGIN
    UPDATE Vendedor 
    SET vendas = IFNULL(vendas, 0) + 1 
    WHERE idFunc = NEW.idFunc;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER before_pessoafisica_insert
BEFORE INSERT ON PessoaFisica
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM PessoaJuridica WHERE idCliente = NEW.idCliente) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cliente já cadastrado como Pessoa Jurídica';
    END IF;
END//

CREATE TRIGGER before_pessoajuridica_insert
BEFORE INSERT ON PessoaJuridica
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM PessoaFisica WHERE idCliente = NEW.idCliente) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cliente já cadastrado como Pessoa Física';
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER before_telefone_insert
BEFORE INSERT ON Telefone
FOR EACH ROW
BEGIN
    DECLARE cliente_existe INT;
    
    SELECT COUNT(*) INTO cliente_existe 
    FROM Cliente 
    WHERE idCliente = NEW.idCliente;
    
    IF cliente_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cliente não existe';
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER after_instalacao_complete
AFTER INSERT ON Instalação
FOR EACH ROW
BEGIN
    INSERT INTO ProdutoCliente (idCliente, idProduto, idFunc, dataInst, consumo)
    SELECT v.idCliente, pv.idProduto, NEW.idFunc, NEW.dataInst, 0
    FROM Venda v
    JOIN ProdutoVenda pv ON v.codPedido = pv.codPedido
    WHERE v.codPedido = NEW.codPedido;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER before_tecnico_insert
BEFORE INSERT ON Tecnico
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM Vendedor WHERE idFunc = NEW.idFunc) OR
       EXISTS (SELECT 1 FROM Administrador WHERE idFunc = NEW.idFunc) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Funcionário já é especializado em outra área';
    END IF;
END//

CREATE TRIGGER before_vendedor_insert
BEFORE INSERT ON Vendedor
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM Tecnico WHERE idFunc = NEW.idFunc) OR
       EXISTS (SELECT 1 FROM Administrador WHERE idFunc = NEW.idFunc) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Funcionário já é especializado em outra área';
    END IF;
END//

CREATE TRIGGER before_administrador_insert
BEFORE INSERT ON Administrador
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM Tecnico WHERE idFunc = NEW.idFunc) OR
       EXISTS (SELECT 1 FROM Vendedor WHERE idFunc = NEW.idFunc) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Funcionário já é especializado em outra área';
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE TRIGGER before_venda_insert
BEFORE INSERT ON Venda
FOR EACH ROW
BEGIN
    IF NEW.valor IS NULL THEN
        SET NEW.valor = 0;
    END IF;
END//

CREATE TRIGGER after_produtovenda_insert
AFTER INSERT ON ProdutoVenda
FOR EACH ROW
BEGIN
    DECLARE total DOUBLE;
    
    SELECT SUM(pv.quantidade * pt.preco) INTO total
    FROM ProdutoVenda pv
    JOIN ProdutoTipo pt ON pv.idProduto = pt.idProduto
    WHERE pv.codPedido = NEW.codPedido;
    
    UPDATE Venda SET valor = IFNULL(total, 0) WHERE codPedido = NEW.codPedido;
END//

CREATE TRIGGER after_produtovenda_update
AFTER UPDATE ON ProdutoVenda
FOR EACH ROW
BEGIN
    DECLARE total DOUBLE;
    
    SELECT SUM(pv.quantidade * pt.preco) INTO total
    FROM ProdutoVenda pv
    JOIN ProdutoTipo pt ON pv.idProduto = pt.idProduto
    WHERE pv.codPedido = NEW.codPedido;
    
    UPDATE Venda SET valor = IFNULL(total, 0) WHERE codPedido = NEW.codPedido;
END//

CREATE TRIGGER after_produtovenda_delete
AFTER DELETE ON ProdutoVenda
FOR EACH ROW
BEGIN
    DECLARE total DOUBLE;
    
    SELECT SUM(pv.quantidade * pt.preco) INTO total
    FROM ProdutoVenda pv
    JOIN ProdutoTipo pt ON pv.idProduto = pt.idProduto
    WHERE pv.codPedido = OLD.codPedido;
    
    UPDATE Venda SET valor = IFNULL(total, 0) WHERE codPedido = OLD.codPedido;
END//
DELIMITER ;

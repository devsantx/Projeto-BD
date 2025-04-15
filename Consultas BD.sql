-- 1. Listar os produtos mais vendidos (por quantidade total vendida)
SELECT 
    p.nome AS produto,
    SUM(i.quantidade) AS total_vendido
FROM itens_pedido i
JOIN produtos p ON i.produto_id = p.produto_id
GROUP BY i.produto_id
ORDER BY total_vendido DESC;

-- 2. Listar os clientes que mais compraram no último mês (abril de 2025)
SELECT 
    c.nome,
    COUNT(p.pedido_id) AS total_pedidos,
    SUM(p.total) AS total_gasto
FROM pedidos p
JOIN clientes c ON p.cliente_id = c.cliente_id
WHERE MONTH(p.data_pedido) = 4 AND YEAR(p.data_pedido) = 2025
GROUP BY c.cliente_id
ORDER BY total_gasto DESC;

-- 3. Verificar produtos com estoque baixo (5 ou menos unidades)
SELECT 
    nome,
    estoque
FROM produtos
WHERE estoque <= 5
ORDER BY estoque ASC;

-- 4. Consultar o faturamento por período (agrupado por mês/ano)
SELECT 
    DATE_FORMAT(data_pedido, '%Y-%m') AS mes,
    SUM(total) AS faturamento_total
FROM pedidos
WHERE status != 'cancelado'
GROUP BY mes
ORDER BY mes;

-- 5. Obter a média de avaliações de cada produto
SELECT 
    p.nome AS produto,
    ROUND(AVG(a.nota), 2) AS media_nota,
    COUNT(a.avaliacao_id) AS total_avaliacoes
FROM avaliacoes a
JOIN produtos p ON a.produto_id = p.produto_id
GROUP BY a.produto_id
ORDER BY media_nota DESC;

-- 6. Listar os produtos mais caros e mais baratos
SELECT * FROM produtos
ORDER BY preco DESC
LIMIT 1;

SELECT * FROM produtos
ORDER BY preco ASC
LIMIT 1;

-- 7. Verificar quantos pedidos cada cliente já fez
SELECT 
    c.nome,
    COUNT(p.pedido_id) AS total_pedidos
FROM clientes c
LEFT JOIN pedidos p ON c.cliente_id = p.cliente_id
GROUP BY c.cliente_id
ORDER BY total_pedidos DESC;

-- 8. Obter o valor total gasto por cada cliente (somente pedidos aprovados)
SELECT 
    c.nome,
    SUM(pg.valor) AS total_gasto
FROM clientes c
JOIN pedidos p ON c.cliente_id = p.cliente_id
JOIN pagamentos pg ON p.pedido_id = pg.pedido_id
WHERE pg.status = 'aprovado'
GROUP BY c.cliente_id
ORDER BY total_gasto DESC;

-- 9. Listar os pedidos que ainda estão em entrega (status enviado ou processando)
SELECT 
    p.pedido_id,
    c.nome AS cliente,
    p.status,
    p.data_pedido
FROM pedidos p
JOIN clientes c ON p.cliente_id = c.cliente_id
WHERE p.status IN ('enviado', 'processando')
ORDER BY p.data_pedido DESC;

-- 10. Verificar quais produtos nunca foram comprados
SELECT 
    p.nome
FROM produtos p
LEFT JOIN itens_pedido i ON p.produto_id = i.produto_id
WHERE i.produto_id IS NULL;

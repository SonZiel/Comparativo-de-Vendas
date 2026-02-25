<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ page import="java.util.*" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c" %>
<%@ taglib prefix="snk" uri="/WEB-INF/tld/sankhyaUtil.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8" />
  <title>Comparativo de Vendas</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <snk:load/>
  <link rel="stylesheet" href="${BASE_FOLDER}index.css">
</head>

<body>

<h2>Comparativo total dos meses</h2>

<div class="container">
    <div class="card">
        <h3 id="label_mes2">Mês 1</h3>
        <p>Total vendido</p>
        <h2 id="card_mes2">0</h2>
    </div>
    <div class="card">
        <h3 id="label_mes1">Mês 2</h3>
        <p>Total vendido</p>
        <h2 id="card_mes1">0</h2>
    </div>
    <div class="card">
        <h3 id="label_mesAtual">Mês 3</h3>
        <p>Total vendido</p>
        <h2 id="card_mesAtual">0</h2>
    </div>
    <div class="card">
        <h3>Crescimento</h3>
        <p>vs mês anterior</p>
        <h2 id="card_cresc">0%</h2>
    </div>
</div>

<h2>Comparativo por itens</h2>

<table id="tabela" border="1" width="100%">
    <thead>
        <tr>
            <th>Produto</th>
            <th id="th_mes2">Mês 1</th>
            <th id="th_mes1">Mês 2</th>
            <th id="th_mesAtual">Mês 3</th>
            <th>% Crescimento</th>
        </tr>
    </thead>
    <tbody></tbody>
</table>


<script>

// ================= PARÂMETROS DE PRODUTOS =================
var arr = [];
var placeholders = [];

function addParam(value, type){
    if(value != ""){
        arr.push({value: value, type: type || "I"});
        placeholders.push("?");
    }
}

addParam("${P_PRODUTOS_1}");
addParam("${P_PRODUTOS_2}");
addParam("${P_PRODUTOS_3}");
addParam("${P_PRODUTOS_4}");
addParam("${P_PRODUTOS_5}");
addParam("${P_PRODUTOS_6}");
addParam("${P_PRODUTOS_7}");
addParam("${P_PRODUTOS_8}");
addParam("${P_PRODUTOS_9}");
addParam("${P_PRODUTOS_10}");

// ================= PARÂMETROS DE MESES =================
// O usuário escolhe qualquer dia do mês — o SQL usa TRUNC para pegar o mês inteiro
var pMes1 = "${P_MES1}"; // ex: "01/12/2024"
var pMes2 = "${P_MES2}"; // ex: "01/01/2025"
var pMes3 = "${P_MES3}"; // ex: "01/02/2025"

if(placeholders.length == 0 || pMes1 == "" || pMes2 == "" || pMes3 == ""){
    document.body.innerHTML = "<h3>Informe os produtos e os 3 meses desejados.</h3>";
}

// Monta labels legíveis (MM/AAAA) para exibir nos cards e cabeçalho
function labelMes(dataStr){

    if(!dataStr) return "-";

    // Se vier no formato YYYY-MM-DD
    if(dataStr.includes("-")){
        var partes = dataStr.split(" ")[0].split("-");
        return partes[1] + "/" + partes[0];
    }

    // Se vier no formato DD/MM/YYYY
    if(dataStr.includes("/")){
        var partes = dataStr.split("/");
        return partes[1] + "/" + partes[2];
    }

    return "-";
}

var lbl1 = labelMes(pMes1);
var lbl2 = labelMes(pMes2);
var lbl3 = labelMes(pMes3);

document.getElementById("label_mes2").innerHTML    = lbl1;
document.getElementById("label_mes1").innerHTML    = lbl2;
document.getElementById("label_mesAtual").innerHTML = lbl3;
document.getElementById("th_mes2").innerHTML        = lbl1;
document.getElementById("th_mes1").innerHTML        = lbl2;
document.getElementById("th_mesAtual").innerHTML    = lbl3;

// ================= QUERY =================
// Adiciona as 3 datas no array de parâmetros (tipo D = Date no Sankhya)
var arrQuery = arr.slice(); // copia os parâmetros de produto
arrQuery.push({value: pMes1, type: "D"});
arrQuery.push({value: pMes2, type: "D"});
arrQuery.push({value: pMes3, type: "D"});

var query = `
SELECT
    PRO.CODPROD,
    PRO.CODPROD || ' - ' || PRO.DESCRPROD || ' - ' || PRO.MARCA AS DESCRPROD,

    SUM(CASE 
        WHEN TRUNC(CAB.DTNEG,'MM') = TRUNC(?,'MM')
        THEN ITE.QTDNEG ELSE 0 END) AS MES_2,

    SUM(CASE 
        WHEN TRUNC(CAB.DTNEG,'MM') = TRUNC(?,'MM')
        THEN ITE.QTDNEG ELSE 0 END) AS MES_1,

    SUM(CASE 
        WHEN TRUNC(CAB.DTNEG,'MM') = TRUNC(?,'MM')
        THEN ITE.QTDNEG ELSE 0 END) AS MES_ATUAL

FROM TGFCAB CAB
JOIN TGFITE ITE ON ITE.NUNOTA = CAB.NUNOTA
JOIN TGFPRO PRO ON PRO.CODPROD = ITE.CODPROD

WHERE CAB.CODTIPOPER IN (
          SELECT CODTIPOPER 
          FROM TGFTOP 
          WHERE ATUALCOM = 'C' 
            AND TIPMOV IN ('V', 'D')
      )
AND CAB.STATUSNOTA = 'L'
AND CAB.DTNEG >= TRUNC(?,'MM')

AND PRO.CODPROD IN (` + placeholders.join(",") + `)

GROUP BY PRO.CODPROD, PRO.DESCRPROD, PRO.MARCA
ORDER BY PRO.DESCRPROD
`;

// Monte o array final na ordem correta dos ? na query:
// 1° ? = MES_2 (pMes1)
// 2° ? = MES_1 (pMes2)
// 3° ? = MES_ATUAL (pMes3)
// 4° ? = filtro WHERE (pMes1, o menor mês)
// ...produtos
var arrFinal = [
    {value: pMes1, type: "D"},
    {value: pMes2, type: "D"},
    {value: pMes3, type: "D"},
    {value: pMes1, type: "D"}  // WHERE DTNEG >= menor mês
].concat(arr); // produtos no IN(...)


// ================= EXECUÇÃO =================
executeQuery(query, arrFinal, function(res){

    var dados = JSON.parse(res);

    if(dados.length == 0){
        document.body.innerHTML += "<h3>Sem vendas para os produtos no período.</h3>";
        return;
    }

    montarTabela(dados);
    montarCards(dados);

}, function(err){
    alert(err);
});


// ================= TABELA =================
function montarTabela(dados){

    var tbody = document.querySelector("#tabela tbody");
    tbody.innerHTML = "";

    dados.forEach(function(p){

        var perc = 0;
        if(p.MES_1 > 0){
            perc = ((p.MES_ATUAL - p.MES_1) / p.MES_1) * 100;
        }

        var row = tbody.insertRow(-1);
        if (perc < 0) {
            row.classList.add("negative");
        }
        row.style.cursor = "pointer";

        row.onclick = function(){
            openLevel('04M', { CODPROD: parseInt(p.CODPROD) });
        };

        row.insertCell(-1).innerHTML = p.DESCRPROD;
        row.insertCell(-1).innerHTML = p.MES_2;
        row.insertCell(-1).innerHTML = p.MES_1;
        row.insertCell(-1).innerHTML = p.MES_ATUAL;
        row.insertCell(-1).innerHTML = perc.toFixed(1) + "%";
    });
}


// ================= CARDS =================
function montarCards(dados){

    var total2 = 0, total1 = 0, totalAtual = 0;

    dados.forEach(function(p){
        total2     += parseFloat((p.MES_2    || "0").toString().replace(",", "."));
        total1     += parseFloat((p.MES_1    || "0").toString().replace(",", "."));
        totalAtual += parseFloat((p.MES_ATUAL || "0").toString().replace(",", "."));
    });

    var perc = 0;
    if(total1 > 0){
        perc = ((totalAtual - total1) / total1) * 100;
    }

    document.getElementById("card_mes2").innerHTML     = total2.toFixed(0);
    document.getElementById("card_mes1").innerHTML     = total1.toFixed(0);
    document.getElementById("card_mesAtual").innerHTML = totalAtual.toFixed(0);
    document.getElementById("card_cresc").innerHTML    = perc.toFixed(1) + "%";

    var cardCresc = document.getElementById("card_cresc").parentElement;
    cardCresc.classList.remove("negative");
    if (perc < 0) {
        cardCresc.classList.add("negative");
    }
}

</script>

</body>
</html>
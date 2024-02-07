-------------------------------------------------------------------
-- CREATE TABLE D_INFO_T (
--     TYPE_T VARCHAR(50),
--     CATEGORIE_T VARCHAR(50),
--     SOUS_CATEGORIE_T VARCHAR(50),
--     PRIMARY KEY (TYPE_T, CATEGORIE_T, SOUS_CATEGORIE_T)
-- );
-------------------------------------------------------------------

CREATE TABLE D_INFO_T (
    ALL_IN VARCHAR(150) PRIMARY KEY,
    TYPE_T VARCHAR(50),
    CATEGORIE_T VARCHAR(50),
    SOUS_CATEGORIE_T VARCHAR(50)
);

CREATE TABLE D_DATE_T (
    DATE_TRANSACTION DATE PRIMARY KEY
);

CREATE TABLE D_CODE_T (
    C_OU_D CHAR(1) PRIMARY KEY
);

--------------------------------------------------------------------------------------------------------------------------------------
-- CREATE TABLE F_TRANSACTION (
--     ID_REF VARCHAR(50),
--     TRANS_VAL DECIMAL(10, 2),
--     INFO_FK_TYPE VARCHAR(50),
--     INFO_FK_CATEGORIE VARCHAR(50),
--     INFO_FK_SOUS_CATEGORIE VARCHAR(50),
--     CODE_FK CHAR(1),
--     DATE_FK DATE,
--     PRIMARY KEY (ID_REF),
--     FOREIGN KEY (INFO_FK_TYPE, INFO_FK_CATEGORIE, INFO_FK_SOUS_CATEGORIE) REFERENCES D_INFO_T(TYPE_T, CATEGORIE_T, SOUS_CATEGORIE_T),
--     FOREIGN KEY (CODE_FK) REFERENCES D_CODE_T(C_OU_D),
--     FOREIGN KEY (DATE_FK) REFERENCES D_DATE_T(DATE_TRANSACTION)
-- );
--------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE F_TRANSACTION (
    ID_REF VARCHAR(50),
    TRANS_VAL DECIMAL(10, 2),
    INFO_FK VARCHAR(150),
    CODE_FK CHAR(1),
    DATE_FK DATE,
    PRIMARY KEY (ID_REF),
    FOREIGN KEY (INFO_FK) REFERENCES D_INFO_T(ALL_IN),
    FOREIGN KEY (CODE_FK) REFERENCES D_CODE_T(C_OU_D),
    FOREIGN KEY (DATE_FK) REFERENCES D_DATE_T(DATE_TRANSACTION)
);

-------------------------------------------------------------------
-- Insérer les données uniques dans les tables de référence
-- INSERT INTO D_INFO_T (TYPE_T, CATEGORIE_T, SOUS_CATEGORIE_T)
-- SELECT DISTINCT TYPE_OPERATION, CATEGORIE, SOUS_CATEGORIE
-- FROM BANQUE_ODS;
-------------------------------------------------------------------

INSERT INTO D_INFO_T (ALL_IN, TYPE_T, CATEGORIE_T, SOUS_CATEGORIE_T)
SELECT DISTINCT TYPE_OPERATION || '_' || CATEGORIE || '_' || SOUS_CATEGORIE, 
       TYPE_OPERATION, 
       CATEGORIE, 
       SOUS_CATEGORIE
FROM BANQUE_ODS;

INSERT INTO D_DATE_T (DATE_TRANSACTION)
SELECT DISTINCT DATE_DE_COMPTABILISATION
FROM BANQUE_ODS;

INSERT INTO D_CODE_T (C_OU_D)
SELECT 'C' FROM DUAL UNION ALL -- Pseudo-table DUAL et on les combine
SELECT 'D' FROM DUAL;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Insérer les données dans la table principale en utilisant les clés étrangères correspondantes
-- INSERT INTO F_TRANSACTION (ID_REF, TRANS_VAL, INFO_FK_TYPE, INFO_FK_CATEGORIE, INFO_FK_SOUS_CATEGORIE, CODE_FK, DATE_FK)
-- SELECT REFERENCE, 
--        CASE WHEN DEBIT <> 0 THEN DEBIT ELSE CREDIT END AS TRANS_VAL,
--        D_INFO_T.TYPE_T, 
--        D_INFO_T.CATEGORIE_T, 
--        D_INFO_T.SOUS_CATEGORIE_T,
--        D_CODE_T.C_OU_D,
--        D_DATE_T.DATE_TRANSACTION
-- FROM BANQUE_ODS
-- JOIN D_INFO_T ON BANQUE_ODS.TYPE_OPERATION = D_INFO_T.TYPE_T AND BANQUE_ODS.CATEGORIE = D_INFO_T.CATEGORIE_T AND BANQUE_ODS.SOUS_CATEGORIE = D_INFO_T.SOUS_CATEGORIE_T
-- JOIN D_DATE_T ON BANQUE_ODS.DATE_DE_COMPTABILISATION = D_DATE_T.DATE_TRANSACTION
-- JOIN D_CODE_T ON BANQUE_ODS.DEBIT <> 0 AND D_CODE_T.C_OU_D = 'D' OR BANQUE_ODS.CREDIT <> 0 AND D_CODE_T.C_OU_D = 'C';
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


INSERT INTO F_TRANSACTION (ID_REF, TRANS_VAL, INFO_FK, CODE_FK, DATE_FK)
SELECT REFERENCE, 
       CASE WHEN DEBIT <> 0 THEN DEBIT ELSE CREDIT END AS TRANS_VAL,
       D_INFO_T.ALL_IN, 
       D_CODE_T.C_OU_D,
       D_DATE_T.DATE_TRANSACTION
FROM BANQUE_ODS
JOIN D_INFO_T ON BANQUE_ODS.TYPE_OPERATION = D_INFO_T.TYPE_T 
              AND BANQUE_ODS.CATEGORIE = D_INFO_T.CATEGORIE_T 
              AND BANQUE_ODS.SOUS_CATEGORIE = D_INFO_T.SOUS_CATEGORIE_T
JOIN D_DATE_T ON BANQUE_ODS.DATE_DE_COMPTABILISATION = D_DATE_T.DATE_TRANSACTION
JOIN D_CODE_T ON (BANQUE_ODS.DEBIT <> 0 AND D_CODE_T.C_OU_D = 'D') 
              OR (BANQUE_ODS.CREDIT <> 0 AND D_CODE_T.C_OU_D = 'C');


SELECT *
FROM F_TRANSACTION
WHERE ID_REF = '75730035-84aa-46f4-8364-ccd2cbde36e5';



-- Quelle est la plus grosse catégorie de dépense ?
-------------------------------------------------------------------
-- SELECT INFO_FK_CATEGORIE, SUM(TRANS_VAL) AS Total_Depense
-- FROM F_TRANSACTION
-- WHERE CODE_FK = 'D'
-- GROUP BY INFO_FK_CATEGORIE
-- ORDER BY Total_Depense ASC;
-- FETCH FIRST 1 ROW ONLY;
-------------------------------------------------------------------

SELECT D_INFO_T.CATEGORIE_T AS GROSSE_CATEGORIE_DE_DEPENSE, 
       SUM(F_TRANSACTION.TRANS_VAL) AS TOTAL_DEPENSE
FROM F_TRANSACTION
JOIN D_INFO_T ON F_TRANSACTION.INFO_FK = D_INFO_T.ALL_IN
WHERE F_TRANSACTION.CODE_FK = 'D'
GROUP BY D_INFO_T.CATEGORIE_T
ORDER BY TOTAL_DEPENSE ASC
FETCH FIRST 1 ROW ONLY;


-- Quelle est la plus grosse sous catégorie de source de revenue ?

-------------------------------------------------------------------
-- SELECT INFO_FK_SOUS_CATEGORIE, SUM(TRANS_VAL) AS Total_Revenu
-- FROM F_TRANSACTION
-- WHERE CODE_FK = 'C'
-- GROUP BY INFO_FK_SOUS_CATEGORIE
-- ORDER BY Total_Revenu DESC
-- FETCH FIRST 1 ROW ONLY;
-------------------------------------------------------------------

SELECT D_INFO_T.SOUS_CATEGORIE_T AS GROSSE_SOUS_CATEGORIE_DE_REVENUS, 
       SUM(F_TRANSACTION.TRANS_VAL) AS TOTAL_REVENUS
FROM F_TRANSACTION
JOIN D_INFO_T ON F_TRANSACTION.INFO_FK = D_INFO_T.ALL_IN
WHERE F_TRANSACTION.CODE_FK = 'C'
GROUP BY D_INFO_T.SOUS_CATEGORIE_T
ORDER BY TOTAL_REVENUS DESC
FETCH FIRST 1 ROW ONLY;


-- Quelles est l’évolution du solde client à travers le temps ?

SELECT DATE_FK, 
       SUM(TRANS_VAL) AS Solde_Client
FROM F_TRANSACTION
GROUP BY DATE_FK
ORDER BY DATE_FK;

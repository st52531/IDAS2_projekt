-- Obory
create or replace PROCEDURE vlozObor
  (p_zkratka STUD_OBOR.ZKRATKA%TYPE, p_nazev STUD_OBOR.NAZEV%TYPE, p_id_formy STUD_OBOR.FORMA_VYUKY_ID_FORMY%TYPE, p_info STUD_OBOR.INFO%TYPE)
IS
BEGIN
	INSERT INTO STUD_OBOR ( ZKRATKA, NAZEV,FORMA_VYUKY_ID_FORMY,INFO)
	values (p_zkratka, p_nazev, p_id_formy, p_info);
END;
/
create or replace PROCEDURE upravObor
  (p_id_oboru STUD_OBOR.ID_OBORU%TYPE, p_zkratka STUD_OBOR.ZKRATKA%TYPE, p_nazev STUD_OBOR.NAZEV%TYPE, p_id_formy STUD_OBOR.FORMA_VYUKY_ID_FORMY%TYPE, p_info STUD_OBOR.INFO%TYPE)
IS
BEGIN
	UPDATE STUD_OBOR
	SET ZKRATKA = p_zkratka,NAZEV = p_nazev, FORMA_VYUKY_ID_FORMY = p_id_formy,INFO = p_info
    WHERE ID_OBORU = p_id_oboru;
END;
/
create or replace PROCEDURE smazObor (p_id_oboru STUD_OBOR.ID_OBORU%TYPE)
IS
BEGIN
    DELETE FROM STUD_OBOR
    WHERE ID_OBORU = p_id_oboru;
END;
/

-- Studijní plán oboru
create or replace PROCEDURE vlozPlan
  (p_verze STUD_PLAN.VERZE%TYPE, p_id_oboru STUD_PLAN.STUD_OBOR_ID_OBORU%TYPE)
IS
BEGIN
	INSERT INTO STUD_PLAN (VERZE,STUD_OBOR_ID_OBORU)
	values (p_verze,p_id_oboru);
END;
/
create or replace PROCEDURE upravPlan
  (p_id_planu STUD_PLAN.ID_PLANU%TYPE, p_verze STUD_PLAN.VERZE%TYPE, p_id_oboru STUD_PLAN.STUD_OBOR_ID_OBORU%TYPE)
IS
BEGIN
	UPDATE STUD_PLAN
	SET VERZE = p_verze,STUD_OBOR_ID_OBORU = p_id_oboru
    WHERE ID_PLANU = p_id_planu;
END;
/
create or replace PROCEDURE smazPlan (p_id_planu STUD_PLAN.ID_PLANU%TYPE)
IS
BEGIN
    DELETE FROM STUD_PLAN
    WHERE ID_PLANU = p_id_planu;
END;
/

-- Uzivatel
create or replace PROCEDURE vlozUzivatele
  (p_jmeno UZIVATEL.JMENO%TYPE, p_prijmeni UZIVATEL.PRIJMENI%TYPE, p_titulPred UZIVATEL.TITUL_PRED%TYPE, 
  p_titulZa UZIVATEL.TITUL_ZA%TYPE, p_email UZIVATEL.EMAIL%TYPE, p_mobil UZIVATEL.MOBIL%TYPE, p_telefon UZIVATEL.TELEFON%TYPE,
  p_zkratkaKatedry UZIVATEL.KATEDRA_ZKRATKA_KATEDRY%TYPE, p_idRole UZIVATEL.ROLE_ID_ROLE%TYPE)
IS
BEGIN
	Insert into UZIVATEL (JMENO, PRIJMENI, TITUL_PRED, TITUL_ZA, EMAIL, MOBIL, TELEFON, KATEDRA_ZKRATKA_KATEDRY, ROLE_ID_ROLE)
    values (p_jmeno, p_prijmeni, p_titulPred, p_titulZa, p_email, p_mobil, p_telefon, p_zkratkaKatedry, p_idRole);
END;
/
create or replace PROCEDURE upravUzivatele
  (p_id UZIVATEL.ID_UZIVATELE%TYPE, p_jmeno UZIVATEL.JMENO%TYPE, p_prijmeni UZIVATEL.PRIJMENI%TYPE, p_titulPred UZIVATEL.TITUL_PRED%TYPE, 
  p_titulZa UZIVATEL.TITUL_ZA%TYPE, p_email UZIVATEL.EMAIL%TYPE, p_mobil UZIVATEL.MOBIL%TYPE, p_telefon UZIVATEL.TELEFON%TYPE,
  p_zkratkaKatedry UZIVATEL.KATEDRA_ZKRATKA_KATEDRY%TYPE, p_idRole UZIVATEL.ROLE_ID_ROLE%TYPE)
IS
BEGIN
	update UZIVATEL set JMENO = p_jmeno, PRIJMENI = p_prijmeni, TITUL_PRED = p_titulPred, TITUL_ZA = p_titulZa,
    EMAIL = p_email, MOBIL = p_mobil, TELEFON = p_telefon, KATEDRA_ZKRATKA_KATEDRY = p_zkratkaKatedry, ROLE_ID_ROLE = p_idRole
    where ID_UZIVATELE = p_id;
END;
/
create or replace PROCEDURE smazUzivatele
  (p_id UZIVATEL.ID_UZIVATELE%TYPE)
IS
BEGIN
	delete from UZIVATEL
    where ID_UZIVATELE = p_id;
END;
/

-- Ucet
create or replace PROCEDURE vlozUcet
  (p_idUzivatele UCET.UZIVATEL_ID_UZIVATELE%TYPE, p_nick UCET.NICK%TYPE, p_heslo UCET.HESLO%TYPE, p_idRole ROLE.ID_ROLE%TYPE)
IS
v_idUcet UCET.ID_UCTU%TYPE;
v_idRole ROLE.ID_ROLE%TYPE;
BEGIN
    SELECT ROLE_ID_ROLE INTO v_idRole FROM uzivatel WHERE id_uzivatele = p_idUzivatele;
    IF (NOT(v_idRole = 3)) THEN
    raise_application_error(-20001, 'Uživatel už účet má!');
    END IF;
    SELECT ID_UCTU INTO v_idUcet FROM UCET WHERE uzivatel_id_uzivatele = p_idUzivatele;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            IF (jeJmenoUnikatni(p_nick)) THEN
                INSERT INTO UCET (NICK, HESLO, UZIVATEL_ID_UZIVATELE)
                VALUES (p_nick, p_heslo, p_idUzivatele);
    
                UPDATE UZIVATEL SET ROLE_ID_ROLE = p_idRole WHERE ID_UZIVATELE = p_idUzivatele;
            ELSE
            raise_application_error(-20002, 'Uživatel s tímto jménem již existuje!');
            END IF;
END;
/
create or replace PROCEDURE upravUcet
  (p_idUzivatele UCET.UZIVATEL_ID_UZIVATELE%TYPE,p_nick UCET.NICK%TYPE, p_heslo UCET.HESLO%TYPE, p_idRole ROLE.ID_ROLE%TYPE)
IS
v_nickUctu UCET.NICK%TYPE;
BEGIN
    select nick into v_nickUctu from ucet where UZIVATEL_ID_UZIVATELE = p_idUzivatele;
    IF (jeJmenoUnikatni(p_nick) OR v_nickUctu = p_nick) THEN
        UPDATE UCET SET NICK = p_nick, HESLO = p_heslo
        WHERE uzivatel_id_uzivatele = p_idUzivatele;
    
        UPDATE UZIVATEL SET ROLE_ID_ROLE = p_idRole WHERE ID_UZIVATELE = p_idUzivatele;
    ELSE
        raise_application_error(-20001, 'Uživatel s tímto jménem již existuje!');
    END IF;
END;
/
create or replace PROCEDURE odeberUcet
  (p_idUzivatele UCET.UZIVATEL_ID_UZIVATELE%TYPE)
IS
v_idUctu UCET.ID_UCTU%TYPE;
BEGIN
    SELECT ID_UCTU INTO v_idUctu FROM ucet WHERE uzivatel_id_uzivatele = p_idUzivatele;
	UPDATE UZIVATEL SET ROLE_ID_ROLE = 3 WHERE id_uzivatele = p_idUzivatele;
    DELETE FROM UCET WHERE id_uctu = v_idUctu;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            raise_application_error(-20001, 'Tento uživatel nemá účet!');
END;
/

-- Obrazek
create or replace PROCEDURE vlozObrazek
  (p_idUzivatele OBRAZEK.uzivatel_id_uzivatele%TYPE,p_nazev OBRAZEK.NAZEV%TYPE, p_pripona OBRAZEK.PRIPONA%TYPE, p_obsah OBRAZEK.OBSAH%TYPE)
IS
BEGIN
    INSERT INTO 
    OBRAZEK (NAZEV, PRIPONA, OBSAH, VYTVORENO, MODIFIKACE, UZIVATEL_ID_UZIVATELE)
    VALUES (p_nazev, p_pripona, p_obsah, SYSDATE, SYSDATE, p_idUzivatele);     
        
    exception
        when DUP_VAL_ON_INDEX THEN
            update OBRAZEK
            set nazev = p_nazev, pripona = p_pripona, obsah = p_obsah, modifikace = SYSDATE
            where uzivatel_id_uzivatele = p_idUzivatele;
END;
/
create or replace PROCEDURE smazObrazek
  (p_idUzivatele OBRAZEK.uzivatel_id_uzivatele%TYPE)
IS
BEGIN
    DELETE FROM
    OBRAZEK WHERE uzivatel_id_uzivatele = p_idUzivatele;
	
	EXCEPTION
        WHEN NO_DATA_FOUND THEN
            raise_application_error(-20001, 'Uživatel nemá obrázek!');
END;
/

--Předmět
create or replace PROCEDURE vlozPredmet
  (p_nazev PREDMET.NAZEV%TYPE, p_zkratka PREDMET.ZKRATKA%TYPE)
IS
BEGIN
      INSERT INTO PREDMET (NAZEV,ZKRATKA)
        VALUES(p_nazev, p_zkratka);
END;
/
create or replace PROCEDURE upravPredmet
  (p_idPredmetu PREDMET.ID_PREDMETU%TYPE, p_nazev PREDMET.NAZEV%TYPE, p_zkratka PREDMET.ZKRATKA%TYPE)
IS
BEGIN
    UPDATE PREDMET 
      SET NAZEV = p_nazev, ZKRATKA = p_zkratka
      WHERE ID_PREDMETU = p_idPredmetu;
END;
/
create or replace PROCEDURE smazPredmet
   (p_idPredmetu PREDMET.ID_PREDMETU%TYPE)
IS
BEGIN
    DELETE FROM PREDMET
    WHERE ID_PREDMETU = p_idPredmetu;
END;
/

-- Ucebna
create or replace PROCEDURE vlozUcebnu
  (p_nazev UCEBNA.NAZEV_UCEBNY%TYPE, p_kapacita UCEBNA.KAPACITA%TYPE)
IS
BEGIN
    INSERT INTO 
    UCEBNA (NAZEV_UCEBNY, KAPACITA)
    VALUES (p_nazev, p_kapacita);     
END;
/
create or replace PROCEDURE upravUcebnu
  (p_id UCEBNA.ID_UCEBNY%TYPE, p_nazev UCEBNA.NAZEV_UCEBNY%TYPE, p_kapacita UCEBNA.KAPACITA%TYPE)
IS
BEGIN
	update UCEBNA set nazev_ucebny = p_nazev, kapacita = p_kapacita
    where ID_UCEBNY = p_id;
END;
/
create or replace PROCEDURE smazUcebnu
  (p_id UCEBNA.ID_UCEBNY%TYPE)
IS
BEGIN
    DELETE FROM
    UCEBNA WHERE id_ucebny = p_id;
	
	EXCEPTION
        WHEN NO_DATA_FOUND THEN
            raise_application_error(-20001, 'Učebna neexistuje!');
END;
/
-- Pracoviště
create or replace PROCEDURE vlozPracoviste
    (p_zkratka KATEDRA.zkratka_katedry%TYPE,p_nazev KATEDRA.NAZEV_KATEDRY%TYPE, p_zkratkaFak KATEDRA.FAKULTA_ZKRATKA_FAKULTY%TYPE)
IS
BEGIN
    INSERT INTO KATEDRA(ZKRATKA_KATEDRY, NAZEV_KATEDRY,FAKULTA_ZKRATKA_FAKULTY)
        VALUES(p_zkratka,p_nazev,p_zkratkaFak);
END;
/

create or replace PROCEDURE upravPracoviste
    (p_zkratka KATEDRA.ZKRATKA_KATEDRY%TYPE,p_nazev KATEDRA.NAZEV_KATEDRY%TYPE, p_zkratkaFak KATEDRA.FAKULTA_ZKRATKA_FAKULTY%TYPE)
IS
BEGIN
    UPDATE KATEDRA SET NAZEV_KATEDRY = p_nazev, FAKULTA_ZKRATKA_FAKULTY = p_zkratkaFak
    WHERE ZKRATKA_KATEDRY = p_zkratka;
END;
/
create or replace PROCEDURE smazPracoviste
    (p_zkratka KATEDRA.ZKRATKA_KATEDRY%TYPE)
IS
BEGIN
    DELETE FROM KATEDRA 
    WHERE ZKRATKA_KATEDRY = p_zkratka;
END;

--Předmět v plánu
create or replace PROCEDURE vlozPredVPlanu
    (p_kredity PRED_V_PLANU.KREDITY%TYPE, p_dopRoc PRED_V_PLANU.DOP_ROCNIK%TYPE, 
    p_zkratkaKat PRED_V_PLANU.KAT_PREDMETU_ZKR_KAT%TYPE, p_idPredmetu PRED_V_PLANU.PREDMET_ID_PREDMETU%TYPE, 
    p_zkratkaZakon PRED_V_PLANU.ZPUSOB_ZAKONCENI_ZKR_ZAK%TYPE, p_zkratkaSem PRED_V_PLANU.SEMESTR_ZKR_SEM%TYPE, 
    p_idPlanu PRED_V_PLANU.STUD_PLAN_ID_PLANU%TYPE)
IS
BEGIN
    INSERT INTO PRED_V_PLANU (KREDITY, DOP_ROCNIK, KAT_PREDMETU_ZKR_KAT,PREDMET_ID_PREDMETU,
    ZPUSOB_ZAKONCENI_ZKR_ZAK, SEMESTR_ZKR_SEM, STUD_PLAN_ID_PLANU)
        values(p_kredity, p_dopRoc, p_zkratkaKat, p_idPredmetu,p_zkratkaZakon, p_zkratkaSem,p_idPlanu);
END;
/
create or replace PROCEDURE upravPredVPlanu
    (p_id PRED_V_PLANU.ID_PRED_PLANU%TYPE, p_kredity PRED_V_PLANU.KREDITY%TYPE, p_dopRoc PRED_V_PLANU.DOP_ROCNIK%TYPE, 
    p_zkratkaKat PRED_V_PLANU.KAT_PREDMETU_ZKR_KAT%TYPE, p_idPredmetu PRED_V_PLANU.PREDMET_ID_PREDMETU%TYPE, 
    p_zkratkaZakon PRED_V_PLANU.ZPUSOB_ZAKONCENI_ZKR_ZAK%TYPE, p_zkratkaSem PRED_V_PLANU.SEMESTR_ZKR_SEM%TYPE, 
    p_idPlanu PRED_V_PLANU.STUD_PLAN_ID_PLANU%TYPE)
IS
BEGIN
    UPDATE PRED_V_PLANU
        SET KREDITY = p_kredity, DOP_ROCNIK = p_dopRoc, KAT_PREDMETU_ZKR_KAT = p_zkratkaKat, 
            PREDMET_ID_PREDMETU = p_idPredmetu, ZPUSOB_ZAKONCENI_ZKR_ZAK = p_zkratkaZakon,
            SEMESTR_ZKR_SEM = p_zkratkaSem, STUD_PLAN_ID_PLANU = p_idPlanu
        WHERE ID_PRED_PLANU = p_id;
END;
/
create or replace PROCEDURE smazPredVPlanu
    (p_id PRED_V_PLANU.ID_PRED_PLANU%TYPE)
IS
BEGIN
    DELETE FROM PRED_V_PLANU
        WHERE ID_PRED_PLANU = p_id;
END;
/
-- Rozvrhová akce
create or replace PROCEDURE vlozAkci
    (p_datum ROZVRHOVA_AKCE.DATUM%TYPE, p_casOd ROZVRHOVA_AKCE.CAS_OD%TYPE, 
    p_rozsahHod ROZVRHOVA_AKCE.ROZSAH_HODIN%TYPE, p_kapacita ROZVRHOVA_AKCE.KAPACITA%TYPE, 
    p_idUzivatele ROZVRHOVA_AKCE.UZIVATEL_ID_UZIVATELE%TYPE, p_idPredmetu ROZVRHOVA_AKCE.PREDMET_ID_PREDMETU%TYPE, 
    p_idZpusVyuk ROZVRHOVA_AKCE.ZPUSOB_VYUKY_ID_NAZVU%TYPE, p_idUcebny ROZVRHOVA_AKCE.UCEBNA_ID_UCEBNY%TYPE)
IS
BEGIN
    INSERT INTO ROZVRHOVA_AKCE (DATUM, CAS_OD, ROZSAH_HODIN, KAPACITA, UZIVATEL_ID_UZIVATELE,
        PREDMET_ID_PREDMETU, ZPUSOB_VYUKY_ID_NAZVU, UCEBNA_ID_UCEBNY)
            values(p_datum,p_casOd,p_rozsahHod,p_kapacita,p_idUzivatele,p_idPredmetu, p_idZpusVyuk, p_idUcebny);
END;
/
create or replace PROCEDURE upravAkci
    (p_id ROZVRHOVA_AKCE.ID_AKCE%TYPE, p_datum ROZVRHOVA_AKCE.DATUM%TYPE, p_casOd ROZVRHOVA_AKCE.CAS_OD%TYPE, 
    p_rozsahHod ROZVRHOVA_AKCE.ROZSAH_HODIN%TYPE, p_kapacita ROZVRHOVA_AKCE.KAPACITA%TYPE, 
    p_idUzivatele ROZVRHOVA_AKCE.UZIVATEL_ID_UZIVATELE%TYPE, p_idPredmetu ROZVRHOVA_AKCE.PREDMET_ID_PREDMETU%TYPE, 
    p_idZpusVyuk ROZVRHOVA_AKCE.ZPUSOB_VYUKY_ID_NAZVU%TYPE, p_idUcebny ROZVRHOVA_AKCE.UCEBNA_ID_UCEBNY%TYPE)
IS
BEGIN
    UPDATE ROZVRHOVA_AKCE SET DATUM = p_datum, CAS_OD = p_casOd, ROZSAH_HODIN = p_rozsahHod, 
        KAPACITA = p_kapacita, UZIVATEL_ID_UZIVATELE = p_idUzivatele, PREDMET_ID_PREDMETU = p_idPredmetu,
        ZPUSOB_VYUKY_ID_NAZVU = p_idZpusVyuk, UCEBNA_ID_UCEBNY = p_idUcebny
    WHERE ID_AKCE = p_id;
END;
/
create or replace PROCEDURE smazAkci
    (p_id ROZVRHOVA_AKCE.ID_AKCE%TYPE)
IS
BEGIN
    DELETE FROM ROZVRHOVA_AKCE
        WHERE ID_AKCE = p_id;
END;
/
CREATE TYPE stato_casa AS ENUM ('LIBERO', 'OCCUPATO');
CREATE TYPE tipo_affitto AS ENUM ('PARZIALE', 'TOTALE');

-- Creazione delle tabelle
CREATE TABLE filiali (
    partita_iva VARCHAR(15) PRIMARY KEY,
    nome VARCHAR(255),
    indirizzo_sede VARCHAR(255),
    civico INT,
    telefono VARCHAR(20)
);

CREATE TABLE case_in_vendita (
    catastale VARCHAR(20) PRIMARY KEY,
    indirizzo VARCHAR(255),
    numero_civico INT,
    piano INT,
    metri INT,
    vani INT,
    prezzo DECIMAL(10,2),  -- Usato DECIMAL per il prezzo
    stato stato_casa,      -- Usa il tipo ENUM appena creato
    filiale_proponente VARCHAR(15),
    FOREIGN KEY (filiale_proponente) REFERENCES filiali(partita_iva)
);

CREATE TABLE case_in_affitto (
    catastale VARCHAR(20) PRIMARY KEY,
    indirizzo VARCHAR(255),
    civico INT,
    tipo_affitto tipo_affitto,  -- Usa il tipo ENUM per affitti
    bagno_personale BOOLEAN,
    prezzo_mensile DECIMAL(10,2),  -- Usato DECIMAL per il prezzo mensile
    filiale_proponente VARCHAR(15),
    FOREIGN KEY (filiale_proponente) REFERENCES filiali(partita_iva)
);

CREATE TABLE vendite_casa (
    catastale VARCHAR(20),
    data_vendita DATE,
    filiale_proponente VARCHAR(15),
    filiale_venditrice VARCHAR(15),
    prezzo_vendita DECIMAL(10,2),  -- Usato DECIMAL per il prezzo vendita
    FOREIGN KEY (filiale_proponente) REFERENCES filiali(partita_iva),
    FOREIGN KEY (filiale_venditrice) REFERENCES filiali(partita_iva)
);

CREATE TABLE affitti_casa (
    catastale VARCHAR(20),
    data_affitto DATE,
    filiale_proponente VARCHAR(15),
    filiale_venditrice VARCHAR(15),
    prezzo_affitto DECIMAL(10,2),  -- Usato DECIMAL per il prezzo affitto
    durata_contratto INT,
    FOREIGN KEY (filiale_proponente) REFERENCES filiali(partita_iva),
    FOREIGN KEY (filiale_venditrice) REFERENCES filiali(partita_iva)
);

--Popolamento tabbelle 
-- Popoliamo la tabella `case_in_vendita`
INSERT INTO case_in_vendita (catastale, stato, filiale_proponente, prezzo, superficie, indirizzo)
VALUES
    ('1234567890', 'LIBERO', 'FILIALE123', 200000, 120, 'Via Roma 1, Milano'),
    ('1234567891', 'LIBERO', 'FILIALE123', 150000, 80, 'Via Torino 2, Milano'),
    ('1234567892', 'IN_VENDITA', 'FILIALE456', 250000, 150, 'Via Firenze 3, Milano');

-- Popoliamo la tabella `vendite_casa`
INSERT INTO vendite_casa (catastale, data_vendita, filiale_proponente, filiale_venditrice, prezzo_vendita)
VALUES
    ('1234567890', '2024-05-01', 'FILIALE123', 'FILIALE001', 200000),
    ('1234567891', '2024-06-01', 'FILIALE123', 'FILIALE002', 150000);

-- Popoliamo la tabella `affitti_casa`
INSERT INTO affitti_casa (catastale, data_inizio, data_fine, filiale_proponente, prezzo_mensile)
VALUES
    ('1234567890', '2024-01-01', '2024-12-31', 'FILIALE123', 1000),
    ('1234567891', '2024-02-01', '2024-12-31', 'FILIALE123', 800);

create database neocredit;

use neocredit;

-- 1. Entidad: Clientes (Datos demográficos estáticos)
CREATE TABLE Clientes (
    id_cliente VARCHAR(20) PRIMARY KEY,
    nombre_cliente VARCHAR(150) NOT NULL,
    edad INT,
    genero VARCHAR(20),
    ciudad VARCHAR(100),
    ingreso_mensual DECIMAL(10, 2),
    tipo_empleo VARCHAR(50),
    antiguedad_laboral_meses INT
);

-- 2. Entidad: Perfil_Financiero (Separado por 3FN)
CREATE TABLE Perfil_Financiero (
    id_cliente VARCHAR(20) PRIMARY KEY,
    score_buro_externo INT,
    deuda_actual DECIMAL(12, 2),
    num_tarjetas_activas INT,
    historial_pagos_atrasados INT,
    CONSTRAINT fk_perfil_cliente FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

-- 3. Entidad: Cuentas
CREATE TABLE Cuentas (
    id_cuenta VARCHAR(20) PRIMARY KEY,
    id_cliente VARCHAR(20) NOT NULL,
    tipo_cuenta VARCHAR(50), 
    fecha_apertura DATE,
    estado_cuenta VARCHAR(20),
    CONSTRAINT fk_cuenta_cliente FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

-- 4. Entidad: Transacciones
CREATE TABLE Transacciones (
    id_transaccion VARCHAR(20) PRIMARY KEY,
    id_cuenta VARCHAR(20) NOT NULL,
    fecha_transaccion DATETIME,
    monto DECIMAL(12, 2),
    tipo_transaccion VARCHAR(50), 
    CONSTRAINT fk_transaccion_cuenta FOREIGN KEY (id_cuenta) REFERENCES Cuentas(id_cuenta)
);

-- 5. Entidad: Solicitudes_Credito (Núcleo del dataset, sin los datos de IA)
CREATE TABLE Solicitudes_Credito (
    id_solicitud VARCHAR(20) PRIMARY KEY,
    id_cliente VARCHAR(20) NOT NULL,
    monto_solicitado DECIMAL(12, 2),
    plazo_meses INT,
    fecha_solicitud DATE,
    canal_solicitud VARCHAR(50),
    dispositivo VARCHAR(50),
    ip_pais VARCHAR(50),
    CONSTRAINT fk_solicitud_cliente FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

-- 6. Entidad: Resultados_Modelo_IA (Separado para garantizar auditoría y trazabilidad)
CREATE TABLE Resultados_Modelo_IA (
    id_solicitud VARCHAR(20) PRIMARY KEY,
    resultado_solicitud VARCHAR(20), -- Aprobado / Rechazado / Pendiente
    fraude_flag TINYINT(1),          -- 0 o 1
    fecha_evaluacion DATETIME,
    CONSTRAINT fk_resultado_solicitud FOREIGN KEY (id_solicitud) REFERENCES Solicitudes_Credito(id_solicitud)
);

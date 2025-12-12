CREATE DATABASE IF NOT EXISTS planmytrip
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE planmytrip;

-- Table: users
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre_completo VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    fecha_nacimiento DATE,
    telefono VARCHAR(20),
    rol ENUM('ADMIN', 'USUARIO', 'INVITADO') NOT NULL DEFAULT 'USUARIO',
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_rol (rol)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: itinerarios
CREATE TABLE IF NOT EXISTS itinerarios (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    titulo VARCHAR(255) NOT NULL,
    descripcion TEXT,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    presupuesto_total DECIMAL(10,2) DEFAULT 0.00,
    visibilidad ENUM('PUBLICO', 'PRIVADO') DEFAULT 'PRIVADO',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id),
    INDEX idx_fecha_inicio (fecha_inicio)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: actividades
CREATE TABLE IF NOT EXISTS actividades (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    itinerario_id BIGINT NOT NULL,
    tipo_actividad ENUM('TRANSPORTE','ALOJAMIENTO','COMIDA','TURISMO','COMPRAS','OTROS') NOT NULL,
    titulo VARCHAR(255) NOT NULL,
    descripcion TEXT,
    fecha_hora_inicio DATETIME NOT NULL,
    fecha_hora_fin DATETIME,
    ubicacion VARCHAR(255),
    costo DECIMAL(10,2) DEFAULT 0.00,
    moneda VARCHAR(3) DEFAULT 'USD',
    notas TEXT,
    archivos_adjuntos JSON,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (itinerario_id) REFERENCES itinerarios(id) ON DELETE CASCADE,
    INDEX idx_itinerario_id (itinerario_id),
    INDEX idx_fecha_hora_inicio (fecha_hora_inicio)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: destinos
CREATE TABLE IF NOT EXISTS destinos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    pais VARCHAR(100) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    descripcion TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_pais_ciudad (pais, ciudad)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: itinerario_destino (Many-to-Many)
CREATE TABLE IF NOT EXISTS itinerario_destino (
    itinerario_id BIGINT NOT NULL,
    destino_id BIGINT NOT NULL,
    orden INT NOT NULL,
    PRIMARY KEY (itinerario_id, destino_id),
    FOREIGN KEY (itinerario_id) REFERENCES itinerarios(id) ON DELETE CASCADE,
    FOREIGN KEY (destino_id) REFERENCES destinos(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: invitacion_itinerario
CREATE TABLE IF NOT EXISTS invitacion_itinerario (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    itinerario_id BIGINT NOT NULL,
    email_invitado VARCHAR(255) NOT NULL,
    token_acceso VARCHAR(255) NOT NULL UNIQUE,
    fecha_invitacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_expiracion TIMESTAMP NOT NULL,
    estado ENUM('PENDIENTE','ACEPTADA','EXPIRADA','RECHAZADA') DEFAULT 'PENDIENTE',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (itinerario_id) REFERENCES itinerarios(id) ON DELETE CASCADE,
    INDEX idx_token (token_acceso),
    INDEX idx_estado (estado)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: comentario_actividad
CREATE TABLE IF NOT EXISTS comentario_actividad (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    actividad_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    comentario TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (actividad_id) REFERENCES actividades(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_actividad_id (actividad_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Table: chat_itinerario
CREATE TABLE IF NOT EXISTS chat_itinerario (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    itinerario_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    mensaje TEXT NOT NULL,
    tipo ENUM('TEXTO','ARCHIVO','SISTEMA') DEFAULT 'TEXTO',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (itinerario_id) REFERENCES itinerarios(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_itinerario_id (itinerario_id),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

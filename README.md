# 🐾 Sistema de Gestión Veterinaria

Sistema web de gestión veterinaria desarrollado en ASP.NET Web Forms para administrar animales, eventos médicos e historias clínicas.

## 📋 Descripción

Aplicación web que permite gestionar de manera integral la información de una clínica veterinaria, incluyendo el registro de animales, eventos médicos y sus historias clínicas. El sistema incluye funcionalidades CRUD completas y un sistema de logging automático para auditoría.

## ✨ Características

- 🐶 **Gestión de Animales**: Registro, edición, eliminación y visualización de animales (Perros, Gatos, Aves)
- 📋 **Gestión de Eventos**: Administración de eventos médicos con descripción y escala de severidad
- 📝 **Historia Clínica**: Registro detallado de eventos médicos por animal con fecha y comentarios
- 🔍 **Visualización rápida**: Botón "Ver" para mostrar detalles de animales en notificaciones toast
- 📊 **Paginación y ordenamiento**: GridViews con soporte para paginación y ordenamiento de columnas
- 📁 **Sistema de logging**: Registro automático de todas las operaciones en archivo log.txt
- ✅ **Validaciones**: Validación de datos en todos los formularios

## 🛠️ Tecnologías Utilizadas

- **Framework**: ASP.NET Web Forms (.NET Framework)
- **Lenguaje**: C# (CodeBehind)
- **Base de Datos**: SQL Server
- **Frontend**: HTML5, CSS3, JavaScript
- **Controles**: GridView, SqlDataSource

## 📁 Estructura del Proyecto

```
ISSD_TP4_Veterinaria/
├── FAnimales.aspx              # Página principal (Vista)
├── FAnimales.aspx.cs           # Lógica de negocio (CodeBehind)
├── Web.config                  # Configuración y connection string
├── log.txt                     # Archivo de registro de operaciones
└── README.md                   # Este archivo
```

## 🗄️ Estructura de la Base de Datos

### Tabla: Animales
```sql
CREATE TABLE Animales (
    id INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(100) NOT NULL,
    especie INT NOT NULL  -- 1=Perro, 2=Gato, 3=Ave
);
```

### Tabla: Eventos
```sql
CREATE TABLE Eventos (
    id INT PRIMARY KEY IDENTITY(1,1),
    descripcion NVARCHAR(200) NOT NULL,
    escala INT NOT NULL
);
```

### Tabla: HistoriaClinica
```sql
CREATE TABLE HistoriaClinica (
    id INT PRIMARY KEY IDENTITY(1,1),
    fecha DATETIME NOT NULL,
    idAnimal INT NOT NULL,
    idEvento INT NOT NULL,
    comentario NVARCHAR(500),
    FOREIGN KEY (idAnimal) REFERENCES Animales(id),
    FOREIGN KEY (idEvento) REFERENCES Eventos(id)
);
```

## ⚙️ Configuración

### 1. Requisitos Previos

- Visual Studio 2019 o superior
- SQL Server 2014 o superior
- IIS Express (incluido en Visual Studio)
- .NET Framework 4.7.2 o superior

### 2. Configuración de la Base de Datos

Ejecuta el siguiente script SQL en tu SQL Server:

```sql
-- Crear la base de datos
CREATE DATABASE ISSD-TP4-202501;
GO

USE ISSD-TP4-202501;
GO

-- Crear tablas
CREATE TABLE Animales (
    id INT PRIMARY KEY IDENTITY(1,1),
    nombre NVARCHAR(100) NOT NULL,
    especie INT NOT NULL
);

CREATE TABLE Eventos (
    id INT PRIMARY KEY IDENTITY(1,1),
    descripcion NVARCHAR(200) NOT NULL,
    escala INT NOT NULL
);

CREATE TABLE HistoriaClinica (
    id INT PRIMARY KEY IDENTITY(1,1),
    fecha DATETIME NOT NULL,
    idAnimal INT NOT NULL,
    idEvento INT NOT NULL,
    comentario NVARCHAR(500),
    FOREIGN KEY (idAnimal) REFERENCES Animales(id),
    FOREIGN KEY (idEvento) REFERENCES Eventos(id)
);

-- Datos de prueba
INSERT INTO Animales (nombre, especie) VALUES 
('Rex', 1),
('Michi', 2),
('Tweety', 3);

INSERT INTO Eventos (descripcion, escala) VALUES 
('Vacunación', 1),
('Consulta General', 2),
('Cirugía', 5);

INSERT INTO HistoriaClinica (fecha, idAnimal, idEvento, comentario) VALUES 
('2024-01-15', 1, 1, 'Vacuna antirrábica aplicada'),
('2024-02-20', 2, 2, 'Control de rutina, todo normal');
```

### 3. Configurar Connection String

Edita el archivo `Web.config` y ajusta la cadena de conexión:

```xml
<connectionStrings>
  <add name="VeterinariaConnectionString" 
       connectionString="Data Source=TU_SERVIDOR;Initial Catalog=Veterinaria;Integrated Security=True" 
       providerName="System.Data.SqlClient" />
</connectionStrings>
```

**Reemplaza `TU_SERVIDOR` con:**
- `localhost` o `(localdb)\MSSQLLocalDB` para desarrollo local
- El nombre de tu servidor SQL Server

## 🚀 Instalación y Ejecución

### Opción 1: Clonar desde GitHub

```bash
# Clonar el repositorio
git clone https://github.com/tu-usuario/ISSD_TP4_Veterinaria.git

# Navegar al directorio del proyecto
cd ISSD_TP4_Veterinaria

# Abrir la solución en Visual Studio
start ISSD_TP4_Veterinaria.sln
```

### Opción 2: Inicializar un nuevo repositorio

Si estás creando el repositorio por primera vez:

```bash
# Inicializar repositorio Git
git init

# Agregar archivos al staging
git add .

# Hacer el primer commit
git commit -m "Initial commit: Sistema de gestión veterinaria"

# Agregar repositorio remoto
git remote add origin https://github.com/tu-usuario/ISSD_TP4_Veterinaria.git

# Subir los cambios
git push -u origin main
```

### Ejecución del Proyecto

1. Abre la solución en Visual Studio
2. Restaura los paquetes NuGet si es necesario
3. Configura la cadena de conexión en `Web.config`
4. Presiona `F5` o haz clic en "IIS Express" para ejecutar
5. El navegador se abrirá automáticamente en la página principal

## 📖 Uso del Sistema

### Gestión de Animales

1. **Agregar Animal**: 
   - Completa el nombre y selecciona la especie
   - Haz clic en "Agregar Animal"
   - Verás una notificación de confirmación

2. **Ver Detalles**:
   - Haz clic en el botón "Ver" junto al animal
   - Aparecerá un toast con la información

3. **Editar Animal**:
   - Haz clic en "Edit" en el GridView
   - Modifica los datos
   - Haz clic en "Update"

4. **Eliminar Animal**:
   - Haz clic en "Delete" en el GridView
   - Confirma la eliminación

### Gestión de Eventos

1. Completa descripción y escala del evento
2. Haz clic en "Agregar Evento"
3. Los eventos se pueden editar/eliminar desde el GridView

### Gestión de Historia Clínica

1. Selecciona la fecha del evento médico
2. Ingresa el ID del animal y del evento
3. Añade comentarios adicionales
4. Haz clic en "Agregar Historia"

## 📝 Sistema de Logging

Todas las operaciones quedan registradas en el archivo `log.txt`:

```
2024-10-05 14:30:25 - INSERT en Animales
2024-10-05 14:32:10 - UPDATE en Eventos
2024-10-05 14:35:45 - DELETE en HistoriaClinica
```

El archivo se genera automáticamente en la raíz del proyecto.

## 🔒 Seguridad

- Uso de parámetros SQL para prevenir inyección SQL
- Validación de datos en el servidor (CodeBehind)
- Manejo de excepciones con mensajes de error apropiados

## 🐛 Solución de Problemas

### Error de conexión a la base de datos
```
Verifica que:
- SQL Server esté ejecutándose
- La cadena de conexión sea correcta
- El usuario tenga permisos en la base de datos
```

### Los cambios no se guardan
```
Verifica que:
- Los eventos del SqlDataSource estén conectados correctamente
- El archivo log.txt tenga permisos de escritura
```

### Toast no se muestra
```
Verifica que:
- JavaScript esté habilitado en el navegador
- No haya errores en la consola del navegador (F12)
```

## 📊 Funcionalidades Principales

| Funcionalidad | Descripción | Estado |
|--------------|-------------|--------|
| CRUD Animales | Crear, leer, actualizar, eliminar | ✅ |
| CRUD Eventos | Crear, leer, actualizar, eliminar | ✅ |
| CRUD Historia | Crear, leer, actualizar, eliminar | ✅ |
| Visualización Toast | Notificaciones interactivas | ✅ |
| Sistema de Logging | Registro de operaciones | ✅ |
| Paginación | GridViews paginados | ✅ |
| Ordenamiento | Columnas ordenables | ✅ |



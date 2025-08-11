# Imagen base con Python 3.10
FROM python:3.10-slim

# Variables de entorno para evitar archivos .pyc y usar UTF-8
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Crear y usar un directorio para la app
WORKDIR /app

# Instalar dependencias del sistema necesarias para compilar paquetes
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copiar solo requirements primero (para aprovechar cache en builds futuros)
COPY requirements.txt /app/requirements.txt

# Instalar Flask 3.1.1 y Gunicorn
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el resto de la aplicación
COPY . /app

# Puerto interno del contenedor (Coolify lo mapea)
EXPOSE 8000

# Comando para iniciar con Gunicorn (app:app → archivo app.py con variable app)
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]

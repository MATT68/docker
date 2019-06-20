# Partimos de una imagen oficial de python
FROM python:2.7-slim

# Fijamos el directorio de trabajo como  /app
WORKDIR /app

# Copiamos el contenido del directorio actual dentro de la imagen en el directorio  /app
COPY . /app

# Instalamos los paquetes python que especificamos en el fichero requisitos
RUN pip install --trusted-host pypi.python.org -r requisitos.txt

# Publicamos el puerto 80 para acceso a la imagen/container desde el exterior
EXPOSE 80

# Definimos una variable de entorno
ENV NAME Amparoooo

# Cuando se lance el container se ejecuta app.py 
CMD ["python", "app.py"]

FROM eclipse-temurin:17-jdk-jammy

# Crear usuario para SSH
RUN useradd -ms /bin/bash spring_user_java

# Instalar OpenSSH
RUN apt-get update && \
    apt-get install -y openssh-server && \
    mkdir /var/run/sshd && \
    rm -rf /var/lib/apt/lists/*

# Configurar SSH para el usuario
RUN mkdir -p /home/spring_user_java/.ssh && \
    chown -R spring_user_java:spring_user_java /home/spring_user_java/.ssh && \
    chmod 700 /home/spring_user_java/.ssh

# Crear carpeta de despliegue del artefacto
RUN mkdir -p /home/spring_user_java/staging && \
    chown -R spring_user_java:spring_user_java /home/spring_user_java/staging

# Exponer puertos
EXPOSE 8080 22

# Iniciar solo SSH (la app la lanzas con Jenkins por ssh)
CMD ["/usr/sbin/sshd", "-D"]
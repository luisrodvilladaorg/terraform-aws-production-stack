FROM nginx:alpine

# Eliminamos config por defecto
RUN rm /etc/nginx/conf.d/default.conf

# Copiamos nuestra config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiamos la web estática
COPY state-site/ /usr/share/nginx/html/

EXPOSE 80

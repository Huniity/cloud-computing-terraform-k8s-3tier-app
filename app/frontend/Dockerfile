FROM nginx:alpine

RUN rm /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY html/ /usr/share/nginx/html/

COPY css/ /usr/share/nginx/html/static/css/
COPY js/ /usr/share/nginx/html/static/js/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

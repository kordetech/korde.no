FROM python:3.5
ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get install -y nginx supervisor && rm -rf /var/lib/apt/lists/*
# install uwsgi now because it takes a little while
RUN pip install uwsgi

# setup all the configfiles
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
COPY nginx-app.conf /etc/nginx/sites-available/default
COPY supervisor-app.conf /etc/supervisor/conf.d/


RUN mkdir /code
WORKDIR /code

RUN mkdir -p /media
VOLUME ["/code/media/"]

COPY requirements.txt /code/
RUN pip install -r requirements.txt

COPY . /code/
RUN python manage.py collectstatic --no-input

EXPOSE 80
CMD ["supervisord", "-n"]
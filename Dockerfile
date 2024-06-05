FROM hemanhp/djbase:4.2.4

# نصب ابزارهای لازم
RUN apk add --no-cache gcc musl-dev libffi-dev libpq postgresql-dev

# اضافه کردن wait-for-it
ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh /wait-for-it.sh
RUN chmod +x /wait-for-it.sh

EXPOSE 8000


COPY ./requirements /requirements
COPY ./scripts /scripts
COPY ./src /src

WORKDIR src


RUN pip install --upgrade pip
RUN /py/bin/pip install -r /requirements/development.txt

# RUN apk add  geos gdal


RUN chmod -R +x /scripts && \
    mkdir -p /vol/web/static && \
    mkdir -p /vol/web/media && \
    adduser --disabled-password --no-create-home djshop && \
    chown -R djshop:djshop /vol && \
    chmod -R 755 /vol


ENV PATH="/scripts:/py/bin:$PATH"

USER djshop

CMD ["sh", "-c", "/wait-for-it.sh db:5432 -- /scripts/run.sh"]

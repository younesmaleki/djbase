FROM python:3.12.2-alpine3.19

LABEL org.opencontainers.image.authors="younesmaleki.programming@gmail.com"
LABEL version="0.1"

# نصب ابزارهای لازم
RUN apk add --no-cache gcc musl-dev libffi-dev libpq postgresql-dev

# اضافه کردن wait-for-it
ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh /wait-for-it.sh
RUN chmod +x /wait-for-it.sh

COPY ./requirements /requirements
COPY ./scripts /scripts
COPY ./src /src

WORKDIR /src

# استفاده از pip در مسیر استاندارد
RUN pip install --upgrade pip
RUN pip install -r /requirements/development.txt

RUN chmod -R +x /scripts && \
    mkdir -p /vol/web/static && \
    mkdir -p /vol/web/media && \
    adduser --disabled-password --no-create-home djshop && \
    chown -R djshop:djshop /vol && \
    chmod -R 755 /vol

ENV PATH="/scripts:/usr/local/bin:$PATH"

USER djshop

EXPOSE 8000

CMD ["sh", "-c", "/wait-for-it.sh db:5432 -- /scripts/run.sh"]

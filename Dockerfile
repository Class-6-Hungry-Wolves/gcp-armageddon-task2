FROM python:3.13-slim-bookworm

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY . .

ENV PORT=8080

CMD [ "gunicorn", "--bind", "0.0.0.0:8080", "main:app" ]
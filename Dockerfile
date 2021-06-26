FROM python:3.7-slim-stretch
LABEL maintainer="Nestor Alvarado <n@nestortechtips.online>"
RUN pip3 install python-telegram-bot
WORKDIR app/
COPY . .
ENTRYPOINT ["python", "app/main.py"]
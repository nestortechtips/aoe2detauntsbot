FROM python:3.7-slim-stretch
LABEL maintainer="Nestor Alvarado <n@nestortechtips.online>"
WORKDIR app/
COPY . .
RUN pip3 install -r requirements.txt
ENTRYPOINT ["python", "app/main.py"]
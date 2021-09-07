FROM python:3.9-slim
LABEL maintainer="Nestor Alvarado <n@nestortechtips.online>"
WORKDIR app/
COPY . .
RUN pip3 install -r requirements.txt
ENTRYPOINT ["python", "app/main.py"]
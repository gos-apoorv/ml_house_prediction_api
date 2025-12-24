FROM python:3.10

WORKDIR /app

COPY requirements.txt .
RUN pip install  --upgrade pip
RUN pip install -r requirements.txt

COPY --chown=999:999 models/ app/models
COPY --chown=999:999 src/ src/models

COPY . .

EXPOSE 5001

CMD ["python", "app.py"]
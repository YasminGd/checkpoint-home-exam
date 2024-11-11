FROM python:3.9.20-alpine3.19

WORKDIR /app

COPY requirements.txt .
COPY app/app.py .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

CMD ["python", "app.py"]




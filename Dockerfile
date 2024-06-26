FROM python:3

WORKDIR /app
ADD app.py /app

RUN pip install flask requests
EXPOSE 4000

CMD ["python", "app.py"]

FROM python:3.10-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    curl \
    && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean

COPY backend/ /app/backend/
COPY frontend/ /app/frontend/

WORKDIR /app/frontend
RUN npm install

EXPOSE 8000 3000

CMD bash -c "python /app/backend/server.py & cd /app/frontend && npm start"

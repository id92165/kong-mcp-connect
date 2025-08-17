FROM node:20-alpine

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY . .

ENV NODE_ENV=production
ENV KONNECT_ACCESS_TOKEN=kpat_api_key_here
ENV KONNECT_REGION=us


EXPOSE 8080


CMD ["node", "build/index.js"]
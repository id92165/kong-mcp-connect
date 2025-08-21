FROM node:20 AS builder
WORKDIR /app

# Copy and install certificate
COPY zscal.crt /usr/local/share/ca-certificates/zscal.crt
RUN apt-get update && \
    apt-get install -y ca-certificates && \
    chmod 644 /usr/local/share/ca-certificates/zscal.crt && \
    update-ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build


FROM node:20-slim AS final
WORKDIR /app

# Copy and install certificate
COPY zscal.crt /usr/local/share/ca-certificates/zscal.crt
RUN apt-get update && \
    apt-get install -y ca-certificates && \
    chmod 644 /usr/local/share/ca-certificates/zscal.crt && \
    update-ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY package*.json ./
RUN npm ci --omit=dev
COPY --from=builder /app/build ./build
CMD ["node", "build/index.js"] 

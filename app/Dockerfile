FROM node:22-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# So here we are using a multi-stage build to create a smaller final image. The first stage (builder) installs the dependencies and builds the application, while the second stage copies the built application into a clean image without the development dependencies.

FROM node:22-alpine 
WORKDIR /app
COPY --from=builder /app .
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
RUN chown -R appuser:appgroup /app
USER appuser
EXPOSE 3000
CMD ["npm", "start"]
# README

Rails 8 + Tailwind + Solid

Databse: sqlite3

## Build

```
docker buildx build -t nerijunior/self-hosted-course-platform:latest .
```

## Docker compose

1. Create the Rails secret key
2. Set `YOUR_DOWNLOADED_COURSES_PATH` to the place where you organized your courses
3. Set `SOLID_QUEUE_IN_PUMA=true` to avoid the need of a secondary container for background jobs
4. Set `rails/storage` volume to have access to sqlite and active_record files.

```
services:
  cursos:
    image: nerijunior/self-hosted-course-platform:latest
    container_name: cursos
    restart: unless-stopped
    environment:
        SECRET_KEY_BASE: ${SECRET_KEY_BASE} # generate using rails credentials:edit -e production
        COURSES_PATH: /courses
        SOLID_QUEUE_IN_PUMA: true
    ports:
      - "127.0.0.1:3000:3000"
    volumes:
      - /YOUR_DOWNLOADED_COURSES_PATH:/courses
      - /home/{YOUR_USER}/servers/cursos/storage:/rails/storage
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/up"]
      interval: 30s
      timeout: 10s
      retries: 3
```
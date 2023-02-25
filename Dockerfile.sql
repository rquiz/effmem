# Base image
FROM postgres:15.2

# Set environment variables
ENV POSTGRES_USER=myuser
ENV POSTGRES_PASSWORD=mypassword
ENV POSTGRES_DB=mydb

# Copy the SQL files to create the database and user
COPY /postgres/create.sql /docker-entrypoint-initdb.d/

# Expose the PostgreSQL port
EXPOSE 5432

# Set the command to start PostgreSQL
CMD ["postgres"]
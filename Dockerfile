FROM mcr.microsoft.com/dotnet/sdk:8.0

RUN apt-get update && apt-get install -y \
    bash curl unzip ca-certificates

WORKDIR /server

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 7777

ENTRYPOINT ["/entrypoint.sh"]
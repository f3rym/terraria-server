FROM mcr.microsoft.com/dotnet/sdk:8.0

ARG TML_VERSION=v2026.07.3.0

RUN apt-get update && apt-get install -y --no-install-recommends \
        bash curl unzip ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /server/tmodloader

# tModLoader запекается в образ на этапе сборки
RUN curl -fL -o /tmp/tmodloader.zip \
        "https://github.com/tModLoader/tModLoader/releases/download/${TML_VERSION}/tModLoader.zip" \
    && unzip -q /tmp/tmodloader.zip -d /server/tmodloader \
    && rm /tmp/tmodloader.zip \
    && chmod +x start-tModLoaderServer.sh \
    && mkdir -p /root/.local/share/Terraria/tModLoader/Worlds

# Моды запекаются в образ (Mods/*.tmod + enabled.json)
COPY Mods/ /root/.local/share/Terraria/tModLoader/Mods/

EXPOSE 7777

ENTRYPOINT ["./start-tModLoaderServer.sh", \
    "-nographics", "-batchmode", \
    "-world", "/root/.local/share/Terraria/tModLoader/Worlds/Капризный_вымысел.wld", \
    "-difficulty", "2", \
    "-port", "7777"]

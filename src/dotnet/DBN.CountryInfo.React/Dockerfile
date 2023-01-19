# build project
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
RUN apt update && apt install -y nodejs npm && npm install -g n && n stable
WORKDIR /src
COPY . .
RUN dotnet restore && dotnet publish -c release -o /out

# create final image
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
COPY --from=build /out .
EXPOSE 80
EXPOSE 443
CMD ["dotnet", "/app/DBN.CountryInfo.React.dll"]
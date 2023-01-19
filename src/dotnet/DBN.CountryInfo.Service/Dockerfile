FROM mcr.microsoft.com/dotnet/aspnet:7.0.2-alpine3.17-amd64
WORKDIR /app
EXPOSE 80
EXPOSE 443

COPY ./src/dotnet/DBN.CountryInfo.Service/bin/release/net7.0/publish/ /app/
ENTRYPOINT ["dotnet", "DBN.CountryInfo.Service.dll"]
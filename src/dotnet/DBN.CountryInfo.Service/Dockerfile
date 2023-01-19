# build project
FROM mcr.microsoft.com/dotnet/sdk:7.0.102-alpine3.17-amd64 AS build
WORKDIR /src
COPY . .
RUN dotnet restore && dotnet publish -c release -o /out

# create final image
FROM mcr.microsoft.com/dotnet/aspnet:7.0.2-alpine3.17-amd64
WORKDIR /app
COPY --from=build /out/ .
EXPOSE 80
EXPOSE 443
CMD ["dotnet", "/app/DBN.CountryInfo.Service.dll"]
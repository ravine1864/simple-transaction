FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-end
WORKDIR /app

#Copy csproj and restore as distinct layers
COPY /src/Gateway/Gateway.WebApi/*.csproj ./
RUN dotnet restore

#Copy everything else and build
COPY /src/Gateway/Gateway.WebApi/* ./ 
RUN dotnet publish -c Release -o out

#Build runtime image
FROM mcr.microsoft.com/dotnet/runtime:5.0
WORKDIR /app
COPY --from=build-end /app/out .
ENTRYPOINT ["dotnet","Gateway.WebApi.dll"]

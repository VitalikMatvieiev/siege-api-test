FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["*/siege-api-test.csproj", "siege-api-test/"]
RUN dotnet restore "siege-api-test/siege-api-test.csproj"
COPY . .
WORKDIR "/src/siege-api-test"
RUN dotnet publish "siege-api-test.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final  
WORKDIR /app
COPY --from=build /app/publish .   
ENTRYPOINT ["dotnet", "siege-api-test.dll"]
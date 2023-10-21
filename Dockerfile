FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

#ENV ASPNETCORE_URLS=http://+:80

#FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:6.0 AS build
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
ARG configuration=Release
WORKDIR /src
COPY ["Contacts/Contacts.csproj", "Contacts/"]
COPY ["Contacts.Data/Contacts.Data.csproj", "Contacts.Data/"]
RUN dotnet restore "Contacts/Contacts.csproj"
COPY . .
WORKDIR "/src/Contacts"
RUN dotnet build "Contacts.csproj" -c $configuration -o /app/build

FROM build AS publish
ARG configuration=Release
RUN dotnet publish "Contacts.csproj" -c $configuration -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Contacts.dll"]

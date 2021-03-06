# Build stage
FROM microsoft/dotnet:2.1-sdk AS build-env
WORKDIR /generator

# restore
COPY api/. ./api/
RUN dotnet build api/api.csproj

COPY tests/. ./tests/
RUN dotnet build tests/tests.csproj

# copy src
#COPY . .

# test
ENV TEAMCITY_PROJECT_NAME=fake
RUN dotnet test tests/tests.csproj

# publish
RUN dotnet publish api/api.csproj -o /publish

# Runtime stage
FROM microsoft/dotnet:2.1-runtime
COPY --from=build-env /publish /publish
WORKDIR /publish
ENTRYPOINT ["dotnet", "api.dll"]
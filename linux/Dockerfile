FROM microsoft/mssql-server-linux:latest
LABEL project.url="https://github.com/litichevskiydv/MsSqlTools"
COPY setup.sh /
RUN chmod 777 setup.sh
ENV MSSQL_COLLATION=Cyrillic_General_CI_AS
CMD ./setup.sh && /opt/mssql/bin/sqlservr
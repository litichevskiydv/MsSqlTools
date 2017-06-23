FROM microsoft/mssql-server-linux:latest
COPY setup.sh /
RUN chmod 777 setup.sh
ENV MSSQL_COLLATION=Cyrillic_General_CI_AS
CMD ./setup.sh && /opt/mssql/bin/sqlservr
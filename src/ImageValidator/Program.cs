
namespace ImageValidator
{
    using System;
    using System.IO;
    using System.Linq;
    using System.Reflection;
    using System.Threading;
    using Dapper;
    using JetBrains.Annotations;
    using Microsoft.Extensions.Configuration;
    using Microsoft.Extensions.Options;
    using Skeleton.Dapper.ConnectionsFactory;

    [UsedImplicitly]
    static class Program
    {
        private static IConfigurationRoot _configuration;

        private static void BuildConfiguration(string[] commandLineArguments)
        {
            var environmentConfiguration = new ConfigurationBuilder()
                .AddCommandLine(commandLineArguments)
                .AddEnvironmentVariables("IMAGEVALIDATOR_")
                .Build();
            var environmentName = environmentConfiguration["environment"];

            _configuration = new ConfigurationBuilder()
                .SetBasePath(Path.GetDirectoryName(typeof(Program).GetTypeInfo().Assembly.Location))
                .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
                .AddCommandLine(commandLineArguments)
                .AddEnvironmentVariables()
                .Build();
        }

        static int Main(string[] args)
        {
            BuildConfiguration(args);
            Thread.Sleep(TimeSpan.FromMinutes(3));

            var connectionsFactory =
                new SqlConnectionsFactory(Options.Create(
                    new SqlConnectionsFactoryOptions {SqlServer = _configuration.GetConnectionString("SqlServer")}));
            using (var connection = connectionsFactory.Create())
            {
                var actualCollation = connection.Query<string>("select collation_name from sys.databases where name = 'tempdb'").Single();
                if (string.Equals(_configuration.GetValue<string>("ExpectedCollation"), actualCollation, StringComparison.OrdinalIgnoreCase) == false)
                    return 1;
            }

            return 0;
        }
    }
}
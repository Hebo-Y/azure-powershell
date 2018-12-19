﻿// ----------------------------------------------------------------------------------
//
// Copyright Microsoft Corporation
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// ----------------------------------------------------------------------------------

namespace Microsoft.Azure.Commands.AnalysisServices.Dataplane.Models
{
    /// <summary>
    /// Class to hold the endpoint format strings for dataplane cmdlets.
    /// </summary>
    class AsAzureEndpoints
    {
        public const string RestartEndpointPathFormat = "/webapi/servers/{0}/restart?api-version=2016-10-01";
        public const string LogfileEndpointPathFormat = "/webapi/servers/{0}/logfileHere";
        public const string SynchronizeEndpointPathFormat = "/servers/{0}/models/{1}/sync";

        // TODO: This might not belong here. May be fine to declare locally where it's referenced.
        public const string ClusterResolveEndpoint = "/webapi/clusterResolve";
        // TODO: This might not belong here. It's not technically an endpoint, but useful to have as a constant.
        public const string UriSchemeAsAzure = "asazure";
        // TODO: Remove this field. It will be added to another repo in another commit.
        public const string AzureAnalysisServicesEndpointSuffix = "asazure.windows.net";
    }
}

param location string
param projectName string
param environment string

param vnetCidr string
param privateSubnet1Cidr string
param privateSubnet2Cidr string
param publicSubnet1Cidr string
param publicSubnet2Cidr string

param natGatewayName string
/*
NOTE: Always remember that Azure creates "system" routes for each subnet by default. 
These system routes are listed in "Effective Routes" pane when observing a Route Tables properties
At least 1 nic must be provisioned in order to see the effective routes;
*/ 

/*
NOTE: By default, all Azure resources (VMs) have access to the internet via Dynamic NAT provided
by the Azure platform EVEN when they don't have a Public IP associated with them.
The best way to address this is to funnel those connections through a single NAT Gateway 

When a NAT gateway is attached to a subnet within a virtual network, the NAT gateway assumes the subnet’s default next 
hop type for all outbound traffic directed to the internet. No extra routing configurations are required.
*/ 

// TODO: integrate CLAN routes
var basePrivateRoutes  = [
{
  name: 'on-prem-thin-class1'
  properties: {
  addressPrefix: ''
  hasBgpOverride: false
  nextHopType: 'VnetLocal'
  }
 }
 {
  name: 'on-prem-thin-class2'
  properties: {
  addressPrefix: ''
  hasBgpOverride: false
  nextHopType: 'VnetLocal'
  }
 }
 {
  name: 'on-prem-thick'
  properties: {
  addressPrefix: ''
  hasBgpOverride: false
  nextHopType: 'VnetLocal'
  }
 }
]

// TODO: integrate CLAN routes
var basePublicRoutes  = [
  {
    name: 'on-prem-thick'
    properties: {
    addressPrefix: ''
    hasBgpOverride: false
    nextHopType: 'VnetLocal'
    }
   }
  ]

// TODO: enable route creation on-site
resource publicRouteTable 'Microsoft.Network/routeTables@2023-04-01' = {
  name: 'Public-Route-Table'
  location: location
  properties: {
    disableBgpRoutePropagation: true
    // routes: [for route in basePrivateRoutes: {
    //   name: route.name
    //   properties: {
    //     addressPrefix: route.properties.addressPrefix
    //     hasBgpOverride: route.properties.hasBgpOverride
    //     nextHopType: route.properties.nextHopType
    //   }
    // }]
  }
}

// TODO: enable route creation on-site
resource privateRouteTable 'Microsoft.Network/routeTables@2023-04-01' = {
  name: 'Private-Route-Table'
  location: location
  properties: {
    disableBgpRoutePropagation: true
    // routes: [for route in basePublicRoutes: {
    //   name: route.name
    //   properties: {
    //     addressPrefix: route.properties.addressPrefix
    //     hasBgpOverride: route.properties.hasBgpOverride
    //     nextHopType: route.properties.nextHopType
    //   }
    // }]
  }
}


// Public IP Properties NAT Gateway
var publicIpName = '${natGatewayName}-ip'
var publicIpAddress = [
  {
    id: publicIp.id
  }
]


// Public IP for NAT Gateway
resource publicIp 'Microsoft.Network/publicIPAddresses@2020-06-01' = {
  name: publicIpName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    // dnsSettings: {
    //   domainNameLabel: ''
    // }
  }
}


// NAT Gateway
resource natGateway 'Microsoft.Network/natGateways@2020-06-01' = {
  name: natGatewayName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    idleTimeoutInMinutes: 4
    publicIpAddresses: publicIpAddress
  }
}


// VNET
resource baseVirtualNetwork 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: '${projectName}-${environment}-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetCidr
      ]
    }
    // Subnets
    subnets: [
      {
        name: 'Private-Subnet-1'
        properties: {
          addressPrefix: privateSubnet1Cidr
          routeTable: {
            id: privateRouteTable.id
          }
          natGateway: {
            id: natGateway.id
          }
        }
      }
      {
        name: 'Private-Subnet-2'
        properties: {
          addressPrefix: privateSubnet2Cidr
          routeTable: {
            id: privateRouteTable.id
          }
          natGateway: {
            id: natGateway.id
          }
        }
      }
      {
        name: 'Public-Subnet-1'
        properties: {
          addressPrefix: publicSubnet1Cidr
          routeTable:{
            id: publicRouteTable.id
          } 
        }
      }
      {
        name: 'Public-Subnet-2'
        properties: {
          addressPrefix: publicSubnet2Cidr
          routeTable: {
            id: publicRouteTable.id
          }
        }
      }
    ]
  }
}

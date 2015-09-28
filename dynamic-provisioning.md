## Dynamic Provisioning (for Services) [IN PROGRESS]

Many CF service teams have requested for an easier way to provision dedicated service instances on demand. For example when developer issues `cf create-service mysql` command with certain configuration, they want to get access to a dedicated MySQL instance. Proposed way to implement such behavior is to have a service broker request a new deployment from the BOSH Director and wait for the Director to deploy required software with requested configuration. People have tried and succeeded created a service broker that does this before; however, IP allocation, AZ and job configuration, and few other problems make it hard for a service broker to build a deployment manifest.

In addition to just allowing to provision a pre-configured dedicated service instance, developers want to specify per service instance configuration during creation and/or updating of a service instance. Here are the categories of configuration developers want to be able to change:

1. allow to request smaller/larger sizes for VM/disk resources

	- Developer asks for a dedicated single Redis instance and then later wants to increase VM's RAM and persistent disk size, that Redis instance is running on without losing any data saved to Redis.
	- Developer asks for a dedicated RabbitMQ cluster which was sized as 'tiny' service plan and then wants to upgrade it to 'large' service plan. To do so, service broker would want to increase sizes of RabbitMQ nodes from small to larger.

2. allow to decrease/increase number of instances

	- Developer asks to grow RabbitMQ cluster from 1 instance to 2 instances in the same AZ.

3. allow to decrease/increase AZ split

	- Developer asks to improve HA of the service instance by placing at least one instance of RabbitMQ node in each AZ configured by the operator.

4. allow to configure service specific configuration

	- Developer asks to increase number of max connections their dedicated Redis instance allows.
	- Developer asks to increase replication factor for HDFS.
	- Developer wants to enable/disable certain RabbitMQ plugins.

5. allow to opt-in/opt-out for optional components

	- Developer asks to enable backup service for the Redis nodes so that Redis DB can be streamed to S3 bucket.

6. allow to upgrade service instance software on demand

	- Developer asks for a dedicated instance of MySQL 5.3 cluster and then wants to upgrade to MySQL 5.4, maintaining all the existing data and properly migrating data.

### Proposed Solution

To make it easier for a service broker to provision a dedicated service instance we are proposing to simplify the deployment manifest API such that service brokers do not need to manage IP allocation and AZ -> job translation, IaaS specific configurations, etc.

Here is the list of proposed changes to the BOSH Director:

- [separate IaaS specific configuration into its own configuration file](cloud-config.md)

	This allows service brokers to build IaaS agnostic deployment manifests and just reference specific resources by name. In addition to that it collapses variety of deployment manifests we have just because we have specific IaaS specific detials in them (e.g. cf-deployment-aws, cf-deployment-vsphere, etc.)

- [make AZ a first class Director feature](availability-zones.md)

	This allows service brokers to easily configure deployment jobs spanning multiple AZs instead of creating same deployment job per AZ.

- [introduce a way of letting deployment jobs reference other jobs' networking and properties (aka links)](links.md)

	This allows service brokers to easily make deployments that consist of multiple deployment jobs that reference each other.

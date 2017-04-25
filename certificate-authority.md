# BOSH as a Certificate Authority

For security reasons it makes sense to have secure communication channels for many things installed with BOSH, e.g. TLS instead of plain HTTP. Currently, creating the certificates necessary for TLS is a task left to the developer of a boshrelease. In detail, what has to be done is creating a root certificate and private key, create a signing request for the VM's ip address, and sign it using the root CA's private key.

This approach has the following drawbacks:
* Duplicate and error-prone work, as everybody has to do the same things for every release
* Generating the certificate itself is a tradeoff between security and convenience. You either:
  * create the certificates upfront and new for each VM that BOSH deploys. That's inconvenient. Or
  * put the root CA's private key on the VM so it can create the certificate during VM startup. That's not desired from a security perspective, as you want to have the root CA private key in as few places as possible.

## Proposed Solution: Director as Certificate Authority
The BOSH Director could take care of the flow, improving on the above drawbacks:
* director creates a root CA private key and certificate during initial setup/installation. The key never leaves the director.
* For each VM that is created:
  * create certificate signing request (CSR) with VMs IP address
  * create and sign Certificate
* VM certificates are injected by the director during template rendering. A VM can add a template e.g. called `ssl.cert` with a content such as `<%= certificate() %>`
* root CA certificate is provisioned in the same way as the [director's trusted_certificate option](http://bosh.io/jobs/director?source=github.com/cloudfoundry/bosh&version=255#p=director.trusted_certs), so VMs can talk to each other. Be sure to merge with additionally existing trusted_certs
* user can download root CA certificate from the director to validate VMs certificates when connecting


## Requirements
* An additional helper function (such as the above example `<%= certificate() %>`) or another way to define a 'certificate' type for templates needs to be available. This could look similar to [link types](https://github.com/cloudfoundry/bosh-notes/blob/master/links.md) 

## Details
During Director startup use openssl to generate root CA key and cert

```bash
openssl genrsa -out rootCA.key 2048
yes "" | openssl req -x509 -new -nodes -key rootCA.key \
  -out rootCA.pem -days 99999
```

For each VM, create a CSR and use the root CA key to sign it

```bash
name=$1
ip=$2

# golang requires to have SAN for the IP
cat >openssl-exts.conf <<-EOL
extensions = san
[san]
subjectAltName = IP:${ip}
EOL

echo "Generating certificate signing request for ${ip}..."
openssl req -new -nodes -newkey rsa:2048 \
  -out ${name}.csr -keyout ${name}.key \
  -subj "/C=US/O=BOSH/CN=${ip}"

echo "Generating certificate ${ip}..."
openssl x509 -req -in ${name}.csr \
  -CA rootCA.pem -CAkey rootCA.key -CAcreateserial \
  -out ${name}.crt -days 99999 \
  -extfile ./openssl-exts.conf

echo "Deleting certificate signing request and config..."
rm ${name}.csr
rm ./openssl-exts.conf
```

limitations:
* only works with manual networking, as IP must be known during VM creation time

TBD:
* what about floating IPs? should they be used in the cert if the VM has one?
* How long should the certificates be valid?
* How would rotation of CA key work (in case of revocation or end of validity)? Supposedly all clients should be able to support two CAs for an overlapping amount of time?

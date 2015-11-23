# Director Config

Contains Director configurations that can be dynamically changed for:

- [addons](addons.md)
	- not implemented yet
- CA certificates
	- currently requires Director redeploy

Example of `config.yml` used with `bosh update config ./config.yml`:

```
releases:
- {name: ipsec, version: latest}

addons:
- name: metron
  templates:
  - {name: metron_agent, release: loggregator}

trusted_certs: |
	# Comments are allowed in between certificate boundaries
  -----BEGIN CERTIFICATE-----
  MIICsjCCAhugAwIBAgIJAMcyGWdRwnFlMA0GCSqGSIb3DQEBBQUAMEUxCzAJBgNV
  BAYTAkFVMRMwEQYDVQQIEwpTb21lLVN0YXRlMSEwHwYDVQQKExhJbnRlcm5ldCBX
  ...
  ItuuqKphqhSb6PEcFMzuVpTbN09ko54cHYIIULrSj3lEkoY9KJ1ONzxKjeGMHrOP
  KS+vQr1+OCpxozj1qdBzvHgCS0DrtA==
  -----END CERTIFICATE-----
  # Some other certificate below
  -----BEGIN CERTIFICATE-----
  MIIB8zCCAVwCCQCLgU6CRfFs5jANBgkqhkiG9w0BAQUFADBFMQswCQYDVQQGEwJB
  VTETMBEGA1UECBMKU29tZS1TdGF0ZTEhMB8GA1UEChMYSW50ZXJuZXQgV2lkZ2l0
  ...
  VhORg7+d5moBrryXFJfeiybtuIEA+1AOwEkdp1MAKBhRZYmeoQXPAieBrCp6l+Ax
  BaLg0R513H6KdlpsIOh6Ywa1r/ID0As=
  -----END CERTIFICATE-----
```

Note: This command is similar to `update cloud-config` command but in this case config contains generic properties.

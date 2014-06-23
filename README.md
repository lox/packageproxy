# Package Proxy

A caching reverse proxy designed for caching package managers. Generates self-signed certificates on the fly to allow caching of https resources.

**Currently supported:**
  * Apt/Ubuntu

**Planned**
  * Composer
  * RubyGems
  * Npm
  * Docker Registry


## Running

Via Docker:

```bash
docker run --tty --interactive --rm --publish 3142:3142 --publish 3143:3143 lox24/package-proxy:latest
```

As a binary:

```bash
go get github.com/lox/package-proxy 
$GOBIN/package-proxy
```

By default package-proxy will only run the http proxy, to enable the https proxy:

```bash
$GOBIN/package-proxy -tls
```

## Configuring Package Managers

Where possible, Package Proxy is designed to work as an https/http proxy, so under Linux you should be able to configure it with:

```bash
export http_proxy=http://localhost:3142
export https_proxy=http://localhost:3143
```

Because Package Proxy uses generated SSL certificates (effectively a MITM attack), you need to install the certificate that it generates as a trusted root. **Do not do this unless you understand the security implications**.

**Under Ubuntu:**

```bash
curl -s http://<proxyaddress>:3143/package-proxy.pem > \
    /usr/local/share/ca-certificates/package-proxy.crt

update-ca-certificates
```


### Apt/Ubuntu

Apt will respect `https_proxy`, but if you'd rather configure it manually

```bash
echo 'Acquire::http::proxy "https://x.x.x.x:3142/";' >> /etc/apt/apt.conf
echo 'Acquire::https::proxy "https://x.x.x.x:3143/";' >> /etc/apt/apt.conf
```

### Development / Releasing

The provided `Dockerfile` will build a development environment. The code will be compiled on every run, so you only need to use `--build` once:

```bash
./docker.sh --build
./docker.sh --run 
```

Releasing is a bit complicated as it needs to be built under osx and linux: 

```bash
export GITHUB_TOKEN=xzyxzyxzyxzyxzy 

# under osx
./release-github.sh v0.6.0 darwin-amd64
./docker.sh --run

# now under linux
./release-github.sh v0.6.0 linux-amd64
exit

# now to build the busybox docker image
./release-docker.sh v0.6.0 
```


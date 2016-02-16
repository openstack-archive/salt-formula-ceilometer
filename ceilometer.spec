%global service ceilometer

Summary: Ceilometer Salt formula
Name: salt-formula-%{service}
Version: 0.2
URL: https://wiki.openstack.org/wiki/OpenStackSalt
Release: 1
License: ASL 2.0
Requires: salt-master
BuildArch: noarch
Source: http://tarballs.openstack.org/%{service}/salt-formula-%{service}.tar.gz

Requires(preun): systemd
Requires(postun): systemd

%description
Install and configure Ceilometer server and client.

%prep
%setup -q -n %{name}

%install
cp -r %{service}/files/* %{buildroot}/usr/share/salt-formulas/env/%{service}/files/.

install -D -m 644 %{service}/*.sls %{buildroot}/usr/share/salt-formulas/env/%{service}/
install -D -m 644 %{service}/*.jinja %{buildroot}/usr/share/salt-formulas/env/%{service}/

install -d -m 755 %{buildroot}/usr/share/salt-formulas/env/%{service}/meta
install -D -m 644 %{service}/meta/*.yml %{buildroot}/usr/share/salt-formulas/env/%{service}/meta/.

install -d -m 755 %{buildroot}/usr/share/salt-formulas/reclass/service/%{service}/agent/publisher
install -d -m 755 %{buildroot}/usr/share/salt-formulas/reclass/service/%{service}/server/publisher

install -D -m 644 metadata/service/agent/*.yml %{buildroot}/usr/share/salt-formulas/reclass/service/%{service}/agent/
install -D -m 644 metadata/service/server/*.yml %{buildroot}/usr/share/salt-formulas/reclass/service/%{service}/server/

install -D -m 644 metadata/service/agent/publisher/*.yml %{buildroot}/usr/share/salt-formulas/reclass/service/%{service}/agent/publisher/
install -D -m 644 metadata/service/server/publisher/*.yml %{buildroot}/usr/share/salt-formulas/reclass/service/%{service}/server/publisher/

install -D -m 644 metadata/service/*.yml %{buildroot}/usr/share/salt-formulas/reclass/service/%{service}/

%files
%license LICENSE
%doc README.rst
%doc CHANGELOG.rst
%doc VERSION
/usr/share/salt-formulas/env/%{service}/
/usr/share/salt-formulas/reclass/service/%{service}/

%preun
%systemd_preun salt-master.service

%postun
%systemd_postun_with_restart salt-master.service

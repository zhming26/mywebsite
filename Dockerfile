# MyWebSite Dockerfile

# Base images
FROM centos

# Base Pkg
#RUN rpm -ivh http://mirrors.aliyun.com/epel/epel-release-latest-7.noarch.rpm && \
RUN yum install -y epel-release.noarch && \
    yum install -y vim wget net-tools iproute telnet git mysql-devel redis  tree sudo psmisc

# FOR SSHD
RUN yum install -y openssh-clients openssl-devel openssh-server && \
    ssh-keygen  -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen  -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen  -A -t dsa -f /etc/ssh/ssh_host_dsa_key

# Set root password
RUN echo "root:123.com" |chpasswd


# Install Ngninx
RUN yum install -y nginx
ADD index.html /usr/share/nginx/html/index.html
RUN chmod a+r -R /usr/share/nginx/html

# Install Supervisord
RUN yum install -y supervisor && \
    yum clean all
ADD supervisord.conf /etc/supervisord.conf
ADD supervisord-nginx.ini /etc/supervisord.d/supervisord-nginx.ini
ADD supervisord-sshd.ini /etc/supervisord.d/supervisord-sshd.ini

# EXPOSE
EXPOSE 22 80

CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]

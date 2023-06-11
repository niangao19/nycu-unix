#include <stdio.h>
#include <sys/socket.h>
int main() {
    int sockfd = 0;
    struct sockaddr_in info;
    info.sin_family = AF_INET;
    sockfd = socket(AF_INET , SOCK_STREAM , 0);
    info.sin_addr.s_addr = inet_addr("123.123.13.12");
} // int main
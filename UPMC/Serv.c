/*******************************************************
Nom ......... : Serv.c
Role ........ : Serveur TCP/IP pour les commandes vocale de l'application Android 
Auteur ...... : Ziyed RIABI
Version ..... : V1.0
Licence ..... : GPL

Compilation :
gcc -Wall -o Serv Serv.c
Pour exécuter, tapez : ./Serv
********************************************************/
#include<stdio.h>
#include<string.h>    
#include<sys/socket.h>
#include<arpa/inet.h> 
#include<unistd.h>    
#include <stdlib.h>
#include <regex.h>
int main(int argc , char *argv[])
{
    int socket_desc , client_sock , c , read_size;
    struct sockaddr_in server , client;
    char client_message[50];
    int match;
    int err;
    int len_c;
    regex_t preg;
    FILE* fichier = NULL;
    char chaine[6];
    
    /*Construction d'un expression régulière pour vérifier le bon format de l'heure*/
    const char *str_regex = "^([0-1]?[0-9]|2[0-3])h[0-5][0-9]$"; 
    err = regcomp (&preg, str_regex, REG_NOSUB | REG_EXTENDED);
    socket_desc = socket(AF_INET , SOCK_STREAM , 0);
    if (socket_desc == -1)
    {
        printf("Could not create socket");
    }
    puts("Socket created");
    server.sin_family = AF_INET;
    server.sin_addr.s_addr = INADDR_ANY;
    server.sin_port = htons( 9519 );

    if( bind(socket_desc,(struct sockaddr *)&server , sizeof(server)) < 0)
    {
        perror("bind failed. Error");
        return 1;
    }
    puts("bind done");
    while(1){     
        listen(socket_desc , 3);
        puts("Atd CO");
        c = sizeof(struct sockaddr_in);
        client_sock = accept(socket_desc, (struct sockaddr *)&client, (socklen_t*)&c);
        if (client_sock < 0)
        {
            perror("accept failed");
            return 1;
        }
        puts("Connection OK");
     

        while(read_size = recv(client_sock , client_message , 50 , 0)>0 )
        {

	    
	    len_c = strlen(client_message);
	    client_message[(len_c - 1)] = '\0';
	    printf("%s \n",client_message);
            /*Commande vocale Start ou start pour demarer le moteur*/
	    if(strcmp(client_message,"Start") == 0)
	    {
		system("/bin/RunMotor.sh");
	    }
	    else if(strcmp(client_message,"start") == 0)
	    {
		system("/bin/RunMotor.sh");
	    }
	    else 
     	    {	
				
      	    	match = regexec (&preg, client_message, 0, NULL, 0);
            
	    if (match == 0)
            {
		char CronForm[60];
		int i = 0;
		int j = 0;
		char Heure[4];
		char Minute[4];
         	printf ("%s est une heure valide\n", client_message);
		fichier = fopen("/var/www/html/Site/Site/cron.tab", "a+");
		int Len = strlen(client_message);
		do 
		{
			Heure[i] = client_message[i];
			i++;
		}while(client_message[i] != 'h');
		do
		{
			Minute[j] = client_message[i+1];
			j++;
			i++;
		}while(i != Len);
		fflush(stdin);
		fflush(stdout);
		printf("Heure %s\n",Heure);
		printf("Minute %s\n",Minute);
                /*Mise en forme de l'heure et la date au format Cron (Mm Hh Dd Yy Cmd)*/
		sprintf(CronForm,"\n%s %s * * * /bin/RunMotor.sh\n",Minute,Heure);
		if(fichier != NULL){
			/*Ecriture de la commande Cron dans le fichier Cron.tab*/
			fputs(CronForm, fichier);
			fclose(fichier);
		}
		memset(Heure, 0x00, 4);
		memset(Minute, 0x00, 4);
		memset(CronForm, 0x00, 60);		
      		}
      		else if (match == REG_NOMATCH)
      		{
         		printf ("%s n\'est pas une heure valide\n", client_message);
      		}
		else
		{
			printf ("%s n\'est pas une heure valide\n", client_message);
		}

	    }
	    
	    memset(client_message, 0x00, 50);		
        }
        if(read_size == 0)
        {
            puts("Client disconnected");
            fflush(stdout);
        }
        else if(read_size == -1)
        {
            perror("recv failed");
        }   
   }
   
   regfree(&preg);
   return 0;
}



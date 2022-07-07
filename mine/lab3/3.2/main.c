#define _CRT_SECURE_NO_WARNINGS
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#define OK 1
#define ERROR 0

typedef struct samples {
	unsigned char SAMID[9];
	int SDA, SDB, SDC, SF;
}SAMPLES;
 SAMPLES s[3] = { "TEST",256809, -1023,1265,0};
 SAMPLES LOWF[100], MIDF[100], HIGHF[100];
 int lowf_pointer,midf_pointer,highf_pointer,s_pointer,F;
extern void __stdcall getsf(int a, int b, int c);
extern void __stdcall tolowf();
extern void __stdcall tomidf();
extern void __stdcall tohighf();
int login(void)
{
	char user_name[20];
	char password[20];
	for (int i = 0; i < 3;) {
		printf("ÇëÊäÈëÓÃ»§Ãû£º ");
		scanf("%s", user_name);
		if (strcmp(user_name, "zhuzicheng")) {
			printf("ÓÃ»§Ãû´íÎó£¡\n");
			i++;
			continue;
		}
		printf("ÇëÊäÈëÃÜÂë£º   ");
		scanf("%s", password);
		if (strcmp(password, "zhuzicheng")) {
			printf("ÃÜÂë´íÎó");
			i++;
			continue;
		}
		printf("µÇÂ½³É¹¦!\n");
		return OK;
	}

	printf("´íÎó!\n");
	return ERROR;
}
void printhighf(void) {
	int j = highf_pointer / 25;
	for (int i = 0; i < j; i++) {
		printf("SAMID: %s SDA: %d SDB: %d SDC: %d SF: %d\n", HIGHF[i].SAMID, HIGHF[i].SDA, HIGHF[i].SDB, HIGHF[i].SDC, HIGHF[i].SF);
	}
}
void printmidf(void){
	int j = midf_pointer / 25;
	for (int i = 0; i < j; i++) {
		printf("SAMID: %s SDA: %d SDB: %d SDC: %d SF: %d\n", MIDF[i].SAMID, MIDF[i].SDA, MIDF[i].SDB, MIDF[i].SDC, MIDF[i].SF);
	}
}
int control(void) {
	getchar();
	char get;
	while (1) {
		scanf("%c", &get);
		if (get == 'M') {
			scanf("%s%d%d%d", s[0].SAMID, s[0].SDA, s[0].SDB, s[0].SDC);
		}
		else if(get == 'Q'){
			return 1;
		}
		else if (get == 'R') {
			return 0;
		}
	}

}

int main() {
	int check = login();
	if (check == 0)return 0;
	while (1) {
		for (int i = 0; i < 3; i++) {
			getsf(s[i].SDA, s[i].SDB, s[i].SDC);
			s[i].SF = F;
			if (F < 100) {
				tolowf();
			}
			else if (F == 100) {
				tomidf();
			}
			else {
				tohighf();
			}
		}
		printmidf();
//		printhighf();
		s_pointer = 0;
		int next = control();
		if (next == 0)continue;
		else return 0;
	}

}
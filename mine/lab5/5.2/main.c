#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#define len 10000000 //�ڴ濽������Ϊ 60000000
char src[len], dst[len]; //Դ��ַ��Ŀ�ĵ�ַ
int len1 = len;
extern void __stdcall memorycopy(char* dst, char* src, int len1); //�����ⲿ����

int main()
{
	clock_t t;
	int i, j;
	//Ϊ��ʼ��ַ�θ�ֵ���Ա�����Ӹõ�ַ�ζ�ȡ���ݿ���
	for (i = 0; i < len - 1; i++)
	{
		src[i] = 'a';
	}
	src[i] = 0;
	t = clock();
	memorycopy(dst, src, len1); //�����ã�ִ����Ӧ����Ρ�
	t = clock() - t;
	//�ó�Ŀ�����ε�ִ��ʱ�䡣
	printf("memorycopy time is %11u s\n", t);
	return 0;
}
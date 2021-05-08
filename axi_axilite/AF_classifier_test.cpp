#include "AF_classifier.hpp"
#include<iostream>

int main()
{
	float in[50],out[50];
	int ct=0;
	int re;
	int length=30;
	for(int i=0;i<length;i++)
		in[i]=(float)(i*i);
	AF_classifier(in,out,&re,30);
	for(int i=0;i<length;i++)
	{
		if(out[i]==(float)i)
			ct++;
	}
	if(ct==length)
		std::cout<<re<<"PASS"<<std::endl;
	else
		std::cout<<re<<"FAIL"<<std::endl;
	return 0;
}

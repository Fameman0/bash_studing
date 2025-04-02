#!/bin/bash

function Count_log {
	general_quite=0

	while read -r line; do
		general_quite=$((general_quite+1))
	done < access.log
	printf 'Общее количество запросов:\t %s\n' "$general_quite" >> $1

}

touch report.txt
echo "Отчет о логе веб-сервера" > report.txt
echo "========================" >> report.txt
Count_log "report.txt"

awk '
{
	!U[$1]++
	count=0
}
END {
	for (unique in U){
		count++
	}
	printf "Количество уникальных IP-адресов:\t %s\n", count >> "report.txt"
		

}
' access.log

echo "Количество запросов по методам:" >> report.txt

awk '
BEGIN{
	cnt_GET=0
	cnt_POST=0
	cnt_PUT=0
}
{
	if (substr($6,2)=="GET"){
		cnt_GET++
	}
	if (substr($6,2)=="POST"){
		cnt_POST++
	}
	if (substr($6,2)=="PUT"){
		snt_PUT++
	}
}
END {
	if (cnt_GET!=0){
		printf "\t%s %s\n", cnt_GET, "GET" >> "report.txt"
	}
	if (cnt_POST!=0){
		printf "\t%s %s\n", cnt_POST, "POST" >> "report.txt"
	}
	if (cnt_PUT!=0){
		printf "\t%s %s\n", cnt_PUT, "PUT" >> "report.txt"
	}
}
' access.log

awk '
{
	URL[FNR]=$7
	!U[$7]++
	n=1
	max=0
}
END{

	for (val in U){
		count[n,2]=val
		for (i=1;i<=FNR;i++){
			if (val==URL[i]){
				count[n,1]++
	
			}
		}
		n++
	}
	for (i=1;i<=n;i++){
		if (count[i,1]>max){
			max = count[i,1]
		}
	}
	for (i=1;i<=n;i++){
		if (count[i,1]==max){
			printf "Самый популярный URL:\t %s %s\n", count[i,1], count[i,2] >> "report.txt"
		}
	}
}
' access.log

echo "Отчет сохранен в файл report.txt"



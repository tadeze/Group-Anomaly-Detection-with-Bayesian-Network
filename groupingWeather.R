#group the weather data
#transposing and labelling the response variable ...take max(status)
dataset <-read.csv('../Atmp_SPEN_area.csv')
lstT1 <-data.frame() #// list()
lstT2 <- data.frame() #list()
lstD <- list()
stations <- unique(dataset$STID)
for(sensor in stations)
{	
	station <- dataset[dataset$STID==sensor,]
	t1 <- data.frame()
	t2 <- data.frame()
	#d12 <- data.frame()
	for(day in unique(station$Date))
	{ 
		dayDt <- station[station$Date==day,]
		q1 <- max(dayDt$QT1)
		q2 <- max(dayDt$QT2)
		#   		#discard the QC=9
		#   		if(q1<5 | q2<5)
		#   		{
		
		if(q2 >0) q2 <- 1
		if(q1 >0) q1 <- 1
		t1 <- rbind(t1,data.frame(day,t(dayDt$T1),q1))
		# if(q2<5)
		t2 <- rbind(t2,data.frame(day,t(dayDt$T2),q2))
		
	#	d12 <- rbind(d12,data.frame(day,t(dayDt$T1-dayDt$T2),max(q1,q2)))
		#   		}
	}
	lstT1 <- rbind(lstT1,data.frame(sensor,t1))
	lstT2 <- rbind(lstT2,data.frame(sensor,t2))
	#lstD[[sensor]] <- d12
	#write.table(t1,file=paste0(direct,'tmp-',sensor,'-','t1.csv'),sep=',',row.names=F,quote=F)
	#write.table(t2,file=paste0(direct,'tmp-',sensor,'-','t2.csv'),sep=',',row.names=F,quote=F)
	#write.table(d12,file=paste0(direct,'tmp-',sensor,'-','d12.csv'),sep=',',row.names=F,quote=F)
	
}
write.table(lstT1,'../T1readings_2008.csv',row.names=F,quotes=F)\
write.table(lstT2,'../T2readings_2008.csv',row.names=F,quotes=F)
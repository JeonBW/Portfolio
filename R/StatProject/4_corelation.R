# 담배값을 인상전의 월별 매출액과 담배값 인상 후의 월별 매출액
# 귀무가설 : 담배값 인상과 흡연은 관계가 없다.
# 대립가설 : 담배값 인상과 흡연은 관계가 있다. 

x <- c(70, 72, 62, 64, 71, 76, 0, 65, 75, 72)
y <- c(70, 74, 65, 68, 72, 74, 61, 66, 76, 75)

#상관계수는 -1~1 / 0에가까우면 관계가 없음/ -1에 가까우면 음의 상관관계
#1에 가까우면 양의 상관관계
cor(x, y, method = "pearson")
cor(x, y, method = "spearman")
cor(x, y, method = "kendal")

cor.test(x, y, method="pearson")
# 담바갮을 인상과 흡연은 상관관계가 있다. 


##### 실습 2 #####
mydata <- read.csv("../data/cor.csv", header=T)
View(mydata)

# pop_gorwth : 인구증가율
# elderly_rate : 65세 이상 노령인구 비율
# finance : 재정자립도 
# curtural_center : 인구 10만명당 문화기반시설 수

# 인구가증가율에 따라 65세 이상 노령인구 비율이 관계가 있는지
plot(mydata$pop_growth, mydata$elderly_rate)
# 음의 상관관계가 나올것이라고 추측

cor(mydata$pop_growth, mydata$elderly_rate, method="pearson")
cor(mydata$pop_growth, mydata$elderly_rate, method="spearman")
cor(mydata$pop_growth, mydata$elderly_rate, method="kendal")
# 인구가 늘어날떄마다 노령인구는 줄어든다 (강하게 나타나지는 않는다.)

# 많은 변수에 대해 상관분석을 해야 한다면
attach(mydata)
x <- cbind(pop_growth, birth_rate, elderly_rate, finance, cultural_center)
cor(x)

detach(mydata)

##### 실습 3  #####
install.packages("UsingR")
library(UsingR)

str(galton)
View(galton)

plot(child ~ parent, data=galton)

cor.test(galton$child, galton$parent)

#분포를 대표할 수 있는 회귀선 
out<-lm(galton$child ~ galton$parent, data=galton)
summary(out)

#Interceptdml Estimate : 절편 galton$parent의 Estiamte : 기울기 

abline(out, col='red')
#선에 가까운 점은 의미있는 값 /오차가 적은것
#선에 먼것은 우연히 발생한 값

# 반올림되어서 규칙적으로 있는 것들을 흔들어 주는 jitter 
plot(jitter(child, 5) ~ jitter(parent,5), data=galton)
abline(out, col='red')

# 5는 반올림안에서 흔든다는 뜻

sunflowerplot(galton)

install.packages("SwissAir")
library(SwissAir)
View(AirQual)

Ox <- AirQual[ , c("ad.O3", "lu.O3", "sz.O3")] + AirQual[ , c("ad.NOx", "lu.NOx", "sz.NOx")] -
  AirQual[ , c("ad.NO", "lu.NO", "sz.NO")]
head(Ox)
names(Ox) <- c("ad", "lu", "sz")
head(Ox)

plot(lu~sz, data=Ox)
#밀도를 더 잘 표현하기 위한 

install.packages("hexbin")
library(hexbin)
bin = hexbin(Ox$lu, Ox$sz, xbins=50)
plot(bin)

# 몽환적으로
smoothScatter(Ox$lu, Ox$sz)

#히트맵처럼
install.packages("IDPmisc")
library(IDPmisc)
iplot(Ox$lu, Ox$sz)


ayo<-read.csv("../data/imdae.csv", header=T)
str(ayo)
byo<-read.csv("C:/Users/Master/Desktop/R/서울교통공사_역별_일별_시간대별_승하차인원_20201031.csv", header=T)
str(byo)

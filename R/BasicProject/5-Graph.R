##### 기본 내장 그래프 #####
#plot()
#plot(y축 데이터, 옵션)
#plot(x축데이터, y축 데이터, 옵션)


#데이터가 하나만 넘어오면 기본적으로 Y축값, X축값은 자동 증가
y<-c(1, 1, 2, 2, 3, 3, 4, 4, 5, 5)
plot(y) 
#두개의 데이터를 넘어올때는 X값을 먼저
x<-1:10
y<-1:10
plot(x,y)
?plot
plot(x,y, xlim = c(0,20))
plot(x,y, xlim = c(0,3))
plot(x,y, xlim=c(0,20), ylim=c(0,30), main="Graph",
     type="o", pch=3)

#barplot() 막대, hist() 히스토, pie()원, mosaicplot(),
#pair(), persp(), contour(),.....

#그래프 배열
head(mtcars)
?mtcars
str(mtcars)
#그래프 4개 그리기
par(mfrow=c(2,2)) #2행 2열로 겹쳐서
plot(mtcars$wt, mtcars$mpg)
plot(mtcars$wt, mtcars$disp)
hist(mtcars$wt) 
boxplot(mtcars$wt)

par(mfrow=c(1,1))
plot(mtcars$wt, mtcars$mpg)

#히스토그램은 양적, 막대그래프는 질적 데이터에사용 
#히스토그램은 데이터가 한개만 있어도 가능 / 막대그래프는 반드시 2개가 있어야 한다.

#행 또는 열마다 그래프 갯수를 다르게 설정
?layout
layout(matrix(c(1, 2, 3, 3),2, 2, byrow=T))
plot(mtcars$wt, mtcars$mpg)
plot(mtcars$wt, mtcars$disp)
hist(mtcars$wt) 

par(mfrow=c(1,1))


### 특이한 그래프

# arrows 
x<- c(1, 3, 6, 8, 9)
y<- c(12, 56, 78, 32, 9)
plot(x,y)
arrows(3, 56, 1, 12)
text(4, 40, "이것은 샘플입니다", srt=55)

#꽃잎 그래프
x<- c(1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 4, 5, 6, 6, 6)
y<- c(2, 1, 4, 2, 3, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1 )
plot(x, y)
?sunflowerplot
z<-data.frame(x,y)
sunflowerplot(z)

#별 그래프 : 데이터의 전체적인 윤곽을 살펴보는 그래프
#데이터 항목에 대한 변화의 정도를 한눈에 파악
head(mtcars)
str(mtcars)
stars(mtcars[1:4], flip.labels = F, key.loc=c(13, 1.5),
      draw.segments = T)

# symbols
x <- c(1, 2, 3, 4, 5)
y <- c(2, 3, 4, 5, 6)
z <- c(10, 5, 100, 20, 10)
symbols(x, y, z)













##### ggplot2 그래프 #####
#https://www.r-graph-gallery.com/ggplot2-package.html

#레이어 지원
# 1) 배경 설정
# 2) 그래프 추가(점, 막대, 선,...)
# 3) 설정 추가(축 범위, 범례, 색, 표시,....)
library(ggplot2)

### 산포도
head(mpg)
ggplot(data=mpg, aes(x=displ, y=hwy))
# aes() : x축과 y축 설정
ggplot(data=mpg, aes(x=displ, y=hwy)) + geom_point()
ggplot(data=mpg, aes(x=displ, y=hwy)) + geom_point() + 
  xlim(3,6) + ylim(10, 30)

ggplot(mpg, aes(displ, hwy))+ geom_point()

# midwest 데이터를 이용하여 전체인구(poptotal)와 
# 아시아 인구(popasian)간에 어떤 관계가 있는지 알아보려고 한다.
# X축은 전체인구, Y축은 아시아 인구
# 단 전체 인구는 30만명 이하, 아시아 인구는 1만명 이하인 지역만 산포도로 표시
options(scipen=99)
ggplot(midwest, aes(poptotal, popasian)) + geom_point() + 
  xlim(0, 300000) + ylim(0, 10000)


### 막대 그래프 : geom_col() > 막대그래프, geom_bar() > 히스토그램
library(dplyr)

#mpg 데이터에서 구동방식(drv)별로 고속도로 평균연비를 조회하고 결과를 막대그래프로 출력
head(mpg)
mpg_2 <- mpg %>% group_by(drv) %>% summarise(mean_hwy=mean(hwy))
mpg_2

ggplot(mpg_2, aes(reorder(drv, -mean_hwy), mean_hwy)) + geom_col()


#구동방식별로 차가 몇대 있는지 
ggplot(mpg, aes(drv)) + geom_bar()
# 고속도로 연비 별로 차가 몇대가 있는지 6
ggplot(mpg, aes(hwy)) + geom_bar()

# 어떤 회사에서 생산한 "suv" 차종의 도시 연비가 높은지 알아보려고 한다. "suv"차종을 대상으로 평균 cty가 가장 높은 회사 다섯 곳을 막대그래프로 출력(막대는 연비가 높은 순으로 정렬)
mpg_1 <- mpg %>% group_by(manufacturer) %>% filter(class=="suv") %>% summarise(mean_cty=mean(cty)) %>% arrange(desc(mean_cty)) %>% head(5)
mpg_1
ggplot(mpg_1, aes(reorder(manufacturer, -mean_cty), mean_cty)) + geom_col()


#자동차 중에서 어떤 종류(class)가 가장 많은지 알아보려고 한다. 자동차 종류별 빈도를 막대 그래프로 출력
ggplot(mpg, aes(class)) + geom_bar()

table(mpg$class)

### 선 그래프 : geom_line()
str(economics)
head(economics)
tail(economics)
?economics

ggplot(economics, aes(date, unemploy)) + geom_line()
ggplot(economics, aes(date, psavert)) + geom_line()


### 상자 그래프 

ggplot(mpg, aes(drv, hwy)) + geom_boxplot()


### 참고
# 치트 시트 : Help > Cheatsheets > DATA Visualization with  ggplot2

# mpg 데이터에서 calss가 "compact", "subcompact", "suv"인 자동차의 cty가 어떻게 다른지 비교
# 세 차종의 cty를 나타낸 상자 그래프를 출력
mpg_2 <- mpg %>% filter(class=="compact"|class=="subcompact"|class=="suv") %>% group_by(class)
mpg_2 <- mpg %>% filter(class %in% c("compact","subcompact","suv"))
mpg_2
ggplot(mpg_2,aes(class, cty)) + geom_boxplot()




##### 인터랙티브 그래프 #####
#https://plot.ly/ggplot2/
install.packages("plotly")
library(plotly)

#색깔 별로
p <- ggplot(mpg, aes(displ, hwy, col=drv))+ geom_point() 
#기본적인 인터랙티브 제공
ggplotly(p) 

#dodge 막대를 나란히 하게 하는 옵션
str(diamonds)
ggplot(diamonds, aes(cut)) + geom_bar()
p<-ggplot(diamonds, aes(cut, fill=clarity)) + geom_bar(position = "dodge")
ggplotly(p)

### 시계열 데이터 (시간의 흐름에따라 데이터가  변화하는)
install.packages("dygraphs")
library(dygraphs)

head(economics)

#날짜 data 형식을 xts타입으로 변환 날짜와 똑같이 순서대로 이어질 수 있게
library(xts)
#날짜 순서대로 무엇을 보고자 할 것인지
eco <- xts(economics$unemploy, order.by=economics$date)
eco
class(eco)

dygraph(eco)
dygraph(eco) %>% dyRangeSelector()

#저축률 
eco_a <- xts(economics$psavert, order.by=economics$date)
#실업자수(1000을 나눈 것은 저축률과 단위를 맞추기 위해서)
eco_b <- xts(economics$unemploy/1000, order.by=economics$date)

eco_2 <- cbind(eco_a, eco_b)
eco_2

colnames(eco_2)<- c("psavert","unemploy")
head(eco_2)

dygraph(eco_2)


##### 지도 그래프 : 단계 구분도, Choropleth map #####
install.packages("ggiraphExtra")
library(ggiraphExtra)

str(USArrests)
head(USArrests)
class(USArrests)
#행이름을 컬럼으로
library(tibble)
crime<- rownames_to_column(USArrests, var="state")
str(crime)
#ggiraphExtra 안에 있는 지도 데이터는 전부 소문자이기때문에 대문자가 있다면 소문자로 바꿔줘야 한다.
crime$state <- tolower(crime$state)
str(crime)

library(ggplot2)
install.packages("maps")
library(maps)
state_map <- map_data("state")
str(state_map)

install.packages("mapproj")
library(mapproj)
?ggChoropleth()
ggChoropleth(data=crime, aes(fill=Murder, map_id=state), state_map, interactive = T)

#대한민국 지도 만들기
#https://github.com/cardiomoon/kormaps2014
install.packages("stringi")
library(stringi)
install.packages("devtools")
library(devtools)

devtools::install_github("cardiomoon/kormaps2014")
library(kormaps2014)


head(korpop1)
str(korpop1)

head(kormap1)
str(kormap1)

#문자 코드 변경
korpop1 <- changeCode(korpop1)
head(korpop1)
str(korpop1)

#사용할 컬럼을 한글에서 영어로 변경
library(dplyr)
korpop1 <- rename(korpop1, pop="총인구_명", name="행정구역별_읍면동")
str(korpop1)
library(ggplot2)
library(ggiraphExtra)
ggChoropleth(data=korpop1, aes(fill=pop, map_id=code, tooltip=name), 
             map=kormap1, interactive = T)



#결핵환자 데이터
str(tbc)
head(tbc)


head(tbc)
str(tbc)

ggChoropleth(data=tbc, aes(fill=NewPts, map_id=code, tooltip=name1), 
             map=kormap1)



##### 간단한 텍스트 마이닝 #####
#문자열로부터 무엇인가를 도출하기 위한 것
#중요한 단어를 뽑아오는 것이 중요 
#한글에 대한 형태소 작업 
library(rJava)
install.packages("memoise")
library(memoise)
# install.packages("KoNLP") 아직 최신버전에 등록되지 않음

# RTools 설치
install.packages("multilinguer")
install.packages(c('stringr', 'hash', 'tau', 'Sejong', 'RSQLite', 'devtools'), type = "binary")
install.packages("remotes")
remotes::install_github('haven-jeon/KoNLP', upgrade = "never", INSTALL_opts=c("--no-multiarch"))





library(KoNLP)


#형태소 분석을 위한 단어사전(120만여개의 단어)
useNIADic()
extractNoun("아버지가방에들어가신다")

extractNoun("대한민국의 영토는 한반도와 그 부속도서로 한다.")
txt <- readLines("../data/hiphop.txt")
head(txt)
class(txt)
str(txt)
# 특수문자 제거 
library(stringr)
length(txt)
txt<- str_replace_all(txt,"\\W", " ")
head(txt, 100)
tail(txt,50)

#명사들을 추출해내는 
nouns <- extractNoun(txt)
class(nouns)
nouns[1:10]
#list를 벡터로 변환
unlist(nouns)
wordcount <- table(unlist(nouns)) #빈도수 구하기 
wordcount[50:60]

# 데이터 프레임으로 변환 
df_word <- as.data.frame(wordcount, stringsAsFactors = F) #문자열을 팩터로 바꾸지 않게 하기 위해서
head(df_word, 10)
str(df_word)
library(dplyr)

# 변수명 바꾸기

df_word <- rename(df_word, word=Var1, freq=Freq)
head(df_word,10)
str(df_word)


# 두 글자 이상 단어 추출 
df_word <- filter(df_word, nchar(word) >= 2)
head(df_word, 10)

# top 20 확인
df_word %>% arrange(desc(freq))%>% head(20)

# wordcloud로 확인
install.packages("wordcloud")
library(wordcloud)
#한번 발생한 난수를 고정(결과가 똑같이 나올 수 있게)
set.seed(1234)

wordcloud(words = df_word$word, freq = df_word$freq, min.freq=2, scale=c(4, 0.3), color=brewer.pal(8, "Dark2"), random.order = F)


#연습문제

twitter <- read.csv("../data/twitter.csv")
twitter_a <- twitter %>% select(내용) 
str(twitter_a)


twitter_a <- str_replace_all(twitter_a,"\\W", " ")
nouns_twitter <- extractNoun(twitter_a)
class(nouns_twitter)
nouns_twitter[1:10]

unlist(nouns_twitter)
wordcount <- table(unlist(nouns_twitter)) #빈도수 구하기 (df_word, 10)
wordcount[50:60]

df_word <- as.data.frame(wordcount, stringsAsFactors = F)
head(df_word, 10)
str(df_word)
library(dplyr)
df_word <- rename(df_word, word=Var1, freq=Freq)
df_word <- filter(df_word, nchar(word) >= 2)
tail(df_word)
df_word <- filter(df_word, nchar(word) >= 2)
head(df_word, 10)
df_word %>% arrange(desc(freq))%>% head(20)
